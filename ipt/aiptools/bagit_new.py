"""
This module implements a simplified version of bagit manifest file creation. 
Bagit itself is acontainer directory structure developed by
Congress Library. For exact documentation of bagit, please see

	https://github.com/LibraryOfCongress/bagit-python

Here is a brief specification of bagit relevant to this implementation:

Bagit is a container directory structure with a manifest file containing
directory listing with hash values. The purpose of these hash values is to
verify that the data stored in the container is not corrupted. Below is the
directory structure dercibed:

mybagit/
|-- data
|   |-- my_packge
|       |-- images
|           |-- some.jpg
|           |-- other.txt
|-- manifest-md5.txt
|     9e9f7c5bb2315bdbe560f4e167e995a4 data/my_packge/images/some.jpg
|     348a671d663cef32d44a49ed8485efa7 data/my_packge/images/other.txt
|-- bagit.txt
      BagIt-Version: 0.97
      Tag-File-Character-Encoding: UTF-8

bagit.txt contains the version of the module and the encoding of the manifest
file and other optional bagit files(bag-info.txt, tagmanifest-md5.txt,
fetch.txt). Only manifest file and bagit.txt are mandatory. The manifest file
has the hash function described in the name and in this code it is md5.

The module has the following interface and functionalities:

create manifest for a directory:

    bagit.py make_bag <directory>

this results in creation of manifest-md5.txt to the current directory. For
example:

    bagit.py data

creates a manifest file manifest-md5.txt with lines:

    9e9f7c5bb2315bdbe560f4e167e995a4 data/my_packge/images/some.jpg
    348a671d663cef32d44a49ed8485efa7 data/my_packge/images/other.txt
"""

from optparse import OptionParser
import os


class BagitError(Exception):
    """Raised when plugin encounters unrecoverable error"""
    pass


def get_option_parser():
    """Return optionparser configuraed with script options.

    :returns: OptionParser instance

    """

    parser = OptionParser(
        usage="usage: %prog <command> <directory>")

    return parser


def main(argv=None):
    """ Main function of bagit.py. This interprets commandline arguments and
    calls specific functionalities.

    :argv: List of command line arguments
    :returns: exitcode

    """

    pass


def make_manifest(bagit_dir):
    """This function creates bagit manifest."""
    print "LIST"
    for dir_name, _, file_list in os.walk(bagit_dir):
    	print dir_name, file_list
