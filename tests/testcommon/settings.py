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
assert PROJECTDIR.endswith('information-package-tools')

TESTSDIR = os.path.join(PROJECTDIR, 'tests')
SOURCEDIR = os.path.join(PROJECTDIR, 'src')
INCLUDEDIR = os.path.join(PROJECTDIR, 'include')
SHAREDIR = os.path.join(PROJECTDIR, 'include/share')

sys.path.insert(0, SOURCEDIR)
sys.path.insert(0, TESTSDIR)

# Check this when having problems loading modules
print sys.path

TESTDATADIR = os.path.join(TESTSDIR, 'data')

print os.path.dirname(__file__)
print 'testdatapath = ', TESTDATADIR
