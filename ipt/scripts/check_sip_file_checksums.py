#!/usr/bin/python
"""Check fixity for SIP digital objects"""

import os
import sys
import optparse

import ipt.mets.parser
import ipt.mets.file.checksum
from ipt.validator.utils import iter_fileinfo


def check_digital_object_checksums(mets_path):
    """TODO: Docstring for .

    :mets_path: TODO
    :returns: TODO

    """

    mets_parser = ipt.mets.parser.LXML(mets_path)

    for fileinfo in iter_fileinfo(mets_parser):
        print fileinfo


def main(arguments=None):
    """Main loop"""

    usage = "usage: %prog sip-directory"

    parser = optparse.OptionParser(usage=usage)

    (_, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give SIP directory as argument")

    mets_filename = os.path.abspath(os.path.join(args[0], 'mets.xml'))

    checksum_checker = ipt.mets.file.checksum.Checker(
        mets_filename=mets_filename)

    print "Collecting list of files in '%s'" % mets_filename
    files, _ = checksum_checker.get_files_and_checksums_from_mets_file(
        mets_filename)

    print "files", files

    # print "Calculating checksums for files (ignoring: %s)" % (
    #        ', '.join(parser.ignore_filenames))

    test_result = checksum_checker.check_file_existence_and_checksums(files)

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
