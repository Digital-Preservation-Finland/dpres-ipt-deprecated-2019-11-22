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

    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--configfile", help="JSON configuration file")
    parser.add_argument('sip_path')
    parser.add_argument('linking_sip_type')
    parser.add_argument('linking_sip_id')
    args = parser.parse_args(arguments)

    sip_path = args.sip_path
    linking_sip_type = args.linking_sip_type
    linking_sip_id = args.linking_sip_id

    mets_filename = os.path.abspath(os.path.join(sip_path, 'mets.xml'))
    basepath = os.path.abspath(os.path.dirname(mets_filename))

    validator = ipt.validator.filelist.Validator(basepath)
    validator.load_config(args.configfile)
    mets_parser = ipt.mets.parser.LXML(mets_filename)
    filelist = mets_parser.get_fileinfo_iterator()

    validation_results = validator.validate_files(filelist)
    mets_filelist = mets_parser.get_fileinfo_array()

    return_status = 0
    report = p.Premis()

    for fileinfo, statuscode, stdout, stderror, _validator in \
            zip(mets_filelist, *validation_results):

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
            fileinfo=fileinfo,
            relatedObject=related_object)

        validation_event = p.Event()
        validation_event.fromvalidator(
            statuscode, stdout, stderror,
            linkingObject=linking_object,
            linkingAgent=linking_agent)

        report.insert(linking_object)
        report.insert(validation_event)

        if not _validator:
            return_status = 1
        elif statuscode != 0:
            return_status = 117

    sys.stdout.write(report.serialize())
    return return_status

if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
