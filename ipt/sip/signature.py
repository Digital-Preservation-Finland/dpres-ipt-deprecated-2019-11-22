"""
This is a module for creating and verifying SMIME certificates and
signing keys.
"""

import subprocess
import os
import fnmatch
import tempfile
import ipt.fileutils.checksum


class InvalidSignatureError(Exception):

    """Raised when signature is not valid."""
    pass


class UnexpectedError(Exception):

    """Raised when unexpected error occurs."""
    pass


class InvalidChecksumError(Exception):

    """Raised when checksum is not valid."""
    pass


class SMIMEReadError(Exception):

    """Raised when SMIME reading fails."""
    pass


class ManifestSMIME(object):

    """
    Class for SMIME manifest
    """
    manifest_base_path = ''
    target_path = None
    # These keys are for signing files with systems own keys.
    # Not to be confused
    # with users public key used in signature validation.
    ca_path = '/etc/ssl/certs'
    private_key = \
        '/usr/share/pas/microservice/ssl/keys/kdk-pas-sip-signing-key.pem'
    public_key = \
        '/usr/share/pas/microservice/ssl/keys/kdk-pas-sip-signing-key.pub'
    signature_file = 'varmiste.sig'

    country = 'FI'
    state = 'Uusimaa'
    location = 'Helsinki'
    common_name = 'ingest.local'

    def __init__(self, signature_filename=None, private_key=None,
                 public_key=None, ca_path=None, target_path=None):

        if signature_filename:
            self.signature_file = signature_filename
        if ca_path:
            self.ca_path = ca_path

        if private_key:
            self.private_key = private_key

        if public_key:
            self.public_key = public_key

        if target_path:
            self.target_path = target_path

        self.manifest_base_path = os.path.abspath(
            os.path.dirname(self.signature_file))

    def new_signing_key(self):
        """Create a private/public key pair used to sign KDK-PAS SIPs

           http://www.openssl.org/docs/apps/req.html
           http://www.madboa.com/geek/openssl/ """

        if not os.path.exists(os.path.dirname(self.private_key)):
            os.makedirs(os.path.dirname(self.private_key))

        if not os.path.exists(os.path.dirname(self.public_key)):
            os.makedirs(os.path.dirname(self.public_key))

        # Note, this may not be safe for UTF-8 strings in self.country etc.
        cmd = ['openssl', 'req', '-x509', '-nodes', '-days', '365', '-newkey',
               'rsa:2048', '-subj',
               '/C=%s/ST=%s/L=%s/CN=%s' % (self.country, self.state,
                                           self.location, self.common_name),
               '-keyout', self.private_key, '-out', self.public_key]

        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=subprocess.PIPE,
            close_fds=False, shell=False)

        (stdout, stderr) = proc.communicate()

        print stdout, stderr

        cmd = ['openssl', 'x509', '-text', '-in', self.public_key]

        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=subprocess.PIPE,
            close_fds=False, shell=False)

        (stdout, stderr) = proc.communicate()

        print stdout, stderr

    def write_signature_file(self, paths=None, file_checksum_type='MD5'):
        """ Write SIP signature file varmiste.sig with checksums of all .xml
        files in manifest_base_path

        Signature file is formatted as following:

        ### Signature file starts with S/MIME container header
        MIME-Version: 1.0
        Content-Type: multipart/signed;
        protocol="application/x-pkcs7-signature"; micalg="sha1";
        boundary="----39E2251AA194465CC9D401144063F2D3"

        This is an S/MIME signed message

        ------39E2251AA194465CC9D401144063F2D3
        mets.xml:sha1:ab16aee4eb1eda360ed5d1b59d18bf4cf144f8fc

        ------39E2251AA194465CC9D401144063F2D3
        Content-Type: application/x-pkcs7-signature; name="smime.p7s"
        Content-Transfer-Encoding: base64
        Content-Disposition: attachment; filename="smime.p7s"

        MIIF+QYJKoZIhvcNAQcCoIIF6jCCBeYCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
        < ... 30 lines more of digital signature ... >
        XzTLy+drurKzEpWP2Tszo3MCsPHjHIVqK9yGn/gdPbth+C9pOVF28Ygv93yp

        ------39E2251AA194465CC9D401144063F2D3--
        ### Signature file ends here with newline"""

        matches = []
        if self.target_path is None:
            for root, dirnames, filenames in os.walk(self.manifest_base_path):
                for filename in fnmatch.filter(filenames, '*.xml'):
                    matches.append(os.path.join(root, filename))
        else:
            matches = self.target_path.split(',')
        manifest_fh, manifest_filename = tempfile.mkstemp()

        algorithm = 'sha1'
        checksum = ipt.fileutils.checksum.BigFile(algorithm)
        print "matches", matches
        for filename in matches:

            hexdigest = checksum.hexdigest(filename)
            filename_relative = filename[len(self.manifest_base_path) + 1:]

            file_checksum = "%s:%s:%s\n" % (filename_relative, algorithm,
                                            hexdigest)

            os.write(manifest_fh, file_checksum)
            print file_checksum

        # Close temporary manifest just before reading it
        os.close(manifest_fh)

        cmd = ['openssl', 'smime', '-sign', '-signer', self.private_key, '-in',
               manifest_filename]

        sign_path = os.path.join(self.manifest_base_path, self.signature_file)
        print "SIGN_PATH", sign_path
        signature_file = open(sign_path, 'w')

        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=signature_file,
            close_fds=True, shell=False)

        (stdout, stderr) = proc.communicate()
        print cmd, proc.returncode, stdout, stderr
        signature_file.close()

        # cleanup temporary manifest after everything ready
        os.remove(manifest_filename)

    def verify_signature_file(self):
        """ Verify SIP signature varmiste.sig file """

        cmd = ['openssl', 'smime', '-verify', '-in',
               os.path.join(self.manifest_base_path, self.signature_file),
               '-CApath', self.ca_path]

        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=subprocess.PIPE,
            close_fds=True, shell=False)

        (stdout, stderr) = proc.communicate()
        # http://www.openssl.org/docs/apps/verify.html
        if proc.returncode == 4:
            raise InvalidSignatureError(
                'Invalid signature on signature file. Exitcode: %s\n%s\n%s' % (
                    proc.returncode, stdout, stderr))
        if proc.returncode == 2:
            raise SMIMEReadError(
                'Unknown error. Exitcode: %s\nStdout: %s\nStderr: %s' % (
                    proc.returncode, stdout, stderr))
        if proc.returncode != 0:
            raise UnexpectedError('Unexpected error')

        # assert stderr.find('Verification successful')  == 0,
        # "Invalid signature on certificate"
        # TODO: Manifest can also be refactored as separate class...
        checksum = ipt.fileutils.checksum.BigFile('sha1')
        for line in stdout.splitlines():
            algorithm, hexdigest, filename = self.parse_manifest_line(line)
            if not algorithm:
                continue
            checksum_ok = checksum.verify_file(
                os.path.join(self.manifest_base_path, filename),
                hexdigest)
            if checksum_ok:
                print "%s %s %s OK" % (filename, algorithm, hexdigest)
            else:
                raise InvalidChecksumError("Checksum does not match %s %s %s" % (
                    algorithm, hexdigest, filename))

    def parse_manifest_line(self, line):
        """
        Parsing a line from a manifest file.
        """
        fields = line.rstrip().split(':')

        if len(fields) != 3:
            return (None, None, None)
        filename = fields[0]
        algorithm = fields[1]
        hexdigest = fields[2]

        return (algorithm, hexdigest, filename)
