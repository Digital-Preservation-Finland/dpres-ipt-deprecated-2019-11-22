# Common coilerplate
import pytest
import testcommon.settings

# Module to test
import sip.signature

# Other imports
import shutil
import tempfile
import time
import os
import sys
import re
import subprocess

DATAROOT = os.path.join(
    os.path.abspath(os.path.dirname(__file__)), '..', 'data')


class TestVerifyManifestSMIME:

    def set_defaults(self):

        self.sip_path = tempfile.mkdtemp()
        self.ca_path = tempfile.mkdtemp()

        self.private_key = os.path.join(self.ca_path, 'key.pem')
        self.public_key = os.path.join(self.ca_path, 'key.pem')
        self.signature_file = os.path.join(
            self.sip_path, 'sip', 'varmiste.sig')

    def init_test(self):

        self.set_defaults()

        self.signature = sip.signature.ManifestSMIME(
            signature_filename=self.signature_file,
            private_key=self.private_key,
            public_key=self.public_key,
            ca_path=self.ca_path
        )

    def cleanup_test(self):

        shutil.rmtree(self.sip_path)
        shutil.rmtree(self.ca_path)

        self.signature = None

    def test_01_new_rsa_keypair(self):

        try:
            self.init_test()

            self.signature.new_signing_key()

            assert os.path.isfile(self.private_key), "Private key found %s" % (
                                                     self.private_key)
            assert os.path.isfile(self.public_key), "Public key found %s" % (
                                                    self.public_key)

            cmd = ['openssl x509 -text -in "%s"' % (self.public_key)]

            p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=
                                 subprocess.PIPE, stdout=subprocess.PIPE,
                                 close_fds=False, shell=True)

            (stdout, stderr) = p.communicate()

            # print stderr

            assert len(stderr) == 0, "No errors in certificate"
            assert stdout.find("Subject: C=FI, ST=Uusimaa, L=Helsinki, " +
                               "CN=ingest.local") > 0, "Subject found in certificate"
        finally:
            self.cleanup_test()

    def init_sip_test(self):

        self.init_test()

        src = os.path.join(DATAROOT, "sip-signature/sip-expired-signature")
        dst = os.path.join(self.sip_path, 'sip')

        print self.signature_file
        self.signature.sip_path = os.path.join(dst)

        print "CWD == ", os.getcwd()

        shutil.copytree(src, dst, symlinks=False, ignore=None)
        self.print_dirs(self.sip_path)

    def cleanup_sip_test(self):
        self.cleanup_test()

    def rehash_ca_path_symlinks(self):
            """ Generate symlinks to public keys in ca_path so

            that openssl command can find correct public keys

                openssl verify -CApath <ca_path>

            Symlinks are in format <x509 hash for public key>.0 -> keyfile.pem

            http://www.openssl.org/docs/apps/verify.html
            http://www.openssl.org/docs/apps/x509.html
            
            http://stackoverflow.com/questions/9879688/difference-between-cacert-and-capath-in-curl """

            cmd = ['openssl x509 -hash -noout -in %s' %
                   self.signature.public_key]

            p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=
                                 subprocess.PIPE, stdout=subprocess.PIPE,
                                 close_fds=False, shell=True)
            (stdout, stderr) = p.communicate()

            x509_hash_symlink = os.path.join(
                self.ca_path, '%s.0' % stdout.rstrip())
            os.symlink(self.signature.public_key, x509_hash_symlink)

            self.print_dirs(self.ca_path)

    def verify_signature_file_with_ca_path(self, signature_file):

            cmd = ['openssl smime -verify -in %s -CApath "%s"' % (
                self.signature_file, self.ca_path)]

            p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=
                                 subprocess.PIPE, stdout=subprocess.PIPE,
                                 close_fds=False, shell=True)
            (stdout, stderr) = p.communicate()

            print "stdout", stdout
            print "stderr", stderr

            assert stderr.find(
                'Verification successful') == 0, "Verification successful"
            assert stdout.find('sha1:') == 0, "Contains checksum algorithm"
            assert stdout.find(
                ':mets.xml') == 45, "Contains checksum file name"

    def test_04_valid_certificate(self):
        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            self.print_dirs(self.sip_path)
            self.print_file(self.signature_file)

            assert os.path.isfile(
                self.signature_file), "Signature file found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            result = self.verify_signature_file_with_ca_path(
                self.signature_file)

            try:
                self.signature.verify_signature_file()
            except Exception as e:
                print "Test caught exception:\n", e
                assert True, "Valid signature should not raise exception."

        finally:
            self.cleanup_sip_test()

    def test_04_no_certificate(self):
        try:
            self.init_sip_test()

            os.remove(self.signature_file)
            assert not os.path.isfile(
                self.signature_file), "Signature file found %s" % self.signature_file

            try:
                result = self.signature.verify_signature_file()
                assert False, "Verification without signature file must raise exception"
            except AssertionError as e:
                raise e
            except Exception as e:
                print "Test caught exception:\n", e

        finally:
            self.cleanup_sip_test()

    def test_05_invalid_certificate(self):

        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            # Just add some trash to signature file
            f = open(self.signature_file, 'r+b')
            f.seek(600, 0)
            f.write('foo')
            f.close()

            assert os.path.isfile(
                self.signature_file), "Signature file found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            self.print_dirs(self.sip_path)
            self.print_dirs(self.ca_path)
            self.print_file(self.signature_file)

            try:
                self.signature.verify_signature_file()
                assert False, "Verification with broken signature file must raise exception"
            except AssertionError as e:
                raise e
            except Exception as e:
                print "Test caught exception:\n", e
                assert e.args[0].find(
                    'Error reading S/MIME message') > 0, "Must get error reading certificate"

        finally:
            self.cleanup_sip_test()

    def test_06_expired_certificate(self):
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
                self.signature_file), "Signature file found %s" % self.signature_file

            try:
                result = self.signature.verify_signature_file()
                assert False, "Verification with exporired signature file must raise exception"
            except AssertionError as e:
                raise e
            except Exception as e:
                print "Test caught exception:\n", e
                assert e.args[0].find(
                    'Verify error:certificate has expired') > 0, "Must get certificate has expired error"

        finally:
            self.cleanup_sip_test()
        pass

    def test_08_altered_mets_xml(self):
        try:
            self.init_sip_test()
            self.signature.new_signing_key()
            self.signature.write_signature_file()

            # Just add some trash to mets.xml
            f = open(os.path.join(self.sip_path, 'sip', 'mets.xml'), 'r+b')
            f.seek(600, 0)
            f.write('foo')
            f.close()

            assert os.path.isfile(
                self.signature_file), "Signature file found %s" % self.signature_file

            self.rehash_ca_path_symlinks()

            self.print_dirs(self.sip_path)
            self.print_dirs(self.ca_path)
            self.print_file(self.signature_file)

            try:
                self.signature.verify_signature_file()
                assert False, "Verification with broken signature file must raise exception"
            except AssertionError as e:
                raise e
            except Exception as e:
                print "Test caught exception:\n", e
                find_str = 'Checksum does not match sha1'
                error_str = "Must get checksum does not match error sha1"
                assert e.args[0].find(find_str) == 0, error_str
                find_str = ' mets.xml'
                error_str = "Checksum does not match for mets.xml"
                assert e.args[0].find(find_str) > 0, error_str
        finally:
            self.cleanup_sip_test()

    def run_single_test(self, line):
        pass

        #signaturefile = SIP.Signature('signature')
        #child = subprocess.Popen(line, shell=True, bufsize=100000, stderr=subprocess.STDERR, stdout=subprocess.STDOUT, close_fds=False)
        #assert retval == testCases[casename]["ret"]
        #print(str(ret) + ' == ' + clearString(str(testCases[casename]["ret"])))

    def print_dirs(self, path):

        print "\n-------------- START - %s --------------------" % path
        cmd = ['find "%s" -ls' % (path)]
        p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stderr=
                             subprocess.PIPE, stdout=subprocess.PIPE,
                             close_fds=False, shell=True)

        (stdout, stderr) = p.communicate()
        print stdout, stderr
        print "-------------- END - %s --------------------" % path

    def print_file(self, path):
        print "\n-------------- START - %s --------------------" % path
        f = open(path)
        for line in f:
            sys.stdout.write(line)
        f.close()
        print "-------------- END - %s --------------------" % path

    def clearString(self, input):
        pass
        #inputx = ''.join(inputy)
        #inputx = inputx.replace('\'', '')
        #inputx = inputx.replace("\'", "")
        #inputx = inputx.replace("[", "")
        #inputx = inputx.replace("]", "")
        #inputx = inputx.replace("'", "")
        # return inputx
