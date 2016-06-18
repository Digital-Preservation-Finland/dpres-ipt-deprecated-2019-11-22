"""Define common settings for all tests such as:

    * Override Python sys.path:
        * src
        * tests/testcommon

    * Provide sane directory names for all tests:
        * PROJECT
        * DIRTESTSDIR
        * INCLUDEDIR
        * TESTDATADIR

"""

import os

# Defined some useful directories

PROJECTDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))

INCLUDEDIR = os.path.join(PROJECTDIR, 'include')
SHAREDIR = os.path.join(PROJECTDIR, 'include/share/information-package-tools')

TESTSDIR = os.path.join(PROJECTDIR, 'tests')
TESTDATADIR = os.path.join(TESTSDIR, 'data')

# Check all directories exist

for directory in [PROJECTDIR, INCLUDEDIR, SHAREDIR,
                  TESTSDIR, TESTDATADIR]:
    assert os.path.isdir(directory), "No such directory: " + directory
