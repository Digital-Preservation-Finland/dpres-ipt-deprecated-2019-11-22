import lxml.etree
import urllib

NAMESPACES = {'xlink': 'http://www.w3.org/1999/xlink',
              'm': 'http://www.loc.gov/METS/',
              'p': 'info:lc/xmlns/premis-v2'}


class LXML(object):
    """
    This class parses METS XML files and provides methdos for querying
    information from individual elements.
    """

    def __init__(self, filename, xmlroot=None):
        self.filename = filename
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
        return self.xmlroot().xpath('//m:file', namespaces=NAMESPACES)

    def get_fileinfo_iterator(self):
        """
        Get fileinfo iterator.
        """
        for mets_file in self.mets_files():
            # Note: ADMID may contains several IDs separated with spaces
            admid = mets_file.attrib['ADMID']
            fileinfo = self.get_fileinfo_with_admid(admid)
            # print "yield fileinfo", fileinfo
            yield fileinfo

    def get_fileinfo_array(self):
        """
        Get fileinfo array.
        """
        array = []
        for fileinfo in self.get_fileinfo_iterator():
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

        fixity = self.get_file_fixity_with_admid(admid)
        format = self.get_file_format_with_admid(admid)
        filename = self.get_filename_with_admid(admid)
        filename = filename.replace('file://', '')
        object_id = self.get_file_object_id_with_admid(admid)

        if fixity is None:
            fixity = {
                "algorithm": None,
                "digest": None
            }

        if format is None:
            format = {
                "version": None,
                "mimetype": None,
                "registry_key": None
            }

        # FIXME: There's a unit test case which bypasses mets.xml input and
        #        assumes that there's object_id
        if object_id is None:
            object_id = {
                "value": ""
            }

        return {
            'filename': filename,
            'object_id': object_id,
            'fixity': {
                'algorithm': fixity["algorithm"],
                'digest': fixity["digest"]
            },
            'format': {
                'mimetype': format["mimetype"],
                'version': format["version"],
                'registry_key': format["registry_key"]
            }
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

        query = '//m:file[%s]' % attr_expr

        file_ = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        # print "query", query
        # print "admid", admid, "file", file

        if not file_:
            return None

        return self.get_file_location(file_[0])

    def get_file_format_with_admid(self, admid):
        """
        Get file format with admid.
        """
        admid = admid.replace('  ', ' ').split(' ')
        attr_expr = ' or '.join(map(lambda x: "@ID='%s'" % x, admid))

        query = '//m:techMD[%s]//p:format' % attr_expr
        format = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        # print "query", "admid", query, admid
        # print "format", format

        if not format:
            return None

        format = format[0]

        # print lxml.etree.tostring(format)

        name = format.xpath('.//p:formatName', namespaces=NAMESPACES)
        name = ' '.join(map(lambda x: x.text, name))

        version = format.xpath('.//p:formatVersion', namespaces=NAMESPACES)
        version = ' '.join(map(lambda x: x.text, version))

        registry_key = format.xpath(
            './/p:formatRegistryKey', namespaces=NAMESPACES)
        registry_key = ' '.join(map(lambda x: x.text, registry_key))

        return {"mimetype": name,
                "version": version,
                "registry_key": registry_key}

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

        query = '//m:techMD[%s]//p:fixity' % attr_expr
        fixity = self.xmlroot().xpath(query, namespaces=NAMESPACES)

        # print "query", "admid", query, admid
        # print "fixity", fixity

        if not fixity:
            return None

        fixity = fixity[0]

        algorithm = fixity.xpath('p:messageDigestAlgorithm',
                                 namespaces=NAMESPACES)[0].text
        digest = fixity.xpath('p:messageDigest',
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

        query = '//m:techMD[%s]//p:objectIdentifier' % attr_expr
        object_id = self.xmlroot().xpath(query, namespaces=NAMESPACES)

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
