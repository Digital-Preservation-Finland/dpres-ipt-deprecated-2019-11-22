import os
import lxml.etree
import urllib

from ipt.premis import premis
from ipt.addml import addml


NAMESPACES = {'xlink': 'http://www.w3.org/1999/xlink',
              'mets': 'http://www.loc.gov/METS/',
              'premis': 'info:lc/xmlns/premis-v2',
              'addml': 'http://www.arkivverket.no/standarder/addml',
              'xsi': 'http://www.w3.org/2001/XMLSchema-instance'}


class LXML(object):
    """
    This class parses METS XML files and provides methdos for querying
    information from individual elements.
    """

    def __init__(self, filename, xmlroot=None):
        if os.path.isdir(filename):
            filename = os.path.join(filename, 'mets.xml')

        self.filename = filename
        self.sip_dir = os.path.dirname(filename)
        self._xmlroot = xmlroot

    def xmlroot(self):
        """
        Get a root element of XML document given in initialization of this
        class.

        Returns:
        Root element of XML document as lxml.ElementTree object.
        """

        if self._xmlroot is None:
            self._xmlroot = lxml.etree.parse(self.filename)
        return self._xmlroot

    def get_file_location(self, mets_file):
        """
        Get a file location url from METS XML document. For example

        Get the file url eg.

            .. code-block:: xml
        <mets:FLocat xlink:href="file://kuvat/PICT0081.JPG" LOCTYPE="URL"/>
        """

        file_url = mets_file.xpath('mets:FLocat/@xlink:href',
                                   namespaces=NAMESPACES)
        if len(file_url) > 0:
            return urllib.unquote(file_url[0])
        else:
            return None

    def mets_files(self):
        """
        Mets files.
        """
        return self.xmlroot().xpath('//mets:file', namespaces=NAMESPACES)

    def get_fileinfo_iterator(self, filter_=None):
        """
        Get fileinfo iterator.

        :filter: Filter for the iterator, controlled vocabulary:
            'file-format-validation': Skip file if USE='no-file-format-validation' in METS
        """
        for mets_file in self.mets_files():
            # Files marked with USE='no-file-format-validation' omitted with
            # filter 'file-format-validation'
            file_use = mets_file.attrib.get('USE', '').strip()
            if filter_ == 'file-format-validation' and file_use == 'no-file-format-validation':
                continue
            # Note: ADMID may contain several IDs separated with spaces
            admid = mets_file.attrib['ADMID']
            fileinfo = self.get_fileinfo_with_admid(admid)

            yield fileinfo

    def get_fileinfo_with_admid(self, admid):
        """
        Return dict that contains information for mets:file.

            fileinfo["filename"]
            fileinfo["digest_algorithm"]
            fileinfo["digest_hex"]
            fileinfo["format_version"]
            fileinfo["format_mimetype"]
            fileinfo["format_registry_key"]
            fileinfo["object_id"]
        """
        filename = os.path.join(
            self.sip_dir,
            self.get_filename_with_admid(admid))

        filename_dict = {"filename": filename}

        addml_etree = self.get_addml()
        premis_object_etree = self.get_file_object_id_with_admid(admid)
        premis_object_data_dict = premis.to_dict(premis_object_etree)
        addml_data_dict = addml.to_dict(addml_etree)
        result_dict = self.merge_dicts(
            filename_dict,
            premis_object_data_dict,
            addml_data_dict)
        return result_dict

    def merge_dicts(self, *dicts):
        """
        Merge N dicts.
        :dicts: a list of dicts.
        :returns: one merged dict
        """
        result = {}
        for dictionary in dicts:
            result.update(dictionary)
        return result

    def get_addml(self):
        """find addml field from mets."""
        results = self._xmlroot.xpath(".//addml:addml", namespaces=NAMESPACES)
        if not results:
            return None
        return results[0]


    def get_filename_with_admid(self, admid):
        """@todo: Docstring for get_filename_with_admid

        :admid: @todo
        :returns: @todo

        <mets:file ID="img0001-master"
                        CREATED="2013-08-07T13:36:37+03:00"
                        ADMID="img0001-master-techmd agent_cryptopp_5.5.1
                        agent_docworks_6.6.1.18 agent_dw-jk
                        agent_freeimage_3.15.1 agent_jhove_1.5
                        agent_unknown_unknown img0001-master-event00001
                        img0001-master-event00002 img0001-master-event00003
                        img0001-master-event00004 img0001-master-event00005"
                        MIMETYPE="image/tiff" GROUPID="1"
                        OWNERID="URN:NBN:fi-fd2009-00002919-img0001-master"
                        CHECKSUM="2bef5516bf629def11e24b7671b89ec95f704504c ...
                       CHECKSUMTYPE="SHA-512" SIZE="6593519">
                                                       <mets:FLocat
                                                        LOCTYPE="URL"
                                                        xlink:href="file://..."
        </mets:file>
        """
        attr_expr = ', '.join(["contains(concat(' '",
                               "normalize-space(@ADMID)",
                               "' ')",
                               "normalize-space(' %s '))"]) % admid

        query = '//mets:file[%s]' % attr_expr

        file_ = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        if not file_:
            return None
        filename = self.get_file_location(file_[0])
        filename = filename.replace('file://', '').replace('./', '')
        return filename

        name = format.xpath('.//premis:formatName', namespaces=NAMESPACES)
        name = ' '.join(map(lambda x: x.text, name))
        name = self.parse_mimetype(name)

        version = format.xpath('.//premis:formatVersion', namespaces=NAMESPACES)
        version = ' '.join(map(lambda x: x.text, version))

        registry_key = format.xpath(
            './/premis:formatRegistryKey', namespaces=NAMESPACES)
        registry_key = ' '.join(map(lambda x: x.text, registry_key))

        return {
            'mimetype': name['mimetype'],
            'charset': name['charset'],
            'alt-format': name['alt-format'],
            'version': version,
            'registry_key': registry_key
        }

    def get_file_object_id_with_admid(self, admid):
        """
        Get file object id with admid.
        """
        admid = admid.replace('  ', ' ').split(' ')
        attr_expr = ' or '.join(map(lambda x: "@ID='%s'" % x, admid))

        # Find the first (the only) objectIdentifier element in the file
        # elements, no matter how deep in the element hierarchy

        query = '//mets:techMD[%s]//premis:object' % attr_expr
        object_id = self.xmlroot().xpath(query, namespaces=NAMESPACES)[0]
        if not object_id:
            return None

        return object_id
