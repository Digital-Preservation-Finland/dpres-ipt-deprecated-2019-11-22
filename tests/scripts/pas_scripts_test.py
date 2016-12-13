# Common boilerplate
import os
import sys
import tempfile
import shutil
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import re
import pytest
import testcommon.shell
import testcommon.settings
from testcommon.casegenerator import pytest_generate_tests

# Modules to test
import ipt.scripts.premis2html
import ipt.scripts.restructure_sip
import ipt.scripts.sign_xml_file
import ipt.scripts.check_sip_signature
import ipt.scripts.check_sip_digital_objects
import ipt.scripts.check_xml_schema_features
import ipt.scripts.check_xml_schematron_features


class TestCommandLineTools:

    testcases = {
        "test_restructure_sip":
        [{
            "testcase": "Test restructure sip",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        }],
        "test_premis2html":
        [{
            "testcase": "create failed report",
            "expected_result": {
                "returncode": 0,
                "stderr": ""

            }
        }],
            "test_sign_xml_file":
        [{
            "testcase": "Test valid varmiste",
            "certificate": "valid-certificate.pem",
            "sipname": "CSC_test005",
            "signature_name": "varmiste.sig",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": ""
            }
        },
         {
            "testcase": "Test valid signature",
            "certificate": "valid-certificate.pem",
            "sipname": "CSC_test001_signature",
            "signature_name": "signature.sig",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": ""
            }
        },
            {
            "testcase": "Test invalid signature",
            "certificate": "invalid-certificate.pem",
            "sipname": "CSC_test005",
            "signature_name": "varmiste.sig",
            "expected_result": {
                "returncode": 0,  # sign_xml_file returns zero even in case of
                # error and prints errors to stdout
                "in_stdout": ["No such file or directory"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": []
            }
        }],
                "test_check_sip_signature":
        [{
            "testcase": "Test valid signature varmiste.sig",
            "sipname": "CSC_test006",
            "signature_name": "varmiste.sig",
            "expected_result": {
                "returncode": 0,
                "in_stdout": ["OK"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": ""
            }
        },
            {
            "testcase": "Test valid signature signature.sig",
            "sipname": "CSC_test001_signature",
            "signature_name": "signature.sig",
            "expected_result": {
                "returncode": 0,
                "in_stdout": ["OK"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": ""
            }
        }]
    }

    def test_premis2html(self, testcase, expected_result):

        command = ipt.scripts.premis2html.main
        report_dir = os.path.join(testcommon.settings.TESTDATADIR,
                                  "reports",
                                  "report-csc_test_invalid_digital_object_001-bb358d14-3092-458d-8b57-4a1c40206d8e-12345.xml")
        test_dir = tempfile.mkdtemp()
        html_path = os.path.join(test_dir, 'report.html')
        arguments = [report_dir, html_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)
        shutil.rmtree(test_dir)
        print returncode, stdout, stderr
        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

    @pytest.mark.usefixtures("monkeypatch_Popen")
    def test_restructure_sip(self, testcase, expected_result):

        sip_dir = os.path.join(
            testcommon.settings.TESTDATADIR, 'test-sips/CSC_test006')
        restructure_dir = tempfile.mkdtemp() + '/restructure'
        shutil.copytree(sip_dir, restructure_dir)

        command = ipt.scripts.restructure_sip.main
        arguments = [restructure_dir, 'CSC_test006']
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)

        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        restructure_files = ['metadata', 'logs', 'transfer']

        # Test that aip contains all restructure files
        for file in restructure_files:
            assert file in restructure_files

    @pytest.mark.usefixtures("monkeypatch_Popen")
    def test_sign_xml_file(self, testcase, certificate, expected_result,
                           signature_name, sipname):

        mets_path = os.path.join(
            testcommon.settings.TESTDATADIR, 'test-sips', sipname, 'mets.xml')

        certificate_path = os.path.join(testcommon.settings.TESTDATADIR,
                                        'sip-signature/' + certificate)

        temp_path = tempfile.mkdtemp()
        shutil.copy(mets_path, temp_path)

        temp_mets_path = os.path.join(temp_path, 'mets.xml')
        signature_path = os.path.join(temp_path, signature_name)

        command = ipt.scripts.sign_xml_file.main
        arguments = [certificate_path, signature_path, temp_mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)

        print os.listdir(temp_path)
        print returncode, stdout, stderr

        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        for message in expected_result['in_stdout']:
            assert message in stdout

        for message in expected_result['not_in_stdout']:
            assert message not in stdout

        for message in expected_result['in_stderr']:
            assert message in stderr

    def test_check_sip_signature(
            self, testcase, sipname, signature_name, expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                                 'test-sips/' + sipname + '/mets.xml')

        certificate_dir = os.path.join(testcommon.settings.TESTDATADIR,
                                       'sip-signature/')
        certificate_path = certificate_dir + 'valid-certificate.pem'

        sip_dir = tempfile.mkdtemp()
        shutil.copy(mets_path, sip_dir)
        mets_path = os.path.join(sip_dir, 'mets.xml')

        command = ipt.scripts.sign_xml_file.main
        signature_file = os.path.join(sip_dir, signature_name)
        arguments = [certificate_path, signature_file, mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)
        print returncode, stdout, stderr
        assert returncode == 0

        command = ipt.scripts.check_sip_signature.main
        arguments = [signature_file]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)
        print returncode, stdout, stderr
        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        for message in expected_result['in_stdout']:
            assert message in stdout

        for message in expected_result['not_in_stdout']:
            assert message not in stdout

        for message in expected_result['in_stderr']:
            assert message in stdout
