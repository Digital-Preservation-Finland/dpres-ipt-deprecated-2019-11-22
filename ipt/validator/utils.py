"""Helpers for validation"""

import os

from ipt.utils import merge_dicts, uri_to_path, parse_mimetype
import ipt.addml.addml
import ipt.videomd.videomd
import ipt.audiomd.audiomd
import mets
import premis


def mdwrap_to_fileinfo(mdwrap_element):
    """Extract fileinfo dict from mdwrap element.

    TODO: This should be implemented in metadata-parser classes, similar
    implementation is already working with digital object validators::

        class MdParser:
            def is_supported(mdwrap_object):
                ...
            def from_xmldata(elementtree_object):
                ...
            def to_json():
                ...

        def md_to_fileinfo():
            parsers [ MdParser, ... ]
            for parser in parsers:
                if not MdParser.is_supported(mdwrap):
                    continue
                merge_dict(
                    fileinfo,
                    MdParser().from_xmldata(mdwrap.xmldata).to_json())

    :mdwrap: mdWrap element as ElementTree object
    :returns: Metadata parser function for the mdWrap element

    """
    if mdwrap_element is None:
        return {}

    wraptype = mets.parse_wrap_mdtype(mdwrap_element)
    mdtype = wraptype['mdtype']
    othermdtype = wraptype['othermdtype']

    standard_parsers = {
        'PREMIS:OBJECT': premis_to_dict
    }

    other_parsers = {
        'ADDML': ipt.addml.addml.to_dict,
        'VideoMD': ipt.videomd.videomd.to_dict,
        'AudioMD': ipt.audiomd.audiomd.to_dict
    }

    try:
        if othermdtype is not None:
            return other_parsers[othermdtype](mets.parse_xmldata(mdwrap_element))
        return standard_parsers[mdtype](mets.parse_xmldata(mdwrap_element))
    except KeyError:
        return {}


def iter_fileinfo(mets_tree, mets_path):
    """Iterate all files in given mets document and return fileinfo
    dictionary for each file.

    :mets_parser: ipt.mets.parser.LXML object
    :returns: Iterable on fileinfo dictionaries

    """

    for element in mets.parse_files(mets_tree):

        loc = mets.parse_flocats(element)[0]
        object_filename = os.path.join(
            os.path.dirname(mets_path),
            uri_to_path(mets.parse_href(loc)))

        fileinfo = {
            'filename': object_filename,
            'use': mets.parse_use(element),
            'format':{'mimetype':None,
                      'version':None},
            'object_id':{'type':None,
                         'value':None},
            'algorithm': None
            }

        for section in mets.iter_elements_with_id(mets_tree, mets.parse_admid(element),
                                                            "amdSec"):
            if section is not None:
                fileinfo = merge_dicts(
                    fileinfo, mdwrap_to_fileinfo(mets.parse_mdwrap(section)))

        yield fileinfo


def premis_to_dict(premis_xml):
    """Get premis information about digital object and turn it into a
    dictionary.
    :premis_xml: lxml.etree object containing premis oject of the digital
    object.
    :returns: dictionary containing basic information of digital object.
    """
    premis_dict = {"object_id": {}}
    if premis_xml is None:
        return {}
    (premis_dict["algorithm"], premis_dict["digest"]) = premis.parse_fixity(premis_xml)
    (format_name, format_version) = premis.parse_format(premis_xml)
    (premis_dict["object_id"]["type"],
    premis_dict["object_id"]["value"]) = premis.parse_identifier_type_value(premis.parse_identifier(premis_xml, 'object'))
    premis_dict.update(parse_mimetype(format_name))
    if format_version is None:
        premis_dict["format"]["version"] = ""
    else:
        premis_dict["format"]["version"] = format_version

    return premis_dict

