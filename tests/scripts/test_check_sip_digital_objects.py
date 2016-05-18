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
},
    {
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
        "stdout": ['No validator for mimetype: application/warc version: 2.0'],
        "stderr": ''
    }
}, {

    "testcase": 'Unsupported file mimetype, without version',
    "filename": 'CSC_test_unsupported_mimetype_no_version',
    "expected_result": {
        "returncode": 117,
        "stdout": ['No validator for mimetype: application/kissa version: '],
        "stderr": ''
    }
}, {

    "testcase": 'Unsupported file mimetype',
    "filename": 'CSC_test_unsupported_mimetype',
    "expected_result": {
        "returncode": 117,
        "stdout": ['No validator for mimetype: application/kissa version: 1.0'],
        "stderr": ''
    }
}
]


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


def test_validation(monkeypatch):
    """Test the get_fileinfo_array method by METS including file with arbitrary
    native file format"""
    monkeypatch.setattr(Jhove, "validate", lambda fileinfo: (0, "", ""))
    # Omitting the arbitrary native file in METS
    mets_file = os.path.join(METSDIR, 'mets_native_marked.xml')
    mets_parser = LXML(mets_file)
    mets_parser.xmlroot()
    results = [result for result in validation(mets_parser)][0]
    assert results["fileinfo"] == {
        'object_id': {
            'type': 'local',
            'value': 'object-002'},
        'format': {
            'mimetype': 'application/pdf',
            'version': 'A-1b'},
        'algorithm': 'MD5',
        'digest': '7fc2103950f2bb374c277ed4eb43bdc6',
        'filename': os.path.join(METSDIR, 'file.pdf')
    }
    assert results["result"] == (0, "", "")

    # Returned all files in METS, where arbitrary file not marked as native
    mets_file = os.path.join(METSDIR, 'mets_native_unmarked.xml')
    mets_parser = LXML(filename=mets_file)
    mets_parser.xmlroot()

    expected = [
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
            'filename': os.path.join(METSDIR, 'file.cdr')},
        "result": (
            117, '', 'No validator for mimetype: application/cdr version: ')
         },
        {"fileinfo": {
            'object_id': {
                'type': 'local',
                'value': 'object-002'},
            'format': {
                'mimetype': 'application/pdf',
                'version': 'A-1b'},
            'algorithm': 'MD5',
            'digest': '7fc2103950f2bb374c277ed4eb43bdc6',
            'filename': os.path.join(METSDIR, 'file.pdf')
        },
            "result": (0, "", "")
        }
    ]
    files = [file_ for file_ in validation(mets_parser)]
    for file_iterator in range(0, 2):
        print "GOT", files[file_iterator]
        print
        print "EXPECTED", expected[file_iterator]
        print
        assert files[file_iterator] == expected[file_iterator]
