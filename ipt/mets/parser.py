"""
Implements mets.xml parsing for file validation purposes. Premis.xml and
addml.cml paring are impolemented in separate modules, but used here.
"""
import os

import lxml.etree

from ipt.utils import url2path
from ipt.premis import premis
from ipt.addml import addml


NAMESPACES = {'xlink': 'http://www.w3.org/1999/xlink',
              'mets': 'http://www.loc.gov/METS/',
              'premis': 'info:lc/xmlns/premis-v2',
              'addml': 'http://www.arkivverket.no/standarder/addml',
              'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
              'kdk': 'http://www.kdk.fi/standards/mets/kdk-extensions'}


def ns_prefix(namespace, tag=''):
    """Return namespace URI prefix for given namespace.

    :namespace: Name of the namespace
    :returns: Prefix for element tag

    """
    return '{%s}%s' % (NAMESPACES[namespace], tag)


class LXML(object):
    """
    This class parses METS XML files and provides methdos for querying
    information from individual elements.
    """

    def __init__(self, filename, xmlroot=None):
        if os.path.isdir(filename):
            filename = os.path.join(filename, 'mets.xml')
        self.mets_path = filename
        self._xmlroot = xmlroot

    def xmlroot(self):
        """
        Get a root element of XML document given in initialization of this
        class.

        Returns:
        Root element of XML document as lxml.ElementTree object.
        """

        if self._xmlroot is None:
            self._xmlroot = lxml.etree.parse(self.mets_path)
        return self._xmlroot

    def mets_files(self):
        """
        Mets files.
        """
        results = self.xmlroot().xpath('//mets:file', namespaces=NAMESPACES)
        return results

    def iter_elements_with_id(self, identifiers):
        """Iterate all metadata elements under <amdSec> with given list of
        AMDID's.

        Parameter can be list or string where values are separated with
        whitespace.

        :admid_list: List of ADMID's (list or string)
        :returns: Iterable for all references metadata elements

        """
        if isinstance(identifiers, str):
            identifiers = identifiers.split()
        for identifier in identifiers:
            yield self.element_with_id(identifier)

    def element_with_id(self, identifier):
        """Return single element with given ADMID.

        ADMID is single unqiue reference to one of the following elements::

            <techMD>, <sourceMD>, <rightsMD>, <digiprovMD>

        :admid: ADMID as string
        :returns: References element

        """
        query = "//*[@ID='%s']" % identifier
        results = self.xmlroot().xpath(query, namespaces=NAMESPACES)
        if len(results) == 1:
            return results[0]
        else:
            raise ValueError(
                "Invalid indentifier '%s'. Less or more than 1 result(s) "
                "was found: %s" % (identifier, results))

    def get_fileinfo_iterator(self, filter_=None):
        """
        Get fileinfo iterator.

        :filter: Filter for the iterator, controlled vocabulary:
            'file-format-validation': Skip file if
            USE='no-file-format-validation' in METS
        """
        for mets_file in self.mets_files():
            # Files marked with USE='no-file-format-validation' omitted with
            # filter 'file-format-validation'
            file_use = mets_file.attrib.get('USE', '').strip()
            if filter_ == 'file-format-validation' and \
                    file_use == 'no-file-format-validation':
                continue
            # Note: ADMID may contain several IDs separated with spaces
            admid = mets_file.attrib['ADMID']
            fileinfo = self.get_fileinfo_with_admid(admid)

            yield fileinfo

    def get_fileinfo_with_admid(self, admid):
        """
        Return dict that contains information for mets:file.

            fileinfo["filename"]
            fileinfo["algorithm"]
            fileinfo["digest"]
            fileinfo["format"]["version"]
            fileinfo["format"]["mimetype"]
            fileinfo["format"]["format_registry_key"]
            fileinfo["object_id"]["type"]
            fileinfo["object_id"]["value"]
        """
        filename = os.path.join(
            os.path.dirname(self.mets_path),
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

    def get_addml(self):
        """find addml field from mets."""
        results = self._xmlroot.xpath(".//addml:addml", namespaces=NAMESPACES)
        if len(results) == 0:
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
        return filename

    def get_file_object_id_with_admid(self, admid):
        """
        Get file object id with admid.
        """
        admid = admid.replace('  ', ' ').split(' ')
        attr_expr = ' or '.join(map(lambda x: "@ID='%s'" % x, admid))

        # Find the first (the only) objectIdentifier element in the file
        # elements, no matter how deep in the element hierarchy

        query = '//mets:techMD[%s]//premis:object' % attr_expr
        object_id = self.xmlroot().xpath(query, namespaces=NAMESPACES)
        if object_id is None:
            return None
        return object_id[0]

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


class MdWrap(object):

    """Helper class for accessing metadata wrapper inside
    <techMD>, <sourceMD>, <rightsMD> and <digiprovMD> elements.

    """

    def __init__(self, element):
        """Initialize class instance with given `element`.

        :element: ElementTree object containing <mdWrap>
        """
        self.element = element

    @property
    def mdtype(self):
        """MDTYPE"""
        return self.mdwrap_attr('MDTYPE')

    @property
    def mdtype_version(self):
        """MDTYPEVERSION"""
        return self.mdwrap_attr('MDTYPEVERSION')

    @property
    def other_mdtype(self):
        """OTHERMDTYPE"""
        return self.mdwrap_attr('OTHERMDTYPE')

    @property
    def xmldata(self):
        """xmlData"""
        return self.element.xpath(
            'mets:mdWrap/mets:xmlData/*', namespaces=NAMESPACES)[0]

    def mdwrap_attr(self, name):
        """Return attribute from mdWrap attribute"""
        return self.element.xpath(
            'mets:mdWrap', namespaces=NAMESPACES)[0].attrib[name]

    def __str__(self):
        """TODO: Docstring for __str__.
        :returns: TODO

        """
        return lxml.etree.tostring(self.element)


class MetsFile(object):

    """Helper class for accessing METS file parameters"""

    def __init__(self, element):
        """Initialize class with given mets:file element

        :element: ElementTree object
        """
        self.element = element

    @property
    def use(self):
        """Return value from mets:file/ADMID attribute.

        :returns: ADMID as string

        """
        return self.element.attrib.get('USE', '').strip()

    @property
    def admid(self):
        """Return value from mets:file/ADMID attribute.

        :returns: ADMID as string

        """
        return self.element.attrib["ADMID"]

    @property
    def href(self):
        """Return file location `href` attribute from `mets:file/mets:fLocat`

        :returns: Location as string

        """
        return self.flocat_attr(ns_prefix('xlink', 'href'))

    def flocat_attr(self, name):
        """Return attribute from mdWrap attribute"""
        return self.element.xpath(
            'mets:FLocat', namespaces=NAMESPACES)[0].attrib[name]
