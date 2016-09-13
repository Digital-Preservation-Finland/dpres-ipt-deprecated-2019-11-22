""" test for videomd.py. """
import os
import lxml.etree

from ipt.videomd.videomd import to_dict

TESTDATADIR = os.path.join('tests', 'data', 'videomd')


def test_to_dict():
    """test for videomd.to_dict()."""
    audiomd_path = os.path.join(TESTDATADIR, 'videomd.xml')
    audiomd_tree = lxml.etree.parse(audiomd_path)
    expected = {"video": [{"codecname": "MPEG 2"}]}

    assert to_dict(audiomd_tree) == expected
