"""Test restructure SIP library and command line utility"""

import sys
import os.path
import shutil

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.abspath(os.path.join(
    os.path.dirname(__file__), '../../information-package-tools')))

import testcommon.settings

import ipt.sip.restructure

TEST_SIP_NAME = "CSC_test001"
TEST_SIP_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            '../data/test-sips', TEST_SIP_NAME)

TEMP_DIR = '/tmp/test-restructure-sip'

SIP_DIR_INVALID = os.path.join(TEMP_DIR, "foo-sip")
SIP_DIR = os.path.join(TEMP_DIR, 'sip_4321b_1234a')
AIP_DIR = os.path.join(TEMP_DIR, 'aip_1234a_4321b')

TRANSFER_NAME = 'test-transfer-123'

EXPECTED_FILES = [
    "transfers/%s/kuvat/P1020137.JPG" % (TRANSFER_NAME),
    "transfers/%s/kuvat/PICT0081.JPG" % (TRANSFER_NAME),
    "transfers/%s/kuvat/PICT0102.JPG" % (TRANSFER_NAME),
    "transfers/%s/mets.xml" % (TRANSFER_NAME),
    "transfers/%s/varmiste.sig" % (TRANSFER_NAME)]

class TestRestructureSIP:
    """Test class"""
    def test_restructure_sip(self):
        """Test working case"""

    def init_test_files(self):
        if os.path.exists(TEMP_DIR):
            shutil.rmtree(TEMP_DIR)
        os.makedirs(TEMP_DIR)
        shutil.copytree(TEST_SIP_DIR, SIP_DIR)

    def run_test_command(self, sipdir):
        self.init_test_files()
        return testcommon.shell.runcommand(' ; '.join([
            'cd "%s"' % TEMP_DIR,
            'restructure-sip "%s"' % sipdir]))

    def get_files_in_tree(self, tree='.', root=''):
        """Return a list of all filepaths in given directory."""
        result = []
        for path, x, filenames in os.walk(tree):
            for filename in filenames:
                  result.append(os.path.abspath(os.path.join(path, filename)))
        return result

    def test_create_aip_from_sip(self):

        self.init_test_files()

        ipt.sip.restructure.restructure_sip(SIP_DIR, TRANSFER_NAME)

        assert os.path.exists(os.path.join(SIP_DIR, 'transfers'))

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
