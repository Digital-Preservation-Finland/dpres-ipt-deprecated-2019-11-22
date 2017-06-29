"""Test the ipt.scripts.check_digital_objects module"""

import os
import uuid

import pytest

from tests import testcommon
from tests.testcommon import shell

# Module to test
from ipt.scripts.check_sip_digital_objects import main, validation
import ipt.validator.jhove


METSDIR = os.path.abspath(
    os.path.join(testcommon.settings.TESTDATADIR, "mets"))


TESTCASES = [
    {"testcase": 'Test valid sip package #1',
     "filename": 'CSC_test001',
     "expected_result": {
         "returncode": 0,
         "stdout": '',
         "stderr": ''}},
    {"testcase": 'Test valid sip package #2',
     "filename": 'CSC_test002',
     "expected_result": {
         "returncode": 0,
         "stdout": '',
         "stderr": ''}},
    {"testcase": 'Test sip with whitespace sip package #3',
     "filename": 'CSC whitespace',
     "expected_result": {
         "returncode": 0,
         "stdout": '',
         "stderr": ''}},
    {"testcase": 'Test valid sip package #6: csc-test-valid-kdkmets-1.3',
     "filename": 'CSC_test006',
     "expected_result": {
         "returncode": 0,
         "stdout": '',
         "stderr": ''}},
    {"testcase": 'Unsupported file version',
     "filename": 'CSC_test_unsupported_version',
     "expected_result": {
         "returncode": 117,
         "stdout": ['No validator for mimetype: '
                    'application/warc version: 2.0'],
         "stderr": ''}},
    {"testcase": 'Unsupported file mimetype, without version',
     "filename": 'CSC_test_unsupported_mimetype_no_version',
     "expected_result": {
         "returncode": 117,
         "stdout": ['No validator for mimetype: application/kissa version: '],
         "stderr": ''}},
    {"testcase": 'Unsupported file mimetype',
     "filename": 'CSC_test_unsupported_mimetype',
     "expected_result": {
         "returncode": 117,
         "stdout": ['No validator for mimetype: '
                    'application/kissa version: 1.0'],
         "stderr": ''}},
    {"testcase": 'Invalid mets, missing ADMID.',
     "filename": 'CSC_test_missing_admid',
     "expected_result": {
         "returncode": 117,
         "stdout": ['No validator for mimetype: '
                    'None version: None'],
         "stderr": ''}},
    {"testcase": 'Invalid mets, missing amdSec',
     "filename": 'CSC_test_missing_amdSec',
     "expected_result": {
         "returncode": 117,
         "stdout": ['No validator for mimetype: '
                    'None version: None'],
         "stderr": ''}},
    {"testcase": 'Invalid warc',
     "filename": 'csc-test-invalid-warc',
     "expected_result": {
         "returncode": 117,
         "stdout": ['Validation failed: returncode 255',
                    'warc errors at',
                    'File version check error'],
         "stderr": ''}},
    {"testcase": 'Invalid warc renamed to .gz',
     "filename": 'csc-test-invalid-warc-not-gz',
     "expected_result": {
         "returncode": 117,
         "stdout": ['Validation failed: returncode 255',
                    'Exception: Not a gzipped file',
                    'File version check error'],
         "stderr": ''}}]


@pytest.mark.parametrize(
    "case", TESTCASES, ids=[x['testcase'] for x in TESTCASES])
@pytest.mark.usefixtures("monkeypatch_Popen")
def test_check_sip_digital_objects(case):
    """
    Test for check_sip_digital_objects
    """
    filename = os.path.join(
        testcommon.settings.TESTDATADIR, 'test-sips', case["filename"])

    arguments = [filename, "preservation-sip-id", str(uuid.uuid4())]

    (returncode, stdout, stderr) = shell.run_main(
        main, arguments)

    assert stderr == ''

    for match_string in case["expected_result"]["stdout"]:
        assert match_string in stdout

    message = "\n".join([
        "got:", str(returncode), "expected:",
        str(case["expected_result"]["returncode"]),
        "stdout:", stdout, "stderr:", stderr])

    assert returncode == case["expected_result"]["returncode"], message


@pytest.fixture(scope="function")
def patch_validate(monkeypatch):
    """Patch JHovePDF validator so that it always returns valid result"""

    def _iter_validators(fileinfo):
        """mock validate"""

        class _Validator(object):
            """dummy validator"""
            # pylint: disable=too-few-public-methods

            def __init__(self, fileinfo):
                """init"""
                self.fileinfo = fileinfo

            def result(self):
                """check result"""
                if 'pdf' in self.fileinfo["filename"]:
                    return 'success'
                return 'failure'

        yield _Validator(fileinfo)

    def _iter_fileinfo(_):
        """mock iter_fileinfo"""
        return [
            {"filename": "pdf", "use": ''},
            {"filename": "cdr", "use": ''},
            {"filename": "cdr", "use": "no-file-format-validation"},
            {"filename": "cdr", "use": "noo-file-format-validation"}
        ]

    monkeypatch.setattr(
        ipt.scripts.check_sip_digital_objects, "iter_validators",
        _iter_validators)
    monkeypatch.setattr(
        ipt.scripts.check_sip_digital_objects, "iter_fileinfo", _iter_fileinfo)


@pytest.mark.usefixtures('patch_validate')
def test_native_marked():
    """Test validation with native file format that has been marked with
    'no-file-format-validation'. This should validate only native file
    format"""

    results = [file_ for file_ in validation(None)]

    assert results == [
        {"fileinfo": {'filename': 'pdf', 'use': ''}, "result": "success"},
        {"fileinfo": {'filename': 'cdr', 'use': ''}, "result": "failure"},
        {"fileinfo": {'filename': 'cdr', 'use': 'noo-file-format-validation'},
         "result": "failure"}
    ]
