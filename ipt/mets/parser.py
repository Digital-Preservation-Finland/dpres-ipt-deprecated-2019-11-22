import os
import lxml.etree
import urllib
from email.message import Message

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

        file_url = mets_file.xpath('m:FLocat/@xlink:href',
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

    def get_fileinfo_iterator(self, filter=None):
        """
        Get fileinfo iterator.
        
        :filter: Filter for the iterator, controlled vocabulary:
            'file-format-validation': Skip file if USE='no-file-format-validation' in METS
        """
        for mets_file in self.mets_files():
            # Files marked with USE='no-file-format-validation' omitted with
            # filter 'file-format-validation'
            file_use = mets_file.attrib.get('USE', '').strip()
            if filter == 'file-format-validation' and file_use == 'no-file-format-validation':
                continue
            # Note: ADMID may contain several IDs separated with spaces
            admid = mets_file.attrib['ADMID']
            fileinfo = self.get_fileinfo_with_admid(admid)

            yield fileinfo

    def get_fileinfo_array(self, filter=None):
        """
        Get fileinfo array.
        """
        array = []
        for fileinfo in self.get_fileinfo_iterator(filter):
            array.append(fileinfo)

        return array

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
        premis_object_etree = self.get_premis_object()
        premis_object_data_dict = premis.to_dict(premis_object_etree)
        addml_data_dict = addml.to_dict(addml_etree)
        result_dict = self.merge_dicts(
            filename_dict,
            premis_object_data_dict,
            addml_data_dict)
        print result_dict
        return result_dict
        """result = {
            'filename': filename,
            'object_id': object_id,
            'fixity': {
                'algorithm': fixity["algorithm"],
                'digest': fixity["digest"]
            },
            'format': file_format
        }"""

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

    def get_addml():

    def parse_mimetype(self, mimetype):
        """Parse mimetype information from Content-type string.

        ..seealso:: https://www.ietf.org/rfc/rfc2045.txt
        """
        msg = Message()
        msg.add_header('Content-type', mimetype)

        mimetype = msg.get_content_type()
        charset = msg.get_param('charset')
        alt_format = msg.get_param('alt-format')

        return {
            'mimetype': mimetype,
            'charset': charset,
            'alt-format': alt_format
        }

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

        # print "query", query
        # print "admid", admid, "file", file

        if not file_:
            return None
        filename = self.get_file_location(file_[0])
        filename = filename.replace('file://', '')
        return filename

    def get_file_format_with_admid(self, admid):
        """
        Get file format with admid.
        """
        admid = admid.replace('  ', ' ').split(' ')
        attr_expr = ' or '.join(map(lambda x: "@ID='%s'" % x, admid))

        query = '//mets:techMD[%s]//premis:format' % attr_expr
        format = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        if not format:
            return None

        format = format[0]


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

    def get_tech_md_list_for_file(self, file_path, mets_path):
        """Get a list of techmd sections from mets.xml for a certain file described
        in the fileSec.
        :file_path: a full path of digital object.
        :mets_path: a full path of mets.xml
        :returns: a dict of all relevant techmd data for validation purposes."""
        mets_tree = lxml.etree.parse(mets_path)
        filename = os.path.relpath(file_path, os.path.dirname(mets_path))
        if filename.startswith('../'):
            filename = filename.replace('../', '')

        adm_ids = self._get_adm_id_for_file(mets_tree, filename)
        adm_id_string = self. _get_adm_id_attribute_string(adm_ids)
        query = ".//mets:techMD%s" % adm_id_string
        techmds = mets_tree.xpath(query, namespaces=NAMESPACES)

        return techmds

    def _get_adm_id_attribute_string(self, adm_ids):
        """Make an attribute string for xpath query.
        :adm_ids: a list of mets admids.
        :returns: a string with format: [ID=abc|ID=123|...]"""
        adm_id_string = "["
        for adm_id in adm_ids:
            adm_id_string = "%s@ID='%s' or " % (adm_id_string, adm_id)
        adm_id_string = adm_id_string[:-4]
        adm_id_string = "%s]" % adm_id_string
        return adm_id_string

    def get_file_fixity_with_admid(self, admid):
        """ Return dict that contains fixity digest and algorithm

            { "algorithm":"md5", "digest":"11c128030f203b76f2e30eeb7454c42b" }

        If ADMID is 'tech-1 rights-1 dp-1, this will construct a XPath query
        like:

            //m:techMD[@ID='tech-1' or @ID='rights-1' or @ID='dp-1']

        This query returns all techMD elements in METS namespace that have an
        ID attribute with value 'tech-1', 'rights-1' or 'dp-1'.

        For the resulted techMD element we read first premis:fixity element
        that contains premis:messageDigestAlgorithm and premis:messageDigest
        elements."""

        admid = admid.replace('  ', ' ').split(' ')
        attr_expr = ' or '.join(map(lambda x: "@ID='%s'" % x, admid))

        # Find the first (the only) fixity element in the file elements,
        # no matter how deep in the element hierarchy

        query = '//mets:techMD[%s]//premis:fixity' % attr_expr
        fixity = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        # print "query", "admid", query, admid
        # print "fixity", fixity

        if not fixity:
            return None

        fixity = fixity[0]

        algorithm = fixity.xpath('premis:messageDigestAlgorithm',
                                 namespaces=NAMESPACES)[0].text
        digest = fixity.xpath('premis:messageDigest',
                              namespaces=NAMESPACES)[0].text

        if not (algorithm and digest):
            return None

        algorithm = algorithm.lower().replace('-', '').strip()
        digest = digest.lower().strip()

        return {"algorithm": algorithm, "digest": digest}

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

        object_id = object_id[0]

        # algorithm = object_id.xpath('p:messageDigestAlgorithm',
        #                         namespaces=NAMESPACES)[0].text
        # digest = object_id.xpath('p:messageDigest',
        #                      namespaces=NAMESPACES)[0].text

        id_type = object_id.xpath('p:objectIdentifierType',
                                  namespaces=NAMESPACES)[0].text

        id_value = object_id.xpath('p:objectIdentifierValue',
                                   namespaces=NAMESPACES)[0].text

        if not (id_type or id_value):
            return None

        return {"value": id_value, "type": id_type}
