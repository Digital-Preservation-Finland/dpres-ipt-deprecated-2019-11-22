#!/usr/bin/python
"""Check fixity for SIP digital objects"""

import os
import sys
import argparse
import errno

import scandir

import mets
import xml_helpers.utils as u
from ipt.validator.utils import iter_fileinfo
from ipt.fileutils.checksum import BigFile


def iter_files(path):
    """Iterate all files under path.

    Does not iterate files that are listed in signature.sig file.

    :returns: Iterable over full paths to

    """

    ignored_files = ['mets.xml', 'varmiste.sig', 'signature.sig']

    for root, _, files in scandir.walk(path):
        for filename in files:
            if root == path and filename in ignored_files:
                continue
            yield os.path.join(root, filename)


def check_checksums(mets_path):
    """Check checksums for all digital objects in METS

    :mets_path: Path to mets
    :returns: Iterable containing all error messages

    """

    checked_files = {}

    if os.path.isdir(mets_path):
        mets_path = os.path.join(mets_path, 'mets.xml')

    sip_path = os.path.dirname(mets_path)

    def _message(fileinfo, message):
        """Format error message"""
        return "%s: %s" % (
            message, os.path.relpath(fileinfo["filename"], sip_path))

    mets_tree = u.readfile(mets_path)
    for fileinfo in iter_fileinfo(mets_tree, mets_path):
        checked_files[fileinfo["filename"]] = None

        if fileinfo['algorithm'] is None:
            yield _message(fileinfo, "Could not find checksum algorithm")
        else:

            checksum = BigFile(fileinfo["algorithm"])

            try:
                hex_digest = checksum.hexdigest(fileinfo["filename"])
            except IOError as exception:
                if exception.errno == errno.ENOENT:
                    yield _message(fileinfo, "File does not exist")
                continue

            if hex_digest == fileinfo["digest"]:
                print _message(fileinfo, "Checksum OK")
            else:
                yield _message(fileinfo, "Invalid Checksum")

    for path in iter_files(sip_path):
        if path.endswith("ignore_validation_errors"):
            continue

        if path not in checked_files:
            yield _message({'filename': path}, "Nonlisted file")


def main(arguments=None):
    """Main loop"""

    args = parse_arguments(arguments)

    returncode = 0
    for error_message in check_checksums(args.sip_path):
        print error_message
        returncode = 117

    return returncode


def parse_arguments(arguments):
    """ Create arguments parser and return parsed command line argumets"""
    parser = argparse.ArgumentParser()
    parser.add_argument('sip_path')
    return parser.parse_args(arguments)

if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
