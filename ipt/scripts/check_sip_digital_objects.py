#!/usr/bin/python
"""Validate all digital objects in a given METS document"""

import sys
import argparse

import ipt.mets.parser
from ipt.premis import premis as p

import ipt.version
from ipt.validator.utils import iter_fileinfo
from ipt.validator.validators import iter_validators


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
    parser.add_argument('sip_path', help='Path to information package')
    parser.add_argument('linking_sip_type', default=' ')
    parser.add_argument('linking_sip_id', default=' ')

    return parser.parse_args(arguments)


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

        if fileinfo["use"] == 'no-file-format-validation':
            continue

        validators = iter_validators(fileinfo)
        for validator in validators:
            yield {
                'fileinfo': fileinfo,
                'result': validator.result()
            }


def validation_report(results, linking_sip_type, linking_sip_id):
    """ Format validation results to Premis report"""
    report = p.Premis()

    for result_ in results:
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
            fileinfo=result_['fileinfo'],
            relatedObject=related_object)

        validation_event = p.Event()
        validation_event.fromvalidator(
            result_['result'],
            linkingObject=linking_object,
            linkingAgent=linking_agent)

        report.insert(linking_object)
        report.insert(validation_event)

    return report


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
