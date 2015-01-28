#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse

import ipt.validator.plugin.schematron


def main(arguments=None):
    """Main loop"""
    usage = "usage: %prog [options] xml-file-path"

    parser = optparse.OptionParser(usage=usage)

    parser.add_option("-s", "--schemapath", dest="schemapath",
                      help="Path to KDK-PAS schematron schemas",
                      metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give SIP directory as argument")

    if options.schemapath is None:
        parser.error("The -s switch is required")

    filename = args[0]

    validate = ipt.validator.plugin.schematron.XSLT()

    result = validate.validate_file(options.schemapath, filename)

    print result.messages

    if len(result.errors.strip('\n \t')) > 0:
        print >>sys.stderr, result.errors

    if result.has_errors():
        print result
        return 117

    return 0

if __name__ == '__main__':
    # If run from the command line, take out the program name from sys.argv
    RETVAL = main(sys.argv[1:])
    sys.exit(RETVAL)
