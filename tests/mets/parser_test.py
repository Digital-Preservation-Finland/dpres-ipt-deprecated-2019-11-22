#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Tests for the ipt.mets.parser module"""
import os
import sys

# Needed for testcommon.settings
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import pytest
import testcommon.settings

# Module to test
import ipt.mets.parser

METSDIR = os.path.abspath(os.path.join(testcommon.settings.TESTDATADIR,
                                       "mets_parser_test"))


class TestMetsParser:
    """Tests for the ipt.mets.parser module"""

    def test_get_file_location(self):
        """Test the get_file_location method"""
        mets_file = os.path.join(METSDIR, "mets.xml")
        lxml = ipt.mets.parser.LXML(filename=mets_file)
        first_file = lxml.mets_files()[0]
        first_file_location = lxml.get_file_location(first_file)
        print first_file_location
        assert first_file_location == \
            "file://asettamiset/122390_OPM_päätös_20.05.2008_12-02-42.pdf"
