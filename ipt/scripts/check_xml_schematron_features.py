#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse

import ipt.validator.schematron


def main(arguments=None):
    """Main loop"""
    usage = "usage: %prog [options] xml-file-path"

    parser = optparse.OptionParser(usage=usage)

    parser.add_option("-s", "--schemapath", dest="schemapath",
                      help="Path to schematron schemas",
                      metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give a path to an XML file as argument")

    if options.schemapath is None:
        parser.error("The -s switch is required")

    filename = args[0]

    if os.path.isdir(filename):
        filename = os.path.join(filename, 'mets.xml')

    validator = ipt.validator.schematron.SchematronValidator()

    validator.schematron_validation(filename, options.schemapath)

    print validator.messages

    if len(validator.errors.strip('\n \t')) > 0:
        print >>sys.stderr, validator.errors

    if not validator.document_valid():
        return 117

    return 0


if __name__ == '__main__':
    # If run from the command line, take out the program name from sys.argv
    RETVAL = main(sys.argv[1:])
    sys.exit(RETVAL)
