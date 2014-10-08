#!/usr/bin/python
# vim:ft=python
"""Command line utility to create AIP packages.

This command restructures SIP directory and creates standard Bagit_
directory from it. Directory name stays the same. Only restructures SIP
directory according to `Bagit specification`_.

Usage instructions::

    create-aip <sip directory>

On successful operation returns exit status 0.
On error returns exit status != 0.

.. _Bagit: http://en.wikipedia.org/wiki/BagIt
.. _`Bagit specification`:
    http://www.digitalpreservation.gov/documents/bagitspec.pdf

For more information see the :mod:`aiptools.create_aip` module.

"""

import sys
import optparse

import aiptools.create_aip

def main(arguments=None):
    """Parse command line arguments and run application"""

    usage = "usage: %prog <sippath>"
    parser = optparse.OptionParser(usage=usage)

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        sys.stderr.write("Must provide SIP directory name as parameter\n")
        parser.print_help()
        return 1

    print "Creating AIP: ", args[0]
    result = aiptools.create_aip.create_aip_from_sip(args[0])
    print result

    return 0


