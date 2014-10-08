#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse

import validator.plugin.xmllint

def search_mets(path):
    """"Search mets.xml in directory and return full path to filename"""

    filename = None
    for file in os.listdir(path):
        if file.lower().endswith(".xml") and file.lower().startswith('mets'):
            filename = os.path.join(path, file)
    return filename

def main(arguments=None):
    """Main loop"""
    usage = "usage: %prog [options] <mets filename|sip path>"
    sharepath = "/usr/share/information-package-tools/"

    parser = optparse.OptionParser(usage=usage)

    parser.add_option("-c", "--catalog", dest="catalogpath",
                default= os.path.join(sharepath, "schema/catalog-local.xml"),
                help="Full path to XML catalog file",
                metavar="FILE")

    parser.add_option("-s", "--schemapath", dest="schemapath",
                default=os.path.join(sharepath, "schema/mets/mets.xsd"),
                help="XML schema filename for validation",
                metavar="PATH")


    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give METS filename or SIP directory as argument")
    filename = args[0]

    if os.path.isdir(filename):
        filename = search_mets(filename)

    if filename == None:
        print >> sys.stderr, "ERROR: mets.xml not found"
        return 1
        
    validate = validator.plugin.xmllint.Xmllint("text/xml", "1.0", filename)
    validate.set_catalog(options.catalogpath)
    validate.add_schema(options.schemapath)

    (returncode, messages, errors) = validate.validate()

    print >> sys.stderr, errors

    return returncode