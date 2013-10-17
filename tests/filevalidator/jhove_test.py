# Common boilerplate
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import pytest
import testcommon.settings

# Module to test
import filevalidator.jhove

class TestJhoveFilevalidator:

    def test_validate(self):
        return None
