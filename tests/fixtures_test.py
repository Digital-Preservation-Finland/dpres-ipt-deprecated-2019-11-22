"""Test the test fixtures"""

import os


def test_testpath(testpath):
    """TODO: Docstring for test_directory.

    :testpath: TODO
    :returns: TODO

    """
    assert os.path.isdir(testpath)
    assert os.path.isdir(testpath.some_other_directory)
    assert os.path.isdir(os.path.join(testpath, 'some_other_directory'))
