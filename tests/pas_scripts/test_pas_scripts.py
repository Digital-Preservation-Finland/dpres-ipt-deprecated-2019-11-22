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
import pas_scripts.restructure_sip
import pas_scripts.create_aip
import pas_scripts.sign_xml_file
import pas_scripts.check_sip_signature
import pas_scripts.check_sip_file_checksums
import pas_scripts.check_sip_digital_objects
import pas_scripts.check_mets_schema_features
import pas_scripts.check_mets_required_features
import pas_scripts.check_mets_optional_features

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
            "test_sign_xml_file":
        [{
            "testcase": "Test valid signature",
            "certificate": "valid-certificate.pem",
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
            "expected_result": {
                "returncode": 0, # sign_xml_file returns zero even in case of
                                 # error and prints errors to stdout
                "in_stdout": ["No such file or directory"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": []
            }
         }
         ],
                "test_check_sip_signature":
        [{
            "testcase": "Test valid signature",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": ["OK"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": "",
                "in_stderr": ""
            }
         }
         ],
            "test_create_aip":
        [{
            "testcase": "Test create aip",
            "expected_result": {
                "returncode": 0,
                "stdout": "",
                "stderr": ""
            }
         }],
                "test_check_sip_file_checksums":
        [{
            "testcase": "Test valid signature",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": ["Checksum OK"],
                "not_in_stdout": ["File does not exist", "Nonlisted file"],
                "stderr": ""
            }
         },
         {
            "testcase": "Test invalid signature",
            "sipname": "CSC_test005",
            "expected_result": {
                "returncode": 1,
                "in_stdout": ["File does not exist", "Nonlisted file"],
                "not_in_stdout": ["Checksum OK"],
                "stderr": ""
            }
         }
         ],
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
                "returncode": 1,
                "stdout": ["Well-Formed and valid",
                           "No validator for mimetype:text/xml version:ALTO " +
                           "schema Version 1.4"],
                "stderr": ""
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
                "test_check_mets_schema_features":
        [{
            "testcase": "Test valid mets.xml",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "\n", # There"s extra line wrap in stderr
                "in_stderr": ""
            }
         },
         {
            "testcase": "Test invalid mets.xml",
            "sipname": "CSC_test005",
            "expected_result": {
                "returncode": 3,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "",
                "in_stderr": ["fails to validate"]
            }
         }
         ],
                "test_check_mets_required_features":
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
         ],
                "test_check_mets_optional_features":
        [{
            "testcase": "Test valid mets.xml",
            "sipname": "CSC_test006",
            "expected_result": {
                "returncode": 0,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "\n", # There"s extra line wrap in stderr
                "in_stderr": ""
            }
         },
         {
            "testcase": "Test invalid mets.xml",
            "sipname": "CSC_test005",
            "expected_result": {
                "returncode": 1,
                "in_stdout": [],
                "not_in_stdout": [],
                "stderr": "",
                "in_stderr": []
            }
         }
         ]
    }


    def xtest_create_aip(self, testcase, expected_result):

        sip_dir = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips/CSC_test005')
        aip_dir = tempfile.mkdtemp() + '/aip '
        shutil.copytree(sip_dir, aip_dir)
        
        command = pas_scripts.create_aip.main
        arguments = [aip_dir]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)
                                                         
        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        sip_files = os.listdir(sip_dir)
        aip_files = os.listdir(aip_dir)
        aip_data_files = os.listdir(aip_dir + '/data')
        baggit_files = ['data', 'manifest-md5.txt', 'bag-info.txt', 'bagit.txt']

        # Test that aip contains all files from sip
        assert len(set(sip_files) - set(aip_data_files)) == 0
        
        # Test that aip contains all bagit files
        for file in baggit_files:
            assert file in baggit_files
    
        # Test that aip doesn't contain anything more
        assert len(baggit_files) == len(aip_files)

    def xtest_restructure_sip(self, testcase, expected_result):

        sip_dir = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips/CSC_test006')
        restructure_dir = tempfile.mkdtemp() + '/restructure'
        shutil.copytree(sip_dir, restructure_dir)
        
        command = pas_scripts.restructure_sip.main
        arguments = [restructure_dir, 'CSC_test006']
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)
                                                         
        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']

        restructure_files = ['metadata', 'logs', 'transfer']

        # Test that aip contains all restructure files
        for file in restructure_files:
            assert file in restructure_files

    def test_sign_xml_file(self, testcase, certificate, expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                                 'test-sips/CSC_test005/mets.xml')
        certificate_path = os.path.join(testcommon.settings.TESTDATADIR,
                                'sip-signature/' + certificate)
                                
        sip_dir = tempfile.mkdtemp()
        os.chdir(sip_dir)
        shutil.copy(mets_path, sip_dir)
        
        command = pas_scripts.sign_xml_file.main
        arguments = [certificate_path, mets_path]
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

    def test_check_sip_signature(self, testcase, sipname, expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                               'test-sips/' + sipname + '/mets.xml')



        certificate_dir = os.path.join(testcommon.settings.TESTDATADIR,
                                'sip-signature/')
        certificate_path = certificate_dir + 'valid-certificate.pem'
                                
        sip_dir = tempfile.mkdtemp()
        os.chdir(sip_dir)
        shutil.copy(mets_path, sip_dir)
        mets_path = sip_dir + '/mets.xml'
        
        command = pas_scripts.sign_xml_file.main
        arguments = [certificate_path, mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)
        print returncode, stdout, stderr                                               
        assert returncode == 0
        
        command = pas_scripts.check_sip_signature.main
        arguments = ["-c" + certificate_dir, mets_path]
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


    def xtest_check_sip_file_checksums(self, testcase, sipname, expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                               'test-sips/' + sipname + '/mets.xml')

        
        command = pas_scripts.check_sip_file_checksums.main
        arguments = [mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)

        assert returncode == expected_result['returncode']
        assert stderr == expected_result['stderr']
        
        for message in expected_result['in_stdout']:
            assert message in stdout

        for message in expected_result['not_in_stdout']:
                assert message not in stdout


    def xtest_check_mets_schema_features(self, testcase, sipname,   expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                               'test-sips/' + sipname + '/mets.xml')

        
        command = pas_scripts.check_mets_schema_features.main
        arguments = [mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)

        assert returncode == expected_result['returncode']
    
        for message in expected_result['in_stdout']:
            assert message in stdout
            
        for message in expected_result['not_in_stdout']:
            assert message not in stdout

        for message in expected_result['in_stderr']:
            assert message in stderr


    def xtest_check_mets_optional_features(self, testcase, sipname,   expected_result):

        mets_path = os.path.join(testcommon.settings.TESTDATADIR,
                               'test-sips/' + sipname + '/mets.xml')

        
        command = pas_scripts.check_mets_optional_features.main
        arguments = [mets_path]
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                                                         command, arguments)

        assert returncode == expected_result['returncode']
    
        for message in expected_result['in_stdout']:
            assert message in stdout
            
        for message in expected_result['not_in_stdout']:
            assert message not in stdout

        for message in expected_result['in_stderr']:
            assert message in stderr


    def xtest_check_sip_digital_objects(self, testcase,
                                       filename, expected_result):

        filename = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
                                filename, 'mets.xml')

        configfile =  os.path.abspath(os.path.join(testcommon.settings.PROJECTDIR,
                                                   'include/share',
                                                   'validators',
                                                   'validators.json'))

        arguments = [
                "-c%s" % configfile,
                "%s" % filename,
                "abc34ge" ]
        
        self.do(pas_scripts.check_sip_digital_objects.main, arguments,
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
            str(expected["returncode"]), "stdout:", stdout, "stderr:",
            stderr, "function:", function_name])
        assert returncode == expected["returncode"], message