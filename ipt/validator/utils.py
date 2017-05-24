"""Helpers for validation"""

import os

from ipt.utils import merge_dicts, uri_to_path
from ipt.mets.parser import MetsFile, MdWrap
from ipt.premis import premis as p
import ipt.addml.addml
import ipt.videomd.videomd
import ipt.audiomd.audiomd


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

    mdwrap = MdWrap(mdwrap_element)

    standard_parsers = {
        'PREMIS:OBJECT': p.to_dict
    }

    other_parsers = {
        'ADDML': ipt.addml.addml.to_dict,
        'VideoMD': ipt.videomd.videomd.to_dict,
        'AudioMD': ipt.audiomd.audiomd.to_dict
    }

    try:
        if mdwrap.mdtype == 'OTHER':
            return other_parsers[mdwrap.other_mdtype](mdwrap.xmldata)
        return standard_parsers[mdwrap.mdtype](mdwrap.xmldata)
    except KeyError:
        return {}


def iter_fileinfo(mets_parser):
    """Iterate all files in given mets document and return fileinfo
    dictionary for each file.

    :mets_parser: ipt.mets.parser.LXML object
    :returns: Iterable on fileinfo dictionaries

    """

    for element in mets_parser.mets_files():

        mets_file = MetsFile(element)
        object_filename = os.path.join(
            os.path.dirname(mets_parser.mets_path),
            uri_to_path(mets_file.href))

        fileinfo = {
            'filename': object_filename,
            'use': mets_file.use,
            'format':{'mimetype':None,
                      'version':None},
            'object_id':{'type':None,
                         'value':None},
            'algorithm': None
            }

        for md_element in mets_parser.iter_elements_with_id(mets_file.admid,
                                                            "amdSec"):
            fileinfo = merge_dicts(fileinfo,
                                   mdwrap_to_fileinfo(md_element))

        yield fileinfo


class UnknownFileformat(object):
    """
    Validator class for unknown filetypes. This will always result as
    invalid validation result.
    """

    def __init__(self, fileinfo):
        """
        Initialize object
        """
        self.fileinfo = fileinfo

    def validate(self):
        """
        No implementation
        """
        pass

    def result(self):
        """
        Return validation result
        """
        error_message = 'No validator for mimetype: %s version: %s' % (
            self.fileinfo['format']['mimetype'],
            self.fileinfo['format']['version'])

        return {
            'is_valid': False,
            'messages': "",
            'errors': error_message}
