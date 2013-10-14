import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                '../../src')))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                '../../tests')))

TOOLSPATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '../'))
# Check this when having problems loading modules
print sys.path

TESTDATAPATH = os.path.join(
    os.path.abspath(os.path.join(os.path.dirname(__file__), '..')),
    'data')

print 'testdatapath = ', TESTDATAPATH
