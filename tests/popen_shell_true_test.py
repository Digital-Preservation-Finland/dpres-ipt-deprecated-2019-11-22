"""Test that there is no "shell=True" line in the Python code (does not test
the test files). This could be expanded for general code convention tests.

"""

import os
import sys
import re

# This code could also use some Python library for code analysis if such
# library exists.


def test_no_shell_true():
    """Search for shell=True in code and fail if found."""

    source_dir = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                              '../information-package-tools'))

    sys.path.insert(0, source_dir)

    # Compile the regular expression
    re_comp = re.compile('.*shell=True.*')

    for root, _, files in os.walk(source_dir):
        for filename in files:
            absname = os.path.join(root, filename)

            if filename.startswith('__init__'):
                continue

            if filename.endswith('.py'):
                for line in open(absname).readlines():
                    if re_comp.match(line):
                        assert False, "Found shell=True: %s" % line
