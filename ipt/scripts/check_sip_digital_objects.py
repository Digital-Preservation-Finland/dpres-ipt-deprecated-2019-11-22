#!/usr/bin/python
"""Validate all digital objects in a given METS document"""

import os
import sys
import uuid
import argparse
import datetime
import lxml.etree

import xml_helpers.utils
import mets
import premis

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
    for given_result in results:

        # Create PREMIS agent
        agent_name = "%s-%s" % (__file__, ipt.version.__version__)
        agent_id = premis.identifier(
            identifier_type='preservation-agent-id',
            identifier_value=agent_name, prefix='agent')
        report_agent = premis.agent(agent_id=agent_id, agent_name=agent_name,
                                    agent_type='software')

        # Create PREMIS object

        object_id = premis.identifier('preservation-object-id',
                                      str(uuid.uuid4()))

        fileinfo = given_result['fileinfo']
        result = given_result['result']

        dep_id = premis.identifier(
            fileinfo['object_id']['type'], fileinfo['object_id']['value'])
        environ = premis.environment(dep_id)

        related_id = premis.identifier(
            identifier_type=linking_sip_type, identifier_value=linking_sip_id,
            prefix='object')
        related = premis.relationship(
            relationship_type='structural',
            relationship_subtype='is included in', related_object=related_id)

        report_object = premis.object(
            object_id=object_id, original_name=fileinfo['filename'],
            child_elements=[environ, related],
            representation=True)

        # Create PREMIS event        

        event_id = premis.identifier(
            identifier_type="preservation-event-id",
            identifier_value=str(uuid.uuid4()), prefix='event')
        outresult = 'success' if result["is_valid"] is True else 'failure'
        detail_extension = None
        try:
            parser = lxml.etree.XMLParser(
                dtd_validation=False, no_network=True)
            detail_extension = lxml.etree.fromstring(result["messages"])
            detail_note = result["errors"] if result["errors"] else None

        except lxml.etree.XMLSyntaxError as exception:
            if result["errors"]:
                detail_note = (result["messages"] + result["errors"])
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

        # Add to report list
        childs.append(report_object)
        childs.append(report_event)
        childs.append(report_agent)

    if childs == []:
        childs = None

    return premis.premis(child_elements=childs)


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
