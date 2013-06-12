from hashlib import md5
import os
import os.path

try:
    from StringIO import StringIO
except ImportError:  # Python 3
    from io import StringIO

import pytest
import shutil

import createAIPID
import createAIP
import RenameSIPtoAIP
import compressAIP
import AIPDBFunctions


SIPBASEDIR = "/tmp/SIP/"
FALSESIPBASEDIR = "/tmp/fooSIP"
SIPDIR = "SIP1"
FALSESIPDIR = "WRONGSIP1"
AIPBASEDIR = "/tmp/AIP/"
FALSEAIPBASEDIR = "/tmp/fooAIP"
ORG = "TestOrganization"
TARGETZIPDIR = "/tmp/"
FALSETARGETZIPDIR = "/tmp/foozipdir"

class SetupTestEnvironment:
    
    def clean_and_copy_files(self):
        shutil.rmtree(SIPBASEDIR)
        os.makedirs(SIPBASEDIR)
        os.makedirs(AIPBASEDIR)
        os.chdir(SIPBASEDIR)
        os.makedirs(SIPDIR)
        shutil.copytree("/tmp/testfiles/", SIPBASEDIR+SIPDIR+"/")
        
    def clear_db(self,db_name,table_name):
        pass
    
   
        
class TestAIPIDGeneration:
   
    def test_valid_sipid(self, SIPDIR):
        f = tmpdir.join('foo')
        f.write(HASHED_STRING)
        assert verify_file(str(f), algorithm, hash) is None

    def test_invalid_sipid(self, tmpdir, algorithm, hash):
        f = tmpdir.join('foo')
        f.write(HASHED_STRING)
        with pytest.raises(Exception):  # XXX
            verify_file(str(f), algorithm, hash)


class TestAIPGeneration:
    
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
        
class TestAIPMoving:
    
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
                


class TestAIPCompression:
    # XXX verify_files should be mocked to make this a true unit test
    def test_ok_list(self):
        checksums = StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
./kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d
./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
        assert check_file_existence_and_checksums(
            checksums, os.path.join(SIPDIR, 'CSC_test001')) == [
                ('varmiste.sig', u'Nonlisted file')]



