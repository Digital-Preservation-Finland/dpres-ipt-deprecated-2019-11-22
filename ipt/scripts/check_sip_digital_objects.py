#!/usr/bin/python
"""Validate all digital objects in a given METS document"""

import os
import sys
import uuid
import argparse

import xml_helpers.utils
import mets
import premis
from ipt.report import report as p

import ipt.version
from ipt.validator.utils import iter_fileinfo
from ipt.validator.validators import iter_validators


def main(arguments=None):
    """ The main method for check-sip-digital-objects script"""

    args = parse_arguments(arguments)
    report = validation_report(
        validation(args.sip_path),
        args.linking_sip_type,
        args.linking_sip_id)

    print xml_helpers.utils.serialize(report)

    if p.contains_errors(report):
        return 117

    return 0


def parse_arguments(arguments):
    """ Create arguments parser and return parsed command line argumets"""
    parser = argparse.ArgumentParser()
    parser.add_argument('sip_path', help='Path to information package')
    parser.add_argument('linking_sip_type', default=' ')
    parser.add_argument('linking_sip_id', default=' ')

    return parser.parse_args(arguments)


def validation(mets_path):
    """
    Call validation for all files enumerated in mets.xml files.
    :mets_parser: LXML class for mets parsing
    :yields: {
                'fileinfo': fileinfo,
                'result': validation_result
            }
    """
    mets_tree = None
    if mets_path is not None:
        if os.path.isdir(mets_path):
            mets_path = os.path.join(mets_path, 'mets.xml')
        mets_tree = xml_helpers.utils.readfile(mets_path)
    for fileinfo in iter_fileinfo(mets_tree, mets_path):

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

    childs = []
    for result_ in results:
        related_id = premis.identifier(linking_sip_type, linking_sip_id, 'object')
        agent_id_value = str(uuid.uuid4())
        agent_id = premis.identifier('preservation-agent-id', agent_id_value, 'agent')
        agent_name = "%s-%s" % (__file__, ipt.version.__version__)
        report_agent = premis.agent(agent_id, agent_name, 'software')

        report_object = p.object_fromvalidator(
            fileinfo=result_['fileinfo'],
            relatedObject=related_id)
        obj_id = premis.parse_identifier(report_object, 'object')
        (link_id_type, link_id_val) = premis.parse_identifier_type_value(obj_id)

        report_event = p.event_fromvalidator(
            result_['result'],
            linkingObject=premis.identifier(link_id_type, link_id_val, 'linkingObject'),
            linkingAgent=premis.identifier('preservation-agent-id', agent_id_value, 'linkingAgent'))

        childs.append(report_object)
        childs.append(report_event)
        childs.append(report_agent)

    if childs == []:
        childs = None

    return premis.premis(child_elements=childs)


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
