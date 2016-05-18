#!/usr/bin/python
"""Validate all digital objects in a given METS document"""

import sys
import argparse

import ipt.mets.parser
from ipt.mets.parser import MetsFile, MdWrap
from ipt.premis import premis as p
import ipt.addml.addml

import ipt.version
from ipt.validator import validate
from ipt.utils import merge_dicts, uri_to_path


def main(arguments=None):
    """ The main method for check-sip-digital-objects script"""

    args = parse_arguments(arguments)
    mets_parser = ipt.mets.parser.LXML(args.sip_path)

    report = validation_report(
        validation(mets_parser),
        args.linking_sip_type,
        args.linking_sip_id)

    print report.serialize()

    if report.contains_errors():
        return 117

    return 0


def parse_arguments(arguments):
    """ Create arguments parser and return parsed command line argumets"""
    parser = argparse.ArgumentParser()
    parser.add_argument('sip_path')
    parser.add_argument('linking_sip_type')
    parser.add_argument('linking_sip_id')

    return parser.parse_args(arguments)


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

    mdwrap = MdWrap(mdwrap_element)

    standard_parsers = {
        'PREMIS:OBJECT': p.to_dict,
        'PREMIS:EVENT': lambda x: {},
        'PREMIS:AGENT': lambda x: {},
        'METSRIGHTS': lambda x: {},
        'METSRights': lambda x: {},
        'TEXTMD': lambda x: {}
    }

    other_parsers = {
        'ADDML': ipt.addml.addml.to_dict
    }

    try:
        if mdwrap.mdtype == 'OTHER' and mdwrap.other_mdtype == 'ADDML':
            return other_parsers[mdwrap.other_mdtype](mdwrap.xmldata)
        return standard_parsers[mdwrap.mdtype](mdwrap.xmldata)
    except KeyError as exception:
        raise KeyError("No metadata parser for mdWrap element: %s %s" % (
            exception, mdwrap))


def iter_fileinfo(mets_parser):
    """TODO: Docstring for iter_fileinfo.

    :mets_parser: TODO
    :returns: TODO

    """

    for element in mets_parser.mets_files():

        mets_file = MetsFile(element)

        if mets_file.use == 'no-file-format-validation':
            continue

        fileinfo = {'filename': os.path.join(
            os.path.dirname(mets_parser.mets_path),
            uri_to_path(mets_file.href))}

        for md_element in mets_parser.iter_elements_with_id(mets_file.admid):
            fileinfo = merge_dicts(fileinfo, mdwrap_to_fileinfo(md_element))

        yield fileinfo


def validation(mets_parser):
    """
    Call validation for all files enumerated in mets.xml files.
    :mets_parser: LXML class for mets parsing
    :yields: {
                'fileinfo': fileinfo,
                'result': validation_result
            }
    """
    for fileinfo in iter_fileinfo(mets_parser):
        validation_results = validate(fileinfo)

        for validation_result in validation_results:

            yield {
                'fileinfo': fileinfo,
                'result': validation_result
            }


def validation_report(results, linking_sip_type, linking_sip_id):
    """ Format validation results to Premis report"""
    report = p.Premis()

    for result in results:

        related_object = p.Object()
        related_object.identifier = ""
        related_object.identifierType = linking_sip_type
        related_object.identifierValue = linking_sip_id

        linking_agent = p.Agent()
        agent_name = "%s-%s" % (__file__, ipt.version.__version__)
        linking_agent.fromvalidator(
            agentIdentifierType="preservation-agent-id",
            agentIdentifierValue=agent_name,
            agentName=agent_name)
        linking_agent.type = "software"
        report.insert(linking_agent)

        linking_object = p.Object()
        linking_object.fromvalidator(
            fileinfo=result['fileinfo'],
            relatedObject=related_object)

        validation_event = p.Event()
        validation_event.fromvalidator(
            *result['result'],
            linkingObject=linking_object,
            linkingAgent=linking_agent)

        report.insert(linking_object)
        report.insert(validation_event)

    return report


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
