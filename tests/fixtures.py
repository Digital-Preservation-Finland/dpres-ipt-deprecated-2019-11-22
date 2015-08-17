"""Common fixtures for all tests"""

import logging
import tempfile
import subprocess
import shutil
import os

import pytest

from utils import Directory

# Setup logging facility
LOGGER = logging.getLogger('tests.fixtures')
logging.basicConfig(level=logging.DEBUG)


@pytest.fixture(scope="function")
def testpath(request):
    """Creates temporary directory and clean up after testing.

    :request: Pytest request fixture
    :returns: Path to temporary directory

    """
    temp_path = tempfile.mkdtemp(prefix="tests.testpath.")

    LOGGER.debug(
        'testpath:%s:create temp_path:%s', request,
        temp_path)

    def fin():
        """remove temporary path"""
        LOGGER.debug(
            'testpath:%s:delete temp_path:%s', request,
            temp_path)
        subprocess.call(['find', temp_path, '-ls'])
        shutil.rmtree(temp_path)

    request.addfinalizer(fin)

    return Directory(temp_path)


@pytest.fixture(scope="function")
def zipfile(request):
    """Fixture that creates a temporary zip archive file and returns path to
    the file.

    Should create a zip file with the following files and directories::

        test-package/testfile.0
        test-package/testfile.1
        ...


    Should return the followind data structure::

        {
            "filename": '/tmp/tests.zipfile.mG56N4/test-package.zip',
            "filenames: [
                "test-package/testfile.0",
                "test-package/testfile.1",
                ...
            ]
        }

    :request: Pytest request-fixture
    :returns: Filenames for the archive and contained filenames

    """

    temp_path = tempfile.mkdtemp(prefix="tests.zipfile.")

    LOGGER.debug(
        'zipfile:%s:create temp_path:%s', request,
        temp_path)

    def fin():
        """remove temporary path"""
        LOGGER.debug(
            'zipfile:%s:delete temp_path:%s', request,
            temp_path)
        subprocess.call(['find', temp_path, '-ls'])
        shutil.rmtree(temp_path)

    request.addfinalizer(fin)

    sip_path = 'tests/workflow/data/csc_test_valid_sip'
    zip_filename = os.path.join(temp_path, 'csc_test_valid_sip.zip')

    subprocess.call([
        'zip',
        '-r', os.path.join(temp_path, zip_filename),
        os.path.basename(sip_path)], cwd=os.path.dirname(sip_path))

    filenames = ['csc_test_valid_sip/']
    for root, dirs, files in os.walk(sip_path):
        path = root.replace('tests/workflow/data/', '')
        for filename in files + dirs:
            filenames.append(os.path.join(path, filename))

    return {"filename": zip_filename, "filenames": filenames}
