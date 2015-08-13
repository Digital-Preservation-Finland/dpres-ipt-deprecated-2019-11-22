"""
This is a test module for bagit.py
"""

import os

from preservation.workflow.bagit import make_manifest


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

    assert manifest
