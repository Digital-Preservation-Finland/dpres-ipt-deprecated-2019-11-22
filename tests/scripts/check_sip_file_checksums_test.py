"""Test the `ipt.scripts.test_sip_file_checksums` module"""

import os

import pytest

from ipt.scripts.check_sip_file_checksums import main
import tests.testcommon.shell


def create_files(base_path, filenames):
    """Create empty files and directories under given path.

    :returns: None

    """

    for path in filenames:
        if path.endswith(".file"):
            dirname = os.path.dirname(os.path.join(base_path, path))
            if not os.path.isdir(dirname):
                os.makedirs(dirname)
            open(os.path.join(base_path, path), 'w').close()
        else:
            os.makedirs(os.path.join(base_path, path))


def remove_files(path, filenames):
    """Remove listed files under given path:

    :path: Base path
    :filenames: Removed files
    :returns: None

    """
    for filename in filenames:
        os.unlink(os.path.join(path, filename))


def run_main(sip_path):
    """Run the main function with given SIP path"""
    return tests.testcommon.shell.run_main(main, [sip_path])


def test_checksum_ok(temp_sip):
    """Test valid METS with uncorrupted digital objects"""

    (returncode, stdout, stderr) = run_main(temp_sip('CSC_test006'))
    assert stderr == ''
    for line in stdout.splitlines():
        assert 'Checksum OK' in line
    assert 'Checksum OK: KDK_paatosseminaarin_ohjelma_10_12_2013' in stdout
    assert 'tmp' not in stdout
    assert returncode == 0


def test_checksum_object_types(temp_sip):
    """Test valid METS with uncorrupted digital objects"""

    (returncode, stdout, stderr) = run_main(temp_sip('CSC_test001_object_types'))
    assert stderr == ''
    for line in stdout.splitlines():
        assert 'Checksum OK' in line
    assert 'Checksum OK: kuvat/P1020137.JPG' in stdout
    assert 'tmp' not in stdout
    assert returncode == 0


def test_checksum_corrupted(temp_sip):
    """Test valid METS with corrupted digital objects"""

    sip_path = temp_sip('CSC_test006')
    corrupted_file = os.path.join(
        sip_path, 'KDK_paatosseminaarin_ohjelma_10_12_2013.pdf')
    with open(corrupted_file, 'w') as outfile:
        outfile.write('a')
    (returncode, stdout, stderr) = run_main(sip_path)
    assert stderr == ''
    assert 'Invalid Checksum: KDK_paatosseminaarin_ohjelma_10_12_201' in stdout
    assert 'tmp' not in stdout
    assert returncode == 117


def test_checksum_missing_file(temp_sip):
    """Test valid METS with missing digital objects"""

    sip_path = temp_sip('CSC_test006')

    remove_files(sip_path, ['KDK_paatosseminaarin_ohjelma_10_12_2013.pdf'])

    (returncode, stdout, stderr) = run_main(sip_path)
    assert stderr == ''
    assert 'File does not exist: KDK_paatosseminaarin_ohjelma_10_12_' in stdout
    assert 'tmp' not in stdout
    assert returncode == 117


def test_checksum_missing_algorithm(temp_sip):
    """Test valid METS with missing digital objects"""

    sip_path = temp_sip('CSC_test_missing_admid')

    (returncode, stdout, stderr) = run_main(sip_path)
    assert stderr == ''
    assert 'Could not find checksum algorithm: kuvat/PICT0102.JPG' in stdout
    assert 'tmp' not in stdout
    assert returncode == 117


def test_checksum_extra_file(temp_sip):
    """Test valid METS with extra digital objects"""

    sip_path = temp_sip('CSC_test006')

    create_files(sip_path, [
        'file_not_in_mets.file',
        'another dir/another extra.file'])

    (returncode, stdout, stderr) = run_main(sip_path)

    assert stderr == ''
    assert 'Nonlisted file: file_not_in_mets.file' in stdout
    assert 'Nonlisted file: another dir' in stdout
    assert 'tmp' not in stdout
    assert returncode == 117
