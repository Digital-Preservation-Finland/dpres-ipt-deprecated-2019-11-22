"""Common fixtures for all tests"""

import logging
import tempfile
import subprocess
import shutil
import os
import re
from hashlib import md5

import pytest
from tests.testcommon.settings import TESTDATADIR

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


@pytest.fixture()
def monkeypatch_Popen(monkeypatch, request):
    import subprocess
    _Popen = subprocess.Popen

    class PopenMockup():
        """ This is a mockup for subprocess.Popen class which reads outputs
        from file instead executing the actual command.
        """

        cmd = None
        stdout_path = None
        stderr_path = None
        exitcode_path = None

        def __init__(self, cmd, **kwargs):
            self.cmd = cmd
            self.kwargs = kwargs

            self.stdout_path = os.path.join(
                TESTDATADIR, 'popen',
                self._sanitize_cmdfile(self.cmd, appendix='.stdout'))

            self.stderr_path = os.path.join(
                TESTDATADIR, 'popen',
                self._sanitize_cmdfile(self.cmd, appendix='.stderr'))

            self.exitcode_path = os.path.join(
                TESTDATADIR, 'popen',
                self._sanitize_cmdfile(self.cmd, appendix='.exitcode'))

        def communicate(self):

            if os.path.isfile(self.stdout_path):
                LOGGER.debug("PopenMockup.communicate(): read monkeypatched "
                             "communicate() outputs from file: %s" %
                             self.stdout_path)

                return (open(self.stdout_path).read(),
                        open(self.stderr_path).read())

            process = _Popen(self.cmd, **self.kwargs)
            (stdout, stderr) = process.communicate()

            with open(self.stdout_path, 'w') as fd:
                fd.write(stdout or '')

            with open(self.stderr_path, 'w') as fd:
                fd.write(stderr or '')

            with open(self.exitcode_path, 'w') as fd:
                fd.write(str(process.returncode))

            return (stdout, stderr)

        def wait(self):
            pass

        @property
        def returncode(self):
            return int(open(self.exitcode_path).read())

        @staticmethod
        def _sanitize_cmdfile(cmdfile, appendix=None):
            if type(cmdfile) is list:
                cmdfile = ' '.join(cmdfile)

            sanitized_cmd = re.sub(
                r'( |)/tmp/((.*/)|)(.*)', r'\1/TEMP_PATH/\4', cmdfile)

            LOGGER.debug('cmd: %s', sanitized_cmd)
            return md5(sanitized_cmd).hexdigest() + appendix

    if request.config.getoption('--monkeypatch-popen'):
        monkeypatch.setattr(subprocess, 'Popen', PopenMockup)
        LOGGER.debug('Monkeypatched subprocess.Popen')

    def fin():
        monkeypatch.setattr(subprocess, 'Popen', _Popen)
        LOGGER.debug("Teardowned Popen monkeypatch")

    request.addfinalizer(fin)
