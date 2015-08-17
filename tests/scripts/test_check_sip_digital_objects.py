import os
import sys
import re
import pytest
import uuid
import subprocess

import testcommon.shell
import testcommon.settings
from testcommon.casegenerator import pytest_generate_tests

from tempfile import NamedTemporaryFile
import ipt.validator.plugin.xmllint

import ipt.scripts.check_xml_schema_features
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


    # NOTE: This code was originally taken from preservation repository
    # tests/asserts.py file and was refactored to use direct main() call
    # instead of popen().
    def premis_schema_validates(self, filename):
        """Test that the given task-report or ingestion-report validates against
        XML schema.

        :filename: Report filename
        :returns: True when report validates, else False

        """
        # Validate report againts XSD schema

        # TODO: replace these after schemas have been refactored into
        # information-package-tools

        xsd_path = '/usr/share/pas/microservice/report/' \
            'validation/premis_report.xsd'

        arguments = ['-s%s' % xsd_path, filename]

        (returncode, stdout, r) = testcommon.shell.run_main(
            ipt.scripts.check_xml_schema_features.main, arguments)

        print r
        return returncode == 0



    def test_check_sip_digital_objects(self, testcase,
                                       filename, expected_result):

        filename = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
                                filename)

        configfile = os.path.abspath(os.path.join(
            testcommon.settings.PROJECTDIR,
            'include/share/validators/validators.json'))

        arguments = ["%s" % filename, "-c%s" % configfile, "preservation-sip-id"
                     , str(uuid.uuid4())]

        (returncode, stdout, stderr) = testcommon.shell.run_main(
            ipt.scripts.check_sip_digital_objects.main, arguments)

        print stdout
        print >> sys.stderr, stderr

        for match_string in expected_result["stdout"]:
            assert match_string in stdout

        for match_string in expected_result["stderr"]:
            assert match_string in stderr

        message = "\n".join(["got:", str(returncode), "expected:",
                             str(expected_result["returncode"]
                                 ), "stdout:", stdout, "stderr:"])

        assert returncode == expected_result["returncode"], message

        premis_fd = NamedTemporaryFile(delete=False)
        try:
            premis_fd.write(stdout)
            premis_fd.close()

            assert self.premis_schema_validates(premis_fd.name)
        finally:
            os.remove(premis_fd.name)
