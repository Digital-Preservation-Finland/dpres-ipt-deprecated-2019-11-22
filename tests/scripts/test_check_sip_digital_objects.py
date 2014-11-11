import os
import sys
import re
import pytest

import testcommon.shell
import testcommon.settings
from testcommon.casegenerator import pytest_generate_tests

# Module to test
import ipt.scripts.check_sip_digital_objects

class TestCommandLineTools:

    testcases = {
        "test_check_sip_digital_objects":
        [{
            "testcase": 'Test valid sip package #1',
            "filename": 'CSC_test001',
            "expected_result": {
                "returncode": 0,
                "stdout": '',
                "stderr": ''
            }
         }, {
            "testcase": 'Test valid sip package #2',
            "filename": 'CSC_test002',
            "expected_result": {
                "returncode": 0,
                "stdout": '',
                "stderr": ''
            }
         }, {
            "testcase": 'Test sip with whitespace sip package #3',
            "filename": 'CSC whitespace',
            "expected_result": {
                "returncode": 0,
                "stdout": '',
                "stderr": ''
            }
         },
         {
            "testcase": 'Test valid sip package with non-existing validator (ALTO)',
            "filename": 'CSC_test004',
            "expected_result": {
                "returncode": 1,
                "stdout": ['Well-Formed and valid',
                           'No validator for mimetype:text/xml version:ALTO ' +
                           'schema Version 1.4'],
                "stderr": ''
            }
         }, {
         "testcase": 'Test valid sip package #6: csc-test-valid-kdkmets-1.3',
         "filename": 'CSC_test006',
         "expected_result": {
                "returncode": 0,
                "stdout": '',
                "stderr": ''
            }
         }]
    }


    def test_check_sip_digital_objects(self, testcase,
                                       filename, expected_result):

        filename = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
                                filename, 'mets.xml')

        configfile =  os.path.abspath(os.path.join(testcommon.settings.PROJECTDIR,
                                                   'include/share',
                                                   'validators',
                                                   'validators.json'))

        arguments = ["%s" % filename, "-c%s" % configfile, "xyz", "abc"]
        
        self.do(ipt.scripts.check_sip_digital_objects.main, arguments,
                expected_result)

    def do(self, command, arguments, expected):
          
        (returncode, stdout, stderr) = testcommon.shell.run_main(
                command, arguments)

        print stdout
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
