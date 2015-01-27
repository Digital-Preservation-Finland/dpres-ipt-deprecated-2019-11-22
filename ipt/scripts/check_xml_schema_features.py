#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse

import ipt.validator.plugin.xmllint


def main(arguments=None):
    """Main loop"""
    usage = "usage: %prog [options] xml-file-name"
    sharepath = "/usr/share/information-package-tools/"

    parser = optparse.OptionParser(usage=usage)

    parser.add_option("-c", "--catalog", dest="catalogpath",
                      default=os.path.join(
                          sharepath, "schema/catalog-local.xml"),
                      help="Full path to XML catalog file",
                      metavar="FILE")

    parser.add_option("-s", "--schemapath", dest="schemapath",
                      default=os.path.join(sharepath, "schema/mets/mets.xsd"),
                      help="XML schema filename for validation",
                      metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give XML filename as argument")

    filename = args[0]

    validate = ipt.validator.plugin.xmllint.Xmllint(
        "text/xml", "1.0", filename)
    validate.set_catalog(options.catalogpath)
    validate.add_schema(options.schemapath)

    (returncode, messages, errors) = validate.validate()

    print >> sys.stderr, errors

    return returncode

if __name__ == '__main__':
    # If run from the command line, take out the program name from sys.argv
    RETVAL = main(sys.argv[1:])
    sys.exit(RETVAL)
