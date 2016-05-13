#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Tests for the ipt.mets.parser module"""
import os

import pytest

import lxml.etree
from tests.testcommon.settings import TESTDATADIR
from ipt.mets.parser import LXML, NAMESPACES, ns_prefix


def mets_parser(mets_filename):
    """Return instance of `ipt.mets.parser.LXML` initialized with given mets
    filename from testdata.

    :mets_filename: METS filename under testdata path
    :returns: Parser instance

    """
    mets_path = os.path.join(TESTDATADIR, "mets", mets_filename)
    return LXML(filename=mets_path)


def test_element_with_id():
    """Test the `element_with_admid` method."""
    parser = mets_parser('mets.xml')
    techmd = parser.element_with_id('tech003')
    assert techmd.attrib["ID"] == 'tech003'
    dmdsec = parser.element_with_id('dmd008')
    assert dmdsec.attrib["ID"] == 'dmd008'


def test_iter_elements_with_id():
    """Test the `element_with_admid` method."""

    parser = mets_parser('mets.xml')

    admid_string = 'dmd010  dmd009 file013'
    results = [x for x in parser.iter_elements_with_id(admid_string)]
    assert len(results) == 3

    admid_list = ['dmd010', 'dmd009', 'file013', 'tech001']
    results = [x for x in parser.iter_elements_with_id(admid_list)]
    assert len(results) == 4


def test_get_file_location():
    """Test the get_file_location method by getting both a URL with
    international characters and a URL without them"""
    parser = mets_parser("mets.xml")
    mets_files = parser.mets_files()

    first_file = mets_files[0]
    second_file = mets_files[1]
    first_file_location = parser.get_file_location(first_file)
    second_file_location = parser.get_file_location(second_file)
    assert first_file_location == \
        "asettamiset/122390_OPM_päätös_20.05.2008_12-02-42.pdf", \
        "It seems there was a problem with URL unquoting a file name"
    assert second_file_location == \
        "asettamiset/128343_Vihanta.pdf", \
        "It seems there was a problem with URL unquoting a file name"


def test_iter_fileinfo():
    """Test iter_fileinfo method by METS including file with arbitrary
    native file format"""
    # Omitting the arbitrary native file in METS
    parser = mets_parser('mets_native_marked.xml')

    fileinfo = [info for info in parser.get_fileinfo_iterator(
        'file-format-validation')]
    assert len(fileinfo) == 1
    assert fileinfo[0]['format']['mimetype'] == 'application/pdf'

    # Returned all files in METS, where arbitrary file not marked as native
    parser = mets_parser('mets_native_unmarked.xml')

    fileinfo = [info for info in parser.get_fileinfo_iterator(
        'file-format-validation')]
    assert len(fileinfo) == 2
    assert fileinfo[0]['format']['mimetype'] == 'application/cdr'
    assert fileinfo[1]['format']['mimetype'] == 'application/pdf'


def test_get_fileinfo_with_admid():
    """ tests for get_fileinfo_with_admid.
    """
    parser = mets_parser("mets_addml.xml")

    results = parser.get_fileinfo_with_admid('techmd-001')

    assert results == {
        'format': {'mimetype': 'text/csv', 'charset': 'UTF-8', 'version': ''},
        'addml': {
            'headers': [
                'Person name', 'Person email'],
            'charset': 'UTF-8',
            'delimiter': ';',
            'separator': 'CR+LF'
        },
        'algorithm': 'MD5',
        'object_id': {'value': 'object-001', 'type': 'local'},
        'filename': os.path.join(TESTDATADIR, 'mets', 'file.csv'),
        'digest': 'aa4bddaacf5ed1ca92b30826af257a1b'}


def test_get_filename_with_admid():
    """Test for get_filename_with_admid."""
    parser = mets_parser("mets_addml.xml")

    admid = "techmd-001 techmd-002 event-001 agent-001"
    filename = parser.get_filename_with_admid(admid)
    assert filename == 'file.csv'


def test_get_file_object_id_with_admid():
    parser = mets_parser("mets_addml.xml")

    admid = "techmd-001 techmd-002 event-001 agent-001"
    file_object = parser.get_file_object_id_with_admid(admid)
    query = '//premis:objectIdentifier/premis:objectIdentifierValue'
    object_id = file_object.xpath(query, namespaces=NAMESPACES)[0].text
    assert object_id == 'object-001'
