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
