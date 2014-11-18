#!/usr/bin/python
# vim:ft=python
"""
Digital signature is verified with command::

    check-sip-signature [--ca-path=certificate-directory] signature-file.sig

This verifies that OpenSSL/SMIME container valid and checkums for manifested
files match checksums from according files.

On successful verification command returns exit status 0. On failure command
returns error code.

To verify signature the signers public RSA key is required, either in standard
OpenSSL certificated directory or specified :--capath: parameter.

Command options:

    -c, --capath=dir    - Use OpenSSL PEM certificates in this directory


"""

__author__ = "Mikko Vatanen"
__copyright__ = "Copyright 2013, CSC - IT Center for Science"
__email__ = "mikko.vatanen@csc.fi"
__status__ = "Development"


import optparse

import ipt.sip.signature


def main(arguments=None):
    """Main loop"""

    usage = "usage: %prog signature-file"

    parser = optparse.OptionParser(usage=usage)
    parser.add_option(
        "-c", "--capath",
        dest="capath",
        default="/etc/ssl/certs",
        help="Path to OpenSSL certificates",
        metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 1:
        parser.error("Must give METS filename as argument")
    try:
        signature = ipt.sip.signature.ManifestSMIME(signature_filename=args[0],
                                                    ca_path=options.capath)
        signature.verify_signature_file()
    except ipt.sip.signature.ErrorReadingSMIMEError as exception:
        print str(exception)
        return 117
    except ipt.sip.signature.WrongSignatureError as exception:
        print str(exception)
        return 117
    except ipt.sip.signature.WrongChecksumError as exception:
        print str(exception)
        return 117
    except ipt.sip.signature.UnexpectedError as exception:
        print str(exception)
        return 1
    return 0
