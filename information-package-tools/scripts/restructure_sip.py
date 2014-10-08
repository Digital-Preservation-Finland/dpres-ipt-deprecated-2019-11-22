#!/usr/bin/python
# vim:ft=python
"""
Restructure and unify SIP directory structure.

Command line usage::

    restructure-sip <destination directory> <source directory>

For detailed information see :mod:`sip.restructure` module.

"""

import sys
import optparse

import sip.restructure

def main(arguments=None):
    """Main loop """
    usage = "usage: %prog <sippath> <transfer name>"
    parser = optparse.OptionParser(usage=usage)

    args = parser.parse_args(arguments)[1]

    if len(args) != 2:
        sys.stderr.write("Must provide SIP directory and " +
                         "transfer name name as parameter\n")

        parser.print_help()
        return 1

    sip.restructure.restructure_sip(args[0], args[1])

    return 0
