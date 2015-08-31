"""
This is a test module for bagit.py
"""

import os

import pytest

from ipt.aiptools import bagit_new
from ipt.aiptools.bagit_new import make_manifest, calculate_md5, \
    write_manifest, write_bagit_txt, BagitError, check_directory_is_bagit,\
    check_bagit_mandatory_files


def test_make_manifest(testpath):
    """
    Test manifest file creation. this function only creates the text
    on the lines and returns them as a list. file operations are created
    elsewhere.
    """
    test_sip_path = os.path.join(
        testpath, 'sip-61ad056e-41aa-11e5-9113-0800275056a0')
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


def test_write_manifest(testpath):
    """Test for writing manifest file"""
    sip_dir = os.path.join(testpath, 'sip')
    os.makedirs(sip_dir)
    manifest = [
        ['ab123', os.path.join(sip_dir, 'file.txt')],
        ['ab232', os.path.join(sip_dir, 'file2.txt')]]
    write_manifest(manifest, sip_dir)
    with open(os.path.join(sip_dir, 'manifest-md5.txt'), 'r') as infile:
        lines = infile.readlines()
        assert lines[0] == 'ab123 ' + os.path.join(sip_dir, 'file.txt') + '\n'
        assert lines[1] == 'ab232 ' + os.path.join(sip_dir, 'file2.txt') + '\n'


def test_write_bagit_txt(testpath):
    """Test for writing bagit.txt"""
    write_bagit_txt(testpath)
    with open(os.path.join(testpath, 'bagit.txt'), 'r') as infile:
        lines = infile.readlines()
        assert lines[0] == 'BagIt-Version: 0.97\n'
        assert lines[1] == 'Tag-File-Character-Encoding: UTF-8\n'


def create_test_bagit(bagit_path):
    """Create test bagit."""
    sip_path = os.path.join(bagit_path, 'data', 'transfers', 'sippi')

    os.makedirs(sip_path)

    mets_path = os.path.join(sip_path, 'mets.xml')
    with open(mets_path, 'w') as mets:
        mets.write('asfasdfasdfsda')

    image_path = os.path.join(sip_path, 'kuvat')
    os.makedirs(image_path)

    file_1_path = os.path.join(sip_path, 'file_1.txt')
    file_2_path = os.path.join(image_path, 'image1.jpg')
    with open(file_1_path, 'w') as infile:
        infile.write('abcd')
    with open(file_2_path, 'w') as infile:
        infile.write('abcdef')

    with open(os.path.join(bagit_path, 'manifest-md5.txt'), 'w') as outfile:
        outfile.write('e2fc714c4727ee9395f324cd2e7f331f ' + os.path.join(
            'data', 'file.txt') + '\n')
        outfile.write('e80b5017098950fc58aad83c8c14978e ' + os.path.join(
            'data', 'kuvat', 'file2.txt') + '\n')
    with open(os.path.join(bagit_path, 'bagit.txt'), 'w') as outfile:
        outfile.write('foo\n')


def test_bagit_structure(testpath):
    """Test bagit structure."""
    bagit_path = os.path.join(testpath, 'sippi-uuid')
    create_test_bagit(bagit_path)
    ret = check_directory_is_bagit(bagit_path)
    assert ret == 0
    ret = check_bagit_mandatory_files(bagit_path)
    assert ret == 0
    assert os.path.isdir(os.path.join(bagit_path, 'data'))

    # Test mandatory bagit files missing errors
    os.remove(os.path.join(bagit_path, 'manifest-md5.txt'))
    with pytest.raises(BagitError):
        check_bagit_mandatory_files(bagit_path),

    os.remove(os.path.join(bagit_path, 'bagit.txt'))
    with pytest.raises(BagitError):
        check_bagit_mandatory_files(bagit_path)
