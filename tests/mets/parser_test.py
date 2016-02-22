#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Tests for the ipt.mets.parser module"""
import os
import sys

# Needed for testcommon.settings
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import testcommon.settings

# Module to test
import ipt.mets.parser

METSDIR = os.path.abspath(os.path.join(testcommon.settings.TESTDATADIR,
                                       "mets_parser_test"))


def test_get_file_location():
    """Test the get_file_location method by getting both a URL with
    international characters and a URL without them"""
    mets_file = os.path.join(METSDIR, "mets.xml")
    lxml = ipt.mets.parser.LXML(filename=mets_file)
    mets_files = lxml.mets_files()
    first_file = mets_files[0]
    second_file = mets_files[1]
    first_file_location = lxml.get_file_location(first_file)
    second_file_location = lxml.get_file_location(second_file)
    assert first_file_location == \
        "file://asettamiset/122390_OPM_päätös_20.05.2008_12-02-42.pdf", \
        "It seems there was a problem with URL unquoting a file name"
    assert second_file_location == \
        "file://asettamiset/128343_Vihanta.pdf", \
        "It seems there was a problem with URL unquoting a file name"


def test_parse_mimetype():
    format_name = \
        "text/xml; charset=UTF-8; alt-format=application/mets+xml"

    mets_parser = ipt.mets.parser.LXML('filename')
    result = mets_parser.parse_mimetype(format_name)

    assert result['mimetype'] == 'text/xml'
    assert result['charset'] == 'UTF-8'
    assert result['alt-format'] == 'application/mets+xml'

    format_name = "application/x-internet-archive"
    result = mets_parser.parse_mimetype(format_name)

    assert result['mimetype'] == 'application/x-internet-archive'
    assert not result['charset']

