#!/usr/bin/python
"""Validate all digital objects in a given METS document"""

import os
import sys
import uuid
import argparse
import datetime
import lxml.etree

import xml_helpers.utils
import premis

from ipt.validator.utils import iter_metadata_info
from ipt.validator.validators import iter_validators


def main(arguments=None):
    """ The main method for check-sip-digital-objects script"""

    args = parse_arguments(arguments)
    report = validation_report(
        validation(args.sip_path),
        args.linking_sip_type,
        args.linking_sip_id)

    print xml_helpers.utils.serialize(report)

    if contains_errors(report):
        return 117

    return 0


def parse_arguments(arguments):
    """ Create arguments parser and return parsed command line argumets"""
    parser = argparse.ArgumentParser()
    parser.add_argument('sip_path', help='Path to information package')
    parser.add_argument('linking_sip_type', default=' ')
    parser.add_argument('linking_sip_id', default=' ')

    return parser.parse_args(arguments)


def contains_errors(report):
    events = report.findall('.//'+premis.premis_ns('eventOutcome'))
    for event in events:
        if event.text == 'failure':
            return True
    return False


def validation(mets_path):
    """
    Call validation for all files enumerated in mets.xml files.
    :mets_parser: LXML class for mets parsing
    :yields: {
                'metadata_info': metadata_info,
                'result': validation_result
            }
    """
    mets_tree = None
    if mets_path is not None:
        if os.path.isdir(mets_path):
            mets_path = os.path.join(mets_path, 'mets.xml')
        mets_tree = xml_helpers.utils.readfile(mets_path)
    for metadata_info in iter_metadata_info(mets_tree, mets_path):

        if metadata_info["use"] == 'no-file-format-validation':
            continue

        if metadata_info["errors"]:
            yield {
                'metadata_info': metadata_info,
                'result': {
                    'is_valid': False,
                    'messages': ("Failed parsing metadata, skipping "
                                 "validation."),
                    'errors': metadata_info["errors"],
                    'result': None
                }
            }

        else:
            validators = iter_validators(metadata_info)
            for validator in validators:
                yield {
                    'metadata_info': metadata_info,
                    'result': validator.result()
                }


def validation_report(results, linking_sip_type, linking_sip_id):
    """ Format validation results to Premis report"""

    if results is None:
        raise TypeError

    # Create PREMIS agent, only one agent is needed
    # TODO: Agent could be the used validator instead of script file
    agent_name = "check_sip_digital_objects.py-v0.0"
    agent_id_value = 'preservation-agent-'+agent_name+'-' + \
        str(uuid.uuid4())
    agent_id = premis.identifier(
        identifier_type='preservation-agent-id',
        identifier_value=agent_id_value, prefix='agent')
    report_agent = premis.agent(agent_id=agent_id, agent_name=agent_name,
                                agent_type='software')

    childs = [report_agent]
    object_list = set()
    for given_result in results:

        metadata_info = given_result['metadata_info']
        result = given_result['result']

        # Create PREMIS object only if not already in the report
        if metadata_info['object_id']['value'] not in object_list:

            object_list.add(metadata_info['object_id']['value'])

            dep_id = premis.identifier(
                metadata_info['object_id']['type'],
                metadata_info['object_id']['value'])
            environ = premis.environment(dep_id)

            related_id = premis.identifier(
                identifier_type=linking_sip_type,
                identifier_value=linking_sip_id,
                prefix='object')
            related = premis.relationship(
                relationship_type='structural',
                relationship_subtype='is included in',
                related_object=related_id)

            object_id = premis.identifier('preservation-object-id',
                                          str(uuid.uuid4()))

            report_object = premis.object(
                object_id=object_id, original_name=metadata_info['filename'],
                child_elements=[environ, related],
                representation=True)

            childs.append(report_object)

        # Create PREMIS event
        event_id = premis.identifier(
            identifier_type="preservation-event-id",
            identifier_value=str(uuid.uuid4()), prefix='event')
        outresult = 'success' if result["is_valid"] is True else 'failure'
        detail_extension = None
        try:
            detail_extension = lxml.etree.fromstring(result["messages"])
            detail_note = result["errors"] if result["errors"] else None

        except lxml.etree.XMLSyntaxError:
            if result["errors"]:
                detail_note = (result["messages"] + '\n' + result["errors"])
            else:
                detail_note = result["messages"]

        outcome = premis.outcome(outcome=outresult, detail_note=detail_note,
                                 detail_extension=detail_extension)

        report_event = premis.event(
            event_id=event_id, event_type="validation",
            event_date_time=datetime.datetime.now().isoformat(),
            event_detail="Digital object validation",
            child_elements=[outcome],
            linking_objects=[report_object], linking_agents=[report_agent])

        childs.append(report_event)

    return premis.premis(child_elements=childs)


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
