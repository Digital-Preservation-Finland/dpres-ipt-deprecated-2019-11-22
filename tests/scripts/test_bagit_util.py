"""tests for bagit_util-commandline interface."""

import os

import ipt.aiptools.bagit_new
from ipt.scripts.bagit_util import main


def create_test_sip(sip_path):
    """Create test sip"""
    os.makedirs(sip_path)
    mets_path = os.path.join(sip_path, 'mets.xml')
    with open(mets_path, 'w') as mets:
        mets.write('asfasdfasdfsda')


def test_main(testpath, monkeypatch):
    """test cases for main funtions commandline interface."""

    # OK case
    bagit_path = os.path.join(testpath, 'sippi-uuid')
    create_test_bagit(bagit_path)
    assert main(['prog', 'make_bag', bagit_path]) == 0

    # data directory missing
    no_bagit_dir = os.path.join(testpath, 'foo')
    os.makedirs(no_bagit_dir)
    with pytest.raises(BagitError):
        main(['prog', 'make_bag', no_bagit_dir])
    sip_path = os.path.join(testpath, 'sippi')
    create_test_sip(sip_path)
    assert main(['prog', 'make_bag', sip_path]) == 0
