#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse
import lxml.etree

import ipt.mets.file.checksum

def main(arguments=None):
    """Main loop"""

    usage = "usage: %prog mets-file.xml"

    parser = optparse.OptionParser(usage=usage)


    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give METS filename as argument")

    mets_filename = os.path.abspath(args[0])
    sip_path = os.path.dirname(mets_filename)

    parser = ipt.mets.file.checksum.Checker()

    print "Collecting list of files in '%s'" % mets_filename
    files, errors = parser.get_files_and_checksums_from_mets_file(mets_filename)
    
    print "files", files

    #print "Calculating checksums for files (ignoring: %s)" % (
    #        ', '.join(parser.ignore_filenames))

    test_result = parser.check_file_existence_and_checksums(files)

    #print test_result

    return_status = 0
    for result in test_result:
        if result[2] != 0:
            return_status = 1

        print result[0], result[1]

    return return_status





