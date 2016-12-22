"""Test the ipt.scripts.check_digital_objects module"""

import os
import uuid

import pytest

from tests import testcommon
from tests.testcommon import shell

# Module to test
from ipt.scripts.check_sip_digital_objects import main, validation
from ipt.mets.parser import LXML
import ipt.validator.jhove
from ipt.validator import BaseValidator


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


def run_validation(monkeypatch, mets_filename):
    """Patch jhove pdf validator"""

    class JHoveMock(BaseValidator):
        """mock"""
        _supported_mimetypes = {
            'application/pdf': ['1.3', '1.4', '1.5', '1.6', 'A-1a', 'A-1b']
        }

        def validate(self):
            """mock validate"""
            self.messages("OK")

    monkeypatch.setattr(ipt.validator.jhove, "JHovePDF", JHoveMock)

    mets_file = os.path.join(METSDIR, mets_filename)
    mets_parser = LXML(filename=mets_file)
    mets_parser.xmlroot()
    return [file_ for file_ in validation(mets_parser)]


def test_non_native_marked(monkeypatch):
    """Test validation with non-native file format that has been marked with
    'no-file-format-validation'. This should validate only native file
    format"""

    results = run_validation(monkeypatch, 'mets_native_marked.xml')

    assert results == [
        {"fileinfo": {
            'object_id': {
                'type': 'local',
                'value': 'object-002'},
            'format': {
                'mimetype': 'application/pdf',
                'version': 'A-1b'},
            'algorithm': 'MD5',
            'digest': '7fc2103950f2bb374c277ed4eb43bdc6',
            'use': '',
            'filename': os.path.join(METSDIR, 'file.pdf')},
         "result": {
             "is_valid": True,
             "messages": "OK",
             "errors": ""}}]


def test_non_native_unmarked(monkeypatch):
    """Test non-native file format that has not meen marked with
    `no-file-format-validation`. This should be invalid SIP"""

    results = run_validation(monkeypatch, 'mets_native_unmarked.xml')

    assert results == [
        {"fileinfo": {
            'object_id': {
                'type': 'local',
                'value': 'object-001'},
            'format': {
                'mimetype': 'application/cdr',
                'version': ''
            },
            'algorithm': 'MD5',
            'digest': '2a2e5816c93ee7c21ae1c84ddcf8c80a',
            'filename': os.path.join(METSDIR, 'file.cdr'),
            'use': ''},
         "result": {
             "is_valid": False,
             "messages": "",
             "errors": 'No validator for mimetype: application/cdr version: '
             }},
        {"fileinfo": {
            'object_id': {
                'type': 'local',
                'value': 'object-002'},
            'format': {
                'mimetype': 'application/pdf',
                'version': 'A-1b'},
            'algorithm': 'MD5',
            'digest': '7fc2103950f2bb374c277ed4eb43bdc6',
            'filename': os.path.join(METSDIR, 'file.pdf'),
            'use': '',
        }, "result": {
            "is_valid": True,
            "messages": "OK",
            "errors": ""}
        }]
