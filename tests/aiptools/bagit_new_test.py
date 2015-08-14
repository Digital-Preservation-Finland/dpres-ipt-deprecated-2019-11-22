"""
This is a test module for bagit.py
"""

import os
import tempfile

import pytest

from ipt.aiptools import bagit_new
from ipt.aiptools.bagit_new import make_manifest, calculate_md5, main, \
    write_manifest, BagitError


def test_make_manifest():
    """
    Test manifest file creation. this function only creates the text
    on the lines and returns them as a list. file operations are created
    elsewhere.
    """
    tmpdir = tempfile.mkdtemp(prefix="tests.testpath.")
    test_sip_path = os.path.join(
        tmpdir, 'sip-61ad056e-41aa-11e5-9113-0800275056a0')
    data_path = os.path.join(test_sip_path, 'data')
    image_path = os.path.join(data_path, 'kuvat')
    os.makedirs(data_path)
    os.makedirs(image_path)
    file_1_path = os.path.join(data_path, 'file_1.txt')
    file_2_path = os.path.join(image_path, 'image1.jpg')

    with open(file_1_path, 'w') as infile:
        infile.write('abcd')
    with open(file_2_path, 'w') as infile:
        infile.write('abcdef')
    manifest = make_manifest(test_sip_path)

    assert calculate_md5(file_1_path) == 'e2fc714c4727ee9395f324cd2e7f331f'

    assert manifest == [
        ['e2fc714c4727ee9395f324cd2e7f331f', 'data/file_1.txt'],
        ['e80b5017098950fc58aad83c8c14978e', 'data/kuvat/image1.jpg']]


def test_main(monkeypatch):
    """Testing main function."""
    monkeypatch.setattr(bagit_new, 'make_manifest', lambda manifest: True)
    monkeypatch.setattr(
        bagit_new, 'write_manifest', lambda manifest, path: True)
    main(argv=['bagit.py', 'make_bag', 'foo'])

    with pytest.raises(BagitError):
        main(argv=['bagit.py', 'make_bag'])

    with pytest.raises(BagitError):
        main(argv=['bagit.py', 'foo', 'bar'])


def test_write_manifest():
    tmpdir = tempfile.mkdtemp(prefix="tests.testpath.")
    sip_dir = os.path.join(tmpdir, 'sip')
    os.makedirs(sip_dir)
    manifest = [
        ['ab123', os.path.join(sip_dir, 'file.txt')],
        ['ab1232', os.path.join(sip_dir, 'file2.txt')]]
    write_manifest(manifest, sip_dir)
    with open(os.path.join(sip_dir, 'manifest-md5.txt'), 'r') as infile:
        lines = infile.readlines()
        print "lines", lines
        assert lines[0] == 'ab123 ' + os.path.join(sip_dir, 'file.txt') + '\n'
        assert lines[1] == 'ab1232 ' + os.path.join(sip_dir, 'file2.txt') + '\n'
