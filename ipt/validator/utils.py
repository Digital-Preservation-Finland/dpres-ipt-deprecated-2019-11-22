"""Helpers for validation"""

import os

import mets
import premis

from ipt.utils import merge_dicts, uri_to_path, parse_mimetype
import ipt.addml.addml
import ipt.videomd.videomd
import ipt.audiomd.audiomd


def mdwrap_to_metadata_info(mdwrap_element):
    """Extract metadata_info dict from mdwrap element.

    TODO: This should be implemented in metadata-parser classes, similar
    implementation is already working with digital object validators::

        class MdParser:
            def is_supported(mdwrap_object):
                ...
            def from_xmldata(elementtree_object):
                ...
            def to_json():
                ...

        def md_to_metadata_info():
            parsers [ MdParser, ... ]
            for parser in parsers:
                if not MdParser.is_supported(mdwrap):
                    continue
                merge_dict(
                    metadata_info,
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


def create_metadata_info(mets_tree, element, object_filename, use, type):
    """Create a dictionary of technical metadata from mets metadata for
    a given section that can either be about a digital object
    or a bitstream. The function combines the created metadata_info
    dictionary with metadata from the mets amdSec section.

    :mets_tree: metadata in mets xml format
    :element: the metadata section with the ID to be parsed
    :object_filename: path to the digital object
    :use: the use attribute value for the digital object
    :type: type of object, i.e. a 'file' or a 'bitstream'

    :returns: metadata_info as a dict

    """
    metadata_info = {
        'filename': object_filename,
        'use': use,
        'type': type,
        'format': {'mimetype': None,
                   'version': None},
        'object_id': {'type': None,
                      'value': None},
        'algorithm': None,
        'digest': None
    }

    for section in mets.iter_elements_with_id(mets_tree,
                                              mets.parse_admid(element),
                                              "amdSec"):
        if section is not None:
            metadata_info = merge_dicts(
                metadata_info, mdwrap_to_metadata_info(
                    mets.parse_mdwrap(section)))

    return metadata_info


def iter_metadata_info(mets_tree, mets_path):
    """Iterate all files in given mets document and return metadata_info
    dictionary for each file and bitstream.

    :mets_tree: metadata in mets xml format
    :mets_path: path to the mets document

    :returns: Iterable on metadata_info dictionaries

    """

    for element in mets.parse_files(mets_tree):

        loc = mets.parse_flocats(element)[0]
        object_filename = os.path.join(
            os.path.dirname(mets_path),
            uri_to_path(mets.parse_href(loc)))
        use = mets.parse_use(element)

        for stream_elem in mets.parse_streams(element):

            metadata_info = create_metadata_info(
                mets_tree=mets_tree, element=stream_elem,
                object_filename=object_filename, use=use, type='bitstream')

            yield metadata_info

        metadata_info = create_metadata_info(
            mets_tree=mets_tree, element=element,
            object_filename=object_filename, use=use, type='file')

        yield metadata_info


def premis_to_dict(premis_xml):
    """Get premis information about digital object and turn it into a
    dictionary.
    :premis_xml: lxml.etree object containing premis oject of the digital
    object.
    :returns: dictionary containing basic information of digital object.
    """
    if premis_xml is None:
        return {}
    if premis_xml.tag != '{%s}object' % premis.PREMIS_NS:
        return {}
    try:
        object_type = premis.parse_object_type(premis_xml).strip()
    except IndexError:
        object_type = 'file'
    if object_type.endswith('representation'):
        return {}
    premis_dict = {"object_id": {}}
    (premis_dict["object_id"]["type"],
     premis_dict["object_id"]["value"]) = premis.parse_identifier_type_value(
         premis.parse_identifier(premis_xml, 'object'))
    if object_type.endswith('file'):
        (premis_dict["algorithm"],
         premis_dict["digest"]) = premis.parse_fixity(premis_xml)
    (format_name, format_version) = premis.parse_format(premis_xml)
    premis_dict.update(parse_mimetype(format_name))
    if format_version is None:
        premis_dict["format"]["version"] = ""
    else:
        premis_dict["format"]["version"] = format_version

    return premis_dict
