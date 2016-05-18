#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Tests for the ipt.mets.parser module"""
import os

import pytest

import lxml.etree
from tests.testcommon.settings import TESTDATADIR
from ipt.mets.parser import LXML, NAMESPACES, ns_prefix, MdWrap


def mets_parser(mets_filename):
    """Return instance of `ipt.mets.parser.LXML` initialized with given mets
    filename from testdata.

    :mets_filename: METS filename under testdata path
    :returns: Parser instance

    """
    mets_path = os.path.join(TESTDATADIR, "mets", mets_filename)
    return LXML(filename=mets_path)


def test_mdwrap():
    """Test the `MdWrap` class """
    parser = mets_parser('mets.xml')
    print parser.element_with_id('tech003')
    mdwrap = MdWrap(parser.element_with_id('tech003'))
    assert mdwrap.mdtype == 'PREMIS:OBJECT'
    assert mdwrap.xmldata.attrib[ns_prefix('xsi', 'type')] == 'premis:file'


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
