#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse
import validator.filelist
import mets.parser
import version
from premis import premis


def main(arguments=None):

    usage = "usage: %prog <mets-filename> <linking-sip-object-id>"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-c", "--configfile", dest="config_filename",
                      default=None,
                      help="JSON configuration file",
                      metavar="PATH")
    (options, args) = parser.parse_args(arguments)
    if(len(args) != 3):
        parser.print_help()
        return 1
    mets_filename = args[0]
    basepath = os.path.abspath(os.path.dirname(mets_filename))
    linking_sip_id = args[2]
    linking_sip_type = args[1]

    validate = validator.filelist.Validator(basepath)
    validate.load_config(options.config_filename)
    mets_parser = mets.parser.LXML(mets_filename)
    filelist = mets_parser.get_fileinfo_iterator()

    statuses, reports, errors, validators = validate.validate_files(filelist)

    return_status = 0
    return_message = ""

    prem = premis.Premis()

    filelist = mets_parser.get_fileinfo_array()

    for fileinfo, status, report, error, _validator in \
            zip(filelist, statuses, reports, errors, validators):

        if status != 0:
            return_status = status

        ff = validator.filelist.FileInfo(fileinfo)
        ff.from_dict(fileinfo)

        related_object = premis.Object()
        related_object.identifier = ""
        related_object.identifierType = linking_sip_type
        related_object.identifierValue = linking_sip_id

        linking_object = premis.Object()
        linking_object.fromvalidator(fileinfo=ff, relatedObject=related_object)

        linking_agent = premis.Agent()
        linking_agent.name = str(
            os.path.basename(__file__)) + "-" + version.__version__
        linking_agent.identifier = ""
        linking_agent.identifierType = "pas-agent-id"
        linking_agent.identifierValue = "pas-agent-" + linking_agent.name
        linking_agent.type = "software"

        linking_agent.note = str(_validator)
        prem.insert(linking_agent)

        validation_event = premis.Event()
        validation_event.fromvalidator(status, report, error,
                                       linkingObject=linking_object,
                                       linkingAgent=linking_agent)

        prem.insert(linking_object)
        prem.insert(validation_event)

    return_message = prem.serialize()
    sys.stdout.write(return_message)

    return return_status

if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
