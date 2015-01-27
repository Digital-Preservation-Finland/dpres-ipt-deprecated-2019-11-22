#!/usr/bin/python
# vim:ft=python

import os
import sys
import optparse
import lxml.etree

import ipt.mets.file.checksum


def main(arguments=None):
    """Main loop"""

    usage = "usage: %prog sip-directory"

    parser = optparse.OptionParser(usage=usage)

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give SIP directory as argument")

    mets_filename = os.path.abspath(os.path.join(args[0], 'mets.xml'))

    parser = ipt.mets.file.checksum.Checker()

    print "Collecting list of files in '%s'" % mets_filename
    files, errors = parser.get_files_and_checksums_from_mets_file(
        mets_filename)

    print "files", files

    # print "Calculating checksums for files (ignoring: %s)" % (
    #        ', '.join(parser.ignore_filenames))

    test_result = parser.check_file_existence_and_checksums(files)

    # print test_result

    return_status = 0
    for result in test_result:
        if result[2] != 0:
            return_status = 117

        print result[0], result[1]

    return return_status

if __name__ == '__main__':
    # If run from the command line, take out the program name from sys.argv
    RETVAL = main(sys.argv[1:])
    sys.exit(RETVAL)
