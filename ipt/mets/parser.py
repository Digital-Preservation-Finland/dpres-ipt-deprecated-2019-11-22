"""Classes for reading METS XML-files"""

import os

import lxml.etree

NAMESPACES = {'xlink': 'http://www.w3.org/1999/xlink',
              'mets': 'http://www.loc.gov/METS/',
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
        """Return string representation of the object"""
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
