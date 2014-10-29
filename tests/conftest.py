"""Configure py.test default values and functionality"""

import os
import sys

# Prefer modules from source directory rather than from site-python
sys.path.insert(0, os.path.join(os.path.abspath(os.path.dirname(__file__)),
    '..'))

# Prefer modules from tests directory rather than from source directory
# Useful for mocking up some modules in tests
#sys.path.insert(0, os.path.join(os.path.abspath(os.path.dirname(__file__)),
#'../tests'))
