#!/usr/bin/python
# vim:ft=python
"""
Create digital signature file for xml-file with command::

    sign-xml rsa-private-key.pem <xml_file_path>varmiste.sig

To create digital signature you need valid RSA private key. Filename to private
key is passed as command line parameter.

On succesful signing command returns exit status 0. On failure returns error
code.

Digital signature for xml-file(or any file) is a manifest file
:file:`varmiste.sig` that lists all files, that are in xml.format and their
checksums in the directory of varmiste.sig given in arguments. To authenticate
creator of manifest it is signed with OpenSSL / SMIME digital signature.

For more information about OpenSSL/SMIME signatures and RSA public/private
keypairs see:

    * http://www.openssl.org/docs/apps/req.html
    * http://www.madboa.com/geek/openssl/

"""

import optparse
import ipt.sip.signature


def main(arguments=None):
    """Parse arguments and pass them to `sip.signature.ManifestSMIME`. """

    usage = "usage: %prog rsa-private-keyfile.pem /path/to/varmiste_file.sig \
            /path/to/mets.xml"

    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-c", "--capath", dest="capath",
                      default="/etc/ssl/certs",
                      help="Path to OpenSSL certificates",
                      metavar="PATH")

    parser.add_option("-s", "--signaturepath", dest="signaturepath",
                      default=None,
                      help="Path to signature file",
                      metavar="PATH")

    parser.add_option("-t", "--signaturetargets", dest="signaturetargets",
                      default=None,
                      help="List of file paths which need to be signed",
                      metavar="PATH")

    (options, args) = parser.parse_args(arguments)

    if len(args) != 3:
        parser.error("Must give private key (in PEM format) file as first \
        argument, signaturepath as second and target file as third argument")
        return 1

    try:

        signature = ipt.sip.signature.ManifestSMIME(
            signature_filename=args[1],
            private_key=args[0],
            public_key=args[0],
            target_path=args[2]
        )

        signature.write_signature_file()

    except BaseException as exception:
        print str(exception)
        return 1

    return 0
