"""Configure py.test default values and functionality"""

import os
import sys

from tests.fixtures import *
import pytest

# Prefer modules from source directory rather than from site-python
sys.path.insert(0, os.path.join(os.path.abspath(os.path.dirname(__file__)),
                                '..'))


def pytest_addoption(parser):

    parser.addoption(
        "--monkeypatch-popen", action="store_true",
        help="Use monkeypatch subprocess.Popen() which reads outputs from file"
        "instead executing the actual command.", default=False)
