#!/usr/bin/python
# vim:ft=python

import os
import sys
import argparse
import ipt.validator.filelist
import ipt.mets.parser
import ipt.version
from ipt.premis import premis as p


def main(arguments=None):
    """ The main method for check-sip-digital-objects script"""

    args = parse_arguments(arguments)
    mets_parser = ipt.mets.parser.LXML(args.sip_path)

    results = []
    for fileinfo in mets_parser.get_fileinfo_array():
        validator = ipt.validator.filelist.Validator(fileinfo)
        results += [{
            'fileinfo': fileinfo,
            'result': [validator.validate()]
        }]

    print format_results(results, args.linking_sip_type, args.linking_sip_id)

    return 0

def parse_arguments(arguments):
    """ Create arguments parser and return parsed command line argumets"""
    parser = argparse.ArgumentParser()
    parser.add_argument('sip_path')
    parser.add_argument('linking_sip_type')
    parser.add_argument('linking_sip_id')

    return parser.parse_args(arguments)


def format_results(results, linking_sip_type, linking_sip_id):
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
            result['result'],
            linkingObject=linking_object,
            linkingAgent=linking_agent)

        report.insert(linking_object)
        report.insert(validation_event)

    return report.serialize()


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
