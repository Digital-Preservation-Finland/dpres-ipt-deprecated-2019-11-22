from hashlib import md5
import os
import os.path

try:
    from StringIO import StringIO
except ImportError:  # Python 3
    from io import StringIO

import pytest

import createAIPID


HASHED_STRING = 'foo'
VALID_MD5HASH = 'acbd18db4cc2f85cedef654fccc4a4d8'
VALID_SHA1HASH = '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'
SIPDIR = os.path.abspath(os.path.dirname(__file__) + '/data/sips')


class TestAIPIDGeneration:
    @pytest.mark.parametrize(
        ('siptestdir', 'hash'),
        [(md5, VALID_MD5HASH), (sha1, VALID_SHA1HASH)])
    def test_valid_hash(self, tmpdir, algorithm, hash):
        f = tmpdir.join('foo')
        f.write(HASHED_STRING)
        assert verify_file(str(f), algorithm, hash) is None

    @pytest.mark.parametrize(
        ('algorithm', 'hash'),
        [(md5, 'a' * 32), (sha1, 'a' * 40)])
    def test_invalid_hash(self, tmpdir, algorithm, hash):
        f = tmpdir.join('foo')
        f.write(HASHED_STRING)
        with pytest.raises(Exception):  # XXX
            verify_file(str(f), algorithm, hash)




class TestAIPGeneration:
    @pytest.mark.parametrize(
        ('siptestdir', 'hash'),
        [(md5, VALID_MD5HASH), (sha1, VALID_SHA1HASH)])
    def test_AIP_generation_with_correct_parameters(self):
        testset = set([
            "kuvat/P1020137.JPG",
            "kuvat/PICT0081.JPG",
            "kuvat/PICT0102.JPG",
            "mets.xml",
            "varmiste.sig"])
        os.chdir(os.path.join(SIPDIR, 'CSC_test001'))
        assert set(get_files_in_tree()) == testset

    def test_filelist_with_missing(self):
        testset = set([
            "kuvat/P1020137.JPG",
            "kuvat/PICT0081.JPG",
            "kuvat/PICT0102.JPG",
            "mets.xml",
            "varmiste.sig"])
        relpath = os.path.relpath(os.path.join(SIPDIR, 'CSC_test001'))
        testset = set([os.path.relpath(os.path.join(relpath, x))
                       for x in testset])
        assert set(get_files_in_tree(relpath)) == testset


class TestFileChecker:
    # XXX verify_files should be mocked to make this a true unit test
    def test_ok_list(self):
        checksums = StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
./kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d
./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
        assert check_file_existence_and_checksums(
            checksums, os.path.join(SIPDIR, 'CSC_test001')) == [
                ('varmiste.sig', u'Nonlisted file')]

    def test_missing_files(self):
        checksums = StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
missing_file:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
./kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d
./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
        assert set(check_file_existence_and_checksums(
            checksums, os.path.join(SIPDIR, 'CSC_test001'))) == set([
                ('missing_file:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'File does not exist'),
                ('varmiste.sig', u'Nonlisted file')])

    def test_extra_files(self):
        checksums = StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
        assert set(check_file_existence_and_checksums(
            checksums, os.path.join(SIPDIR, 'CSC_test001'))) == set([
                ('kuvat/P1020137.JPG', 'Nonlisted file'),
                ('varmiste.sig', u'Nonlisted file')])

    def test_wrong_checksum(self):
        checksums = StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
./kuvat/P1020137.JPG:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
        assert set(check_file_existence_and_checksums(
            checksums, os.path.join(SIPDIR, 'CSC_test001'))) == set([
                ('./kuvat/P1020137.JPG:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', u'Checksum mismatch'),
                ('varmiste.sig', u'Nonlisted file')])

