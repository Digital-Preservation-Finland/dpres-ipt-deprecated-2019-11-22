"""
Tests office-file validation with combination of Office-validator and
File-validator.
"""

import os
import pytest
from ipt.validator.validators import iter_validators


BASEPATH = "tests/data/02_filevalidation_data/office"


# Test valid file
@pytest.mark.parametrize(
    ['filename', 'mimetype', 'version'],
    [
        ("ODF_Text_Document.odt", "application/vnd.oasis.opendocument.text",
         "1.2"),
    ]
)
def test_validate_valid_file(filename, mimetype, version):
    metadata_info = {
        'filename': os.path.join(BASEPATH, filename),
        'format': {
            'mimetype': mimetype,
            'version': version
        }
    }

    for validator in iter_validators(metadata_info):
        assert validator.result()['is_valid']


# Test invalid files
@pytest.mark.parametrize(
    ['filename', 'mimetype', 'version'],
    [
        # Corrupted file - caught by Office validator
        ("ODF_Text_Document_corrupted.odt",
         "application/vnd.oasis.opendocument.text", "1.2"),
        # Wrong MIME - caught by File validator
        ("ODF_Text_Document.odt", "application/msword", "11.0"),
        # Unsupported version number - validator not found
        ("MS_Word_97-2003.doc", "application/msword", "15.0"),
    ]
)
def test_validate_invalid_file(filename, mimetype, version):
    metadata_info = {
        'filename': os.path.join(BASEPATH, filename),
        'format': {
            'mimetype': mimetype,
            'version': version
        }
    }

    validator_results = []
    for validator in iter_validators(metadata_info):
        validator_results.append(validator.result()['is_valid'])

    assert not all(validator_results)
    assert len(validator_results) > 0
