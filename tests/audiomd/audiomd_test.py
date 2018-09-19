""" test for audiomd.py. """
import os
import lxml.etree

from ipt.audiomd.audiomd import to_dict

TESTDATADIR = os.path.join('tests', 'data', 'audiomd')


def test_to_dict():
    """test for audiomd.to_dict()."""
    audiomd_path = os.path.join(TESTDATADIR, 'audiomd.xml')
    audiomd_tree = lxml.etree.parse(audiomd_path)
    expected = {
        'audio': {
            'channels': '1',
            'bits_per_sample': '8',
            'bit_rate': '256',
            'sample_rate': '44.1'}
        }

    assert to_dict(audiomd_tree) == expected
