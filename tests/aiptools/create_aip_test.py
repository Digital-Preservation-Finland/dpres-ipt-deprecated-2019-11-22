"""Unit tests for create_aip library and integration test for according command line utility"""

import os.path
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.abspath(os.path.join(
    os.path.dirname(__file__), '../../src')))

import testcommon.settings
import testcommon.shell

# Module to test
import aiptools.bagit
import aiptools.RenameSIPtoAIP
import aiptools.create_aip

import pas_scripts.create_aip

import shutil

TEMP_DIR = '/tmp/test-create-aip'

TEST_SIP_NAME = "CSC_test001"
TEST_SIP_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            '../data/test-sips', TEST_SIP_NAME)

SIP_DIR_INVALID = os.path.join(TEMP_DIR, "foo-sip")
SIP_DIR = os.path.join(TEMP_DIR, 'sip_4321b_1234a')
AIP_DIR = os.path.join(TEMP_DIR, 'aip_1234a_4321b')

EXPECTED_FILES = [
    "data/kuvat/P1020137.JPG",
    "data/kuvat/PICT0081.JPG",
    "data/kuvat/PICT0102.JPG",
    "data/mets.xml",
    "data/varmiste.sig",
    "bag-info.txt",
    "bagit.txt",
    "manifest-md5.txt"]


class Testcreate_aip:

    def init_test_files(self):
        if os.path.exists(TEMP_DIR):
            shutil.rmtree(TEMP_DIR)
        os.makedirs(TEMP_DIR)
        shutil.copytree(TEST_SIP_DIR, SIP_DIR)

    def get_files_in_tree(self, tree='.', root=''):
        """Return a list of all filepaths in given directory."""
        result = []
        for path, x,  filenames in os.walk(tree):
            for filename in filenames:
                  result.append(os.path.abspath(os.path.join(path, filename)))
        return result

    def test_create_aip_from_sip(self):

        self.init_test_files()

        aiptools.create_aip.create_aip_from_sip(SIP_DIR)

        assert os.path.exists(os.path.join(SIP_DIR, 'data'))

        expected_files_abspath = []
        for filename in EXPECTED_FILES:
            filename_abs = os.path.join(SIP_DIR, filename)
            filename_abs = filename_abs.replace('%sipname%',
                    os.path.basename(SIP_DIR))
            expected_files_abspath.append(os.path.join(SIP_DIR, filename_abs))

        result_files = self.get_files_in_tree(SIP_DIR, TEMP_DIR)
        message = '\n'.join(['expected:',
                             '\n'.join(sorted(expected_files_abspath)),
                             'got:', '\n'.join(sorted(result_files))])
        print message
        assert set(result_files) == set(expected_files_abspath), message

    def test_create_aip_with_invalid_sip_path(self):

        self.init_test_files()

        try:
            aiptools.create_aip.create_aip_from_sip(SIP_DIR_INVALID)
            result = False
        except IOError as exception:
            print exception
            result = True

        assert result, "Invalid SIP directory must raise exception"
        assert not os.path.exists(SIP_DIR_INVALID)

    def run_test_command(self, sipdir):

        self.init_test_files()

        (returncode, stdout, stderr) = testcommon.shell.run_main(
                pas_scripts.create_aip.main, ['%s' % sipdir])

        print returncode, stdout, stderr
        return (returncode, stdout, stderr)

    def test_command_line_ok(self):

        (returncode, stdout, stderr) = self.run_test_command(SIP_DIR)

        assert returncode == 0
        assert stdout.find(SIP_DIR) > 0
        assert len(stderr) == 0

    def test_command_line_failure(self):

        (returncode, stdout, stderr) = self.run_test_command(SIP_DIR_INVALID)

        assert returncode != 0
        assert stdout.find(SIP_DIR_INVALID) > 0
        assert len(stderr) > 0


