"""Define common settings for all tests such as:

    * Override Python sys.path:
        * src
        * tests/testcommon

    * Provide sane directory names for all tests:
        * PROJECT
        * DIRTESTSDIR
        * SOURCEDIR
        * INCLUDEDIR
        * TESTDATADIR

"""

import os
import sys

# Defined some useful directories

PROJECTDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))

SOURCEDIR = os.path.join(PROJECTDIR, 'information-package-tools')
INCLUDEDIR = os.path.join(PROJECTDIR, 'include')
SHAREDIR = os.path.join(PROJECTDIR, 'include/share')

TESTSDIR = os.path.join(PROJECTDIR, 'tests')
TESTDATADIR = os.path.join(TESTSDIR, 'data')

# Check all directories exist

for directory in [PROJECTDIR, SOURCEDIR, INCLUDEDIR, SHAREDIR,
    TESTSDIR, TESTDATADIR]:
    assert os.path.isdir(directory), "No such directory: " + directory

# Alter PYTHONPATH to include modules in correct order

sys.path.insert(0, SOURCEDIR)
sys.path.insert(0, TESTSDIR)
sys.path.insert(0, os.path.join(TESTSDIR, 'testcommon'))
