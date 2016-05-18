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
import ipt.scripts.sip2aip
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
        }],
            "test_sip2aip":
        [{
            "testcase": "Test create aip",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        }],
                "test_check_sip_digital_objects":
        [{
            "testcase": "Test valid sip package #1",
            "filename": "CSC_test001",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        }, {
            "testcase": "Test valid sip package #2",
            "filename": "CSC_test002",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        }, {
            "testcase": "Test sip with whitespace sip package #3",
            "filename": "CSC whitespace",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        },
            {
            "testcase": "Test valid sip package with non-existing validator (ALTO)",
            "filename": "CSC_test004",
            "expected_result": {
                "returncode": 117,
                "stdout": ["No validator for mimetype: text/xml version: ALTO " +
                           "schema Version 1.4"],
                "stderr": []
            }
        }, {
            "testcase": "Test valid sip package #6: csc-test-valid-kdkmets-1.3",
            "filename": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
        }],
                "test_check_xml_schema_features":
        [{
            "testcase": "Test valid mets.xml",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "\n",  # There"s extra line wrap in stderr
                "in_stderr": ""
            }
        },
            {
            "testcase": "Test invalid mets.xml",
            "sipname": "CSC_test005",
            "expected_result": {
                "returncode": 117,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "",
                "in_stderr": ["fails to validate"]
            }
        }
        ],
                "test_check_xml_schematron_features":
        [{
            "testcase": "Test valid mets.xml",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "",
                "in_stderr": ""
            }
        },
            {
            "testcase": "Test invalid mets.xml",
            "sipname": "CSC_test005",
            "expected_result": {
                "returncode": 1,
                "in_stdout": ["Error"],
                "not_in_stdout": [],
                "stderr": "",
                "in_stderr": []
            }
        }
            #         ],
            #                "test_check_mets_optional_features":
            #        [{
            #            "testcase": "Test valid mets.xml",
            #            "sipname": "CSC_test006",
            #            "expected_result": {
            #                "returncode": 0,
            #                "in_stdout": [],
            #                "not_in_stdout": [],
            # "stderr": "\n", # There"s extra line wrap in stderr
            #                "in_stderr": ""
            #            }
            #         },
            #         {
            #            "testcase": "Test invalid mets.xml",
            #            "sipname": "CSC_test005",
            #            "expected_result": {
            #                "returncode": 1,
            #                "in_stdout": [],
            #                "not_in_stdout": [],
            #                "stderr": "",
            #                "in_stderr": []
            #            }
            #         }
        ]
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

    def test_sip2aip(self, testcase, expected_result):

        sip_dir = os.path.join(
            testcommon.settings.TESTDATADIR, 'test-sips/CSC_test005')
        aip_dir = tempfile.mkdtemp() + '/aip '
        shutil.copytree(sip_dir, aip_dir)

        command = ipt.scripts.sip2aip.main
        arguments = [aip_dir]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command,
            arguments)

        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        sip_files = os.listdir(sip_dir)
        aip_files = os.listdir(aip_dir)
        aip_data_files = os.listdir(aip_dir + '/data')
        baggit_files = [
            'data', 'manifest-md5.txt', 'bag-info.txt', 'bagit.txt']

        # Test that aip contains all files from sip
        assert len(set(sip_files) - set(aip_data_files)) == 0

        # Test that aip contains all bagit files
        for file in baggit_files:
            assert file in baggit_files

        # Test that aip doesn't contain anything more
        assert len(baggit_files) == len(aip_files)

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

        mets_path = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
            sipname, 'mets.xml')
        certificate_path = os.path.join(testcommon.settings.TESTDATADIR,
                                        'sip-signature/' + certificate)
        signature_path = os.path.join(testcommon.settings.TESTDATADIR,
            'test-sips', sipname, signature_name)

        sip_dir = tempfile.mkdtemp()
        shutil.copy(mets_path, sip_dir)

        command = ipt.scripts.sign_xml_file.main
        arguments = [certificate_path, signature_path, mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)

        print os.listdir(sip_dir)
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

    def test_check_xml_schema_features(self, testcase, sipname, expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                                 'test-sips/' + sipname + '/mets.xml')

        command = ipt.scripts.check_xml_schema_features.main
        arguments = [mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)

        assert returncode == expected_result['returncode'], stdout + stderr

        for message in expected_result['in_stdout']:
            assert message in stdout

        for message in expected_result['not_in_stdout']:
            assert message not in stdout

        for message in expected_result['in_stderr']:
            assert message in stderr


# def test_check_mets_optional_features(self, testcase, sipname,
# expected_result):

#        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
#                               'test-sips/' + sipname + '/mets.xml')


#        command = pas_ipt.scripts.check_mets_optional_features.main
#        arguments = [mets_path]
#        (returncode, stdout, stderr) = testcommon.shell.run_main(
#                                                         command, arguments)

#        assert returncode == expected_result['returncode']

#        for message in expected_result['in_stdout']:
#            assert message in stdout

#        for message in expected_result['not_in_stdout']:
#            assert message not in stdout

#        for message in expected_result['in_stderr']:
#            assert message in stderr

    @pytest.mark.usefixtures("monkeypatch_Popen")
    def test_check_sip_digital_objects(self, testcase,
                                       filename, expected_result):

        filename = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
                                filename)
        arguments = ["%s" % filename, "abc", "def"]

        self.do(ipt.scripts.check_sip_digital_objects.main, arguments,
                expected_result)

    def do(self, command, arguments, expected):

        (returncode, stdout, stderr) = testcommon.shell.run_main(
            command, arguments)

        print >> sys.stderr, stderr

        function_name = "%s.%s" % (command.__module__, command.func_name)
        for match_string in expected["stdout"]:
            assert match_string in stdout

        for match_string in expected["stderr"]:
            assert match_string in stderr

        message = "\n".join(["got:", str(returncode), "expected:",
                             str(expected["returncode"]
                                 ), "stdout:", stdout, "stderr:",
                             stderr, "function:", function_name])
        assert returncode == expected["returncode"], message
