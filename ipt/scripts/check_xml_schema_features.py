#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse

import ipt.validator.xmllint


def main(arguments=None):
    """Main loop"""
    usage = "usage: %prog [options] xml-file-name"
    catalog_path = ("/etc/xml/dpres-xml-schemas/xml_catalogs")
    schema_path = ("/etc/xml/dpres-xml-schemas/xml_schemas")

    parser = optparse.OptionParser(usage=usage)

    parser.add_option("-c", "--catalog", dest="catalogpath",
                      default=os.path.join(
                          catalog_path, "xml_catalog.xml"),
                      help="Full path to XML catalog file",
                      metavar="FILE")

    parser.add_option("-s", "--schemapath", dest="schemapath",
                      default=os.path.join(schema_path, "mets/mets.xsd"),
                      help="XML schema filename for validation",
                      metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give XML filename as argument")

    fileinfo = {
        "filename": args[0],
        "schema": options.schemapath,
        "format": {
            "mimetype": "text/xml",
            "version": "1.0"
        }
    }
    validate = ipt.validator.xmllint.Xmllint(fileinfo)

    validate.validate()

    print >> sys.stdout, validate.messages()
    print >> sys.stderr, validate.errors()

    if not validate.is_valid:
        return 117

    return 0

if __name__ == '__main__':
    # If run from the command line, take out the program name from sys.argv
    RETVAL = main(sys.argv[1:])
    sys.exit(RETVAL)
