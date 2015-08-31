#!/usr/bin/python
# vim:ft=python
"""Command line utility to create bagit manifests for AIP packages.


Usage instructions::

    create-aip <sip directory>

On successful operation returns exit status 0.
On system error returns exit status != 0.

.. _Bagit: http://en.wikipedia.org/wiki/BagIt
.. _`Bagit specification`:
    http://www.digitalpreservation.gov/documents/bagitspec.pdf

For more information see the :mod:`aiptools.bagit_new` module.

"""

import sys
import optparse

from ipt.aiptools.bagit_new import make_manifest, write_manifest, \
    write_bagit_txt


def main(arguments=None):
    """Parse command line arguments and run application"""

    usage = "usage: %prog make_bag <sip_path>"
    parser = optparse.OptionParser(usage=usage)

    (options, args) = parser.parse_args(arguments)

    if len(args) != 2:
        sys.stderr.write("Must provide make_bag command and SIP directory name"
                         " as parameter\n")
        parser.print_help()
        return 1

    if args[0] != 'make_bag':
        sys.stderr.write('Wrong arguments, make_bag must be first argument\n')
        parser.print_help()
        return 1

    sip_path = args[1]
    manifest = make_manifest(sip_path)
    write_manifest(manifest, sip_path)
    write_bagit_txt(sip_path)

    return 0


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
