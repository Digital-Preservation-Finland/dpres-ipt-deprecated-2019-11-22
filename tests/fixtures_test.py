"""Test the test fixtures"""

import os


def test_testpath(testpath):
    """Test the tests.fixtures.testpath fixture.  """
    assert os.path.isdir(testpath)
    assert os.path.isdir(testpath.some_other_directory)
    assert os.path.isdir(os.path.join(testpath, 'some_other_directory'))
