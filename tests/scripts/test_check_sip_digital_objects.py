import os
import sys
import pytest
import uuid
from tempfile import NamedTemporaryFile

from tests import testcommon
from tests.testcommon import settings
from tests.testcommon import shell
from tests.testcommon.casegenerator import pytest_generate_tests

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
            "testcase": 'Test valid sip package with non-existing '
                'validator (ALTO)',
            "filename": 'CSC_test004',
            "expected_result": {
                "returncode": 117,
                "stdout": ['No validator for mimetype: text/xml version: ALTO' +
                           ' schema Version 1.4'],
                "stderr": []
            }
        }, {
            "testcase": 'Test valid sip package #6: csc-test-valid-kdkmets-1.3',
            "filename": 'CSC_test006',
            "expected_result": {
                "returncode": 0,
                "stdout": '',
                "stderr": ''
            }
        }, {

            "testcase": 'Unsupported file version',
            "filename": 'CSC_test_unsupported_version',
            "expected_result": {
                "returncode": 117,
                "stdout": [
                    'No validator for mimetype: application/warc version: 2.0'],
                "stderr": ''
            }
        }, {

            "testcase": 'Unsupported file mimetype, without version',
            "filename": 'CSC_test_unsupported_mimetype_no_version',
            "expected_result": {
                "returncode": 117,
                "stdout": [
                    'No validator for mimetype: application/kissa version: '],
                "stderr": ''
            }
        }, {

            "testcase": 'Unsupported file mimetype',
            "filename": 'CSC_test_unsupported_mimetype',
            "expected_result": {
                "returncode": 117,
                "stdout": [
                    'No validator for mimetype: application/kissa version: 1.0'],
                "stderr": ''
            }
        }]
    }

    @pytest.mark.usefixtures("monkeypatch_Popen")
    def test_check_sip_digital_objects(self, testcase,
                                       filename, expected_result):

        filename = os.path.join(testcommon.settings.TESTDATADIR, 'test-sips',
                                filename)

        arguments = [filename, "preservation-sip-id", str(uuid.uuid4())]

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
                                 ), "stdout:", stdout, "stderr:", stderr])

        assert returncode == expected_result["returncode"], message

        premis_fd = NamedTemporaryFile(delete=False)
        try:
            premis_fd.write(stdout)
            premis_fd.close()

            # assert self.premis_schema_validates(premis_fd.name)
        finally:
            os.remove(premis_fd.name)
