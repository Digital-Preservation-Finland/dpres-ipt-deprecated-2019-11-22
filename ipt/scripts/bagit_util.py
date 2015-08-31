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

import ipt.aiptools.bagit_new


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
        sys.stderr.write('Wrong arguments, make_bag must be first argument')
        parser.print_help()
        return 1

    print "Creating bagit manifest: ", args
    result = ipt.aiptools.bagit_new.main(args)
    print result

    return 0


if __name__ == '__main__':
    RETVAL = main()
    sys.exit(RETVAL)
