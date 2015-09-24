"""
This is a test module for SMIME signature files verification.
"""
# pytest does not work with __init__() so it is missing deliberately.
# pylint warining is disable for the tests accordingly.
# pylint: disable=W0232
import os
import sys
from pytest import raises
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import testcommon.settings
import testcommon.test_utils

# Module to test
import ipt.sip.signature

# Other imports
import shutil
import tempfile


import subprocess

DATAROOT = os.path.join(
    os.path.abspath(os.path.dirname(__file__)), '..', 'data')


class TestVerifyManifestSMIME(object):
    """
    Test class for testing SMIME signature files verification.
    """
    signature = None
    sip_path = None
    ca_path = None
    report_path = None
    signature_file = None
    private_key = \
        '/tmp/test.ipt.signature/kdk-pas-sip-signing-key.pem'
    public_key = \
        '/tmp/test.ipt.signaturefile/kdk-pas-sip-signing-key.pub'

    def test_create_report_signature(self):
        """
        Test for creating report signature succesfully.
        """
        test_util = testcommon.test_utils.Utils()
        self.report_path = os.path.join(
            test_util.tempdir('reports'), 'varmiste.sig')

        # creating a test xml-report
        report_path = os.path.join(
            os.path.dirname(self.report_path), 'report.xml')
        testcommon.test_utils.run_command("echo 'report' >> " + report_path)

        # creating signaturefile for report
        signature = ipt.sip.signature.ManifestSMIME(
            signature_filename=self.report_path,
            private_key=self.private_key,
            public_key=self.public_key)

        signature.new_signing_key()
        signature.write_signature_file()
        (ret, stdout, stderr) = testcommon.test_utils.run_command(
            "cat " + self.report_path)
        assert ret == 0
        print stdout, stderr
        (ret, stdout, stderr) = testcommon.test_utils.run_command(
            "ls -la " + self.report_path)
        print stdout, stderr
        assert ret == 0

    def set_defaults(self):
        """
        Set deafults.
        """
        self.sip_path = tempfile.mkdtemp()
        self.ca_path = tempfile.mkdtemp()

        self.private_key = os.path.join(self.ca_path, 'key.pem')
        self.public_key = os.path.join(self.ca_path, 'key.pem')
        self.signature_file = os.path.join(
            self.sip_path, 'sip', 'varmiste.sig')

    def init_test(self):
        """
        Init test.
        """
        self.set_defaults()

        self.signature = ipt.sip.signature.ManifestSMIME(
            signature_filename=self.signature_file,
            private_key=self.private_key,
            public_key=self.public_key,
            ca_path=self.ca_path
        )

    def cleanup_test(self):
        """
        Cleanup test.
        """
        shutil.rmtree(self.sip_path)
        shutil.rmtree(self.ca_path)

        self.signature = None

    def test_01_new_rsa_keypair(self):
        """
        Test new RSA keypair.
        """
        try:
            self.init_test()
            self.signature.new_signing_key()

            assert os.path.isfile(self.private_key), \
                "Private key not found %s" % (self.private_key)
            assert os.path.isfile(self.public_key), \
                "Public key not found %s" % (self.public_key)

            cmd = ['openssl x509 -text -in "%s"' % (self.public_key)]

            proc = subprocess.Popen(
                cmd, stdin=subprocess.PIPE, stderr=subprocess.PIPE,
                stdout=subprocess.PIPE, close_fds=False, shell=True)

            (stdout, stderr) = proc.communicate()

            assert len(stderr) == 0, "An error was found in the certificate"
            assert stdout.find(
                "Subject: C=FI, ST=Uusimaa, L=Helsinki, " +
                "CN=ingest.local") > 0, "Subject was not found in the " +\
                "certificate"
        finally:
            self.cleanup_test()

    def init_sip_test(self):
        """
        Init sip.
        """
        self.init_test()

        src = os.path.join(DATAROOT, "sip-signature/sip-expired-signature")
        dst = os.path.join(self.sip_path, 'sip')

        print self.signature_file
        self.signature.sip_path = os.path.join(dst)

        print "CWD == ", os.getcwd()

        shutil.copytree(src, dst, symlinks=False, ignore=None)
        self.print_dirs(self.sip_path)

    def cleanup_sip_test(self):
        """
        Cleanup sip test.
        """
        self.cleanup_test()

    def rehash_ca_path_symlinks(self):
        """ Generate symlinks to public keys in ca_path so

        that openssl command can find correct public keys

            openssl verify -CApath <ca_path>

        Symlinks are in format <x509 hash for public key>.0 -> keyfile.pem

        http://www.openssl.org/docs/apps/verify.html
        http://www.openssl.org/docs/apps/x509.html

        http://stackoverflow.com/questions/9879688/\
        difference-between-cacert-and-capath-in-curl """

        cmd = ['openssl x509 -hash -noout -in %s' %
               self.signature.public_key]

        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=subprocess.PIPE,
            close_fds=False, shell=True)
        (stdout, _) = proc.communicate()

        x509_hash_symlink = os.path.join(
            self.ca_path, '%s.0' % stdout.rstrip())
        os.symlink(self.signature.public_key, x509_hash_symlink)

        self.print_dirs(self.ca_path)

    def test_04_valid_certificate(self):
        """
        Test valid certificate.
        """
        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            self.print_dirs(self.sip_path)
            self.print_file(self.signature_file)

            assert os.path.isfile(self.signature_file), \
                "Signature file not found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            try:
                self.signature.verify_signature_file()
            except Exception as error:
                print "Test caught exception:\n", error
                assert False, "Valid signature should not raise exception."

        finally:
            self.cleanup_sip_test()

    def test_04_no_certificate(self):
        """
        Test missing certificate.
        """
        try:
            self.init_sip_test()

            os.remove(self.signature_file)
            assert not os.path.isfile(self.signature_file), \
                "Signature file not found %s" % self.signature_file

            with raises(ipt.sip.signature.SMIMEReadError):
                self.signature.verify_signature_file()

        finally:
            self.cleanup_sip_test()

    def test_05_invalid_certificate(self):
        """
        Test invalid certificate.
        """
        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            # Just add some trash to signature file
            file_ = open(self.signature_file, 'r+b')
            file_.seek(600, 0)
            file_.write('foo')
            file_.close()

            assert os.path.isfile(self.signature_file), \
                "Signature file not found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            self.print_dirs(self.sip_path)
            self.print_dirs(self.ca_path)
            self.print_file(self.signature_file)

            with raises(ipt.sip.signature.SMIMEReadError):
                self.signature.verify_signature_file()
        finally:
            self.cleanup_sip_test()

    def test_06_expired_certificate(self):
        """
        Test expired certificate.
        """
        try:
            self.init_sip_test()

            # Copy expired certificate to ca_path
            src = os.path.join(DATAROOT, 'sip-signature',
                               'expired-certificate.pem')
            dst = os.path.join(self.ca_path, self.public_key)
            shutil.copyfile(src, dst)
            self.rehash_ca_path_symlinks()

            self.print_dirs(self.ca_path)

            assert os.path.isfile(
                self.signature_file), \
                "Signature file not found %s" % self.signature_file

            with raises(ipt.sip.signature.InvalidSignatureError):
                self.signature.verify_signature_file()
        finally:
            self.cleanup_sip_test()

    def test_08_altered_mets_xml(self):
        """
        Test altered mets.xml.
        """
        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            # Just add some trash to mets.xml
            file_ = open(os.path.join(self.sip_path, 'sip', 'mets.xml'), 'r+b')
            file_.seek(600, 0)
            file_.write('foo')
            file_.close()

            assert os.path.isfile(
                self.signature_file), \
                "Signature file not found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            self.print_dirs(self.sip_path)
            self.print_dirs(self.ca_path)
            self.print_file(self.signature_file)

            with raises(ipt.sip.signature.InvalidChecksumError):
                self.signature.verify_signature_file()
        finally:
            self.cleanup_sip_test()

    def print_dirs(self, path):
        """
        Print print dirs.
        """
        print "\n-------------- START - %s --------------------" % path
        cmd = ['find "%s" -ls' % (path)]
        proc = subprocess.Popen(
            cmd, stdin=subprocess.PIPE,
            stderr=subprocess.PIPE, stdout=subprocess.PIPE,
            close_fds=False, shell=True)

        (stdout, stderr) = proc.communicate()
        print stdout, stderr
        print "-------------- END - %s --------------------" % path

    def print_file(self, path):
        """
        Print print dirs.
        """
        print "\n-------------- START - %s --------------------" % path
        file_ = open(path)
        for line in file_:
            sys.stdout.write(line)
        file_.close()
        print "-------------- END - %s --------------------" % path
