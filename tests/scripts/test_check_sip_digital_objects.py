import os
import sys
import pytest
import uuid
from tempfile import NamedTemporaryFile

from tests import testcommon
from tests.testcommon import settings
from tests.testcommon import shell

# Module to test
from  ipt.scripts.check_sip_digital_objects import main, validation
from ipt.mets.parser import LXML
from ipt.validator.jhove import Jhove


METSDIR = os.path.abspath(
    os.path.join(testcommon.settings.TESTDATADIR, "mets"))

TESTCASES = [{
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
    }, {
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

@pytest.mark.usefixtures("monkeypatch_Popen")
def test_check_sip_digital_objects():
    """
    Test for check_sip_digital_objects
    """
    for case in TESTCASES:
        filename = os.path.join(
            testcommon.settings.TESTDATADIR, 'test-sips', case["filename"])

        arguments = [filename, "preservation-sip-id", str(uuid.uuid4())]

        (returncode, stdout, stderr) = testcommon.shell.run_main(
            main, arguments)

        for match_string in case["expected_result"]["stdout"]:
            assert match_string in stdout

        for match_string in case["expected_result"]["stderr"]:
            assert match_string in stderr

        message = "\n".join(["got:", str(returncode), "expected:",
                         str(case["expected_result"]["returncode"]
                             ), "stdout:", stdout, "stderr:", stderr])

        assert returncode == case["expected_result"]["returncode"], message

