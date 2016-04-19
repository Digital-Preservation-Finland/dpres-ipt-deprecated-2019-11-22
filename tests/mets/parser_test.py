#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Tests for the ipt.mets.parser module"""
import os
import sys
import lxml.etree

# Needed for testcommon.settings
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import testcommon.settings

# Module to test
from ipt.mets.parser import LXML

METSDIR = os.path.abspath(
    os.path.join(testcommon.settings.TESTDATADIR, "mets"))

NAMESPACES = {'xlink': 'http://www.w3.org/1999/xlink',
              'mets': 'http://www.loc.gov/METS/',
              'premis': 'info:lc/xmlns/premis-v2',
              'addml': 'http://www.arkivverket.no/standarder/addml',
              'xsi': 'http://www.w3.org/2001/XMLSchema-instance'}
=======
METSDIR = os.path.abspath(os.path.join(testcommon.settings.TESTDATADIR,
                                       "mets_parser_test"))
>>>>>>> origin/develop

def test_get_file_location():
    """Test the get_file_location method by getting both a URL with
    international characters and a URL without them"""
    mets_file = os.path.join(METSDIR, "mets.xml")
    lxml = LXML(filename=mets_file)
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

    mets_parser = LXML('filename')
    result = mets_parser.parse_mimetype(format_name)

    assert result['mimetype'] == 'text/xml'
    assert result['charset'] == 'UTF-8'
    assert result['alt-format'] == 'application/mets+xml'

    format_name = "application/x-internet-archive"
    result = mets_parser.parse_mimetype(format_name)

    assert result['mimetype'] == 'application/x-internet-archive'
    assert not result['charset']


def test_get_fileinfo_iterator():
    """Test the get_fileinfo_array method by METS including file with arbitrary
    native file format"""
    # Omitting the arbitrary native file in METS
    mets_file = os.path.join(METSDIR, 'mets_native_marked.xml')
    mets_parser = LXML(mets_file)
    fileinfo = [info for info in mets_parser.get_fileinfo_iterator('file-format-validation')]
    assert len(fileinfo) == 1
    assert fileinfo[0]['mimetype'] == 'application/pdf'

    # Returned all files in METS, where arbitrary file not marked as native
    mets_file = os.path.join(METSDIR, 'mets_native_unmarked.xml')
    lxml = LXML(filename=mets_file)
    fileinfo = lxml.get_fileinfo_array('file-format-validation')
    assert len(fileinfo) == 2
    assert fileinfo[0]['mimetype'] == 'application/cdr'
    assert fileinfo[1]['mimetype'] == 'application/pdf'


def test_get_fileinfo_with_admid():
    """ tests for get_fileinfo_with_admid.
    """
    mets_file = os.path.join(METSDIR, "mets_addml.xml")
    mets_parser = LXML(mets_file)
    mets_parser.xmlroot()
    results = mets_parser.get_fileinfo_with_admid('techmd-001')

    assert results == {
        'mimetype': 'text/csv;charset=UTF-8',
        'algorithm': 'MD5',
        'charset': 'UTF-8',
        'object_id': 'object-001',
        'filename': '/home/spock/scratch/information-package-tools/tests'
                    '/data/mets/./file.csv',
        'headers': [
            'Person name', 'Person email'],
        'delimiter': ';',
        'separator': 'CR+LF',
        'digest': 'aa4bddaacf5ed1ca92b30826af257a1b'}

def test_get_file_object_id_with_admid():
    mets_file = os.path.join(METSDIR, "mets_addml.xml")
    mets_parser = LXML(mets_file)
    mets_parser.xmlroot()
    admid = "techmd-001 techmd-002 event-001 agent-001"
    file_object = mets_parser.get_file_object_id_with_admid(admid)
    query = '//premis:objectIdentifier/premis:objectIdentifierValue'
    object_id = file_object.xpath(query, namespaces=NAMESPACES)[0].text
    assert object_id == 'object-001'
