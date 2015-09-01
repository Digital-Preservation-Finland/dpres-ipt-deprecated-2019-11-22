"""tests for bagit_util-commandline interface."""

import os
import pytest

from tests.testcommon.test_utils import create_test_bagit
from ipt.aiptools.bagit_new import BagitError
from ipt.scripts.bagit_util import main


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
