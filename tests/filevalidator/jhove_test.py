# Common boilerplate
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import pytest
import testcommon.settings

# Module to test
import filevalidator.jhove

class TestJhoveFilevalidator:

    def test_validate(self):
        
        assert gotset == testset

    def test_filelist_with_tree(self):

        testset = set([
            "kuvat/P1020137.JPG",
            "kuvat/PICT0081.JPG",
            "kuvat/PICT0102.JPG",
            "mets.xml",
            "varmiste.sig"])
        relpath = os.path.relpath(os.path.join(SIPDIR, 'CSC_test001'))
        assert set(fileutils.filefinder.get_files_in_tree(relpath)) == testset
