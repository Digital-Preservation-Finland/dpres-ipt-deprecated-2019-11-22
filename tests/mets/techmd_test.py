import os
import lxml.etree

from tests.testcommon.settings import PROJECTDIR
from ipt.mets.techmd import get_tech_md_list_for_file, \
    _get_adm_id_for_file, _get_adm_id_attribute_string, to_dict

TESTDATADIR = os.path.join(PROJECTDIR, 'tests', 'data', 'mets', 'techmd')


def test_get_adm_id_for_file():
    """test for test_get_adm_id_for_file."""
    mets_path = os.path.join(TESTDATADIR, 'mets.xml')
    file_path = os.path.join(TESTDATADIR, 'file.csv')
    mets_tree = lxml.etree.parse(mets_path)
    assert _get_adm_id_for_file(mets_tree, file_path) == [
        'techmd-001',
        'techmd-002',
        'event-001',
        'agent-001']


def test_get_adm_id_attribute_string():
    """test for _get_adm_id_string."""
    adm_ids = [
        'techmd-001',
        'techmd-002',
        'event-001',
        'agent-001']
    assert _get_adm_id_attribute_string(adm_ids) == "[@ID='techmd-001' or " \
        "@ID='techmd-002' or @ID='event-001' or @ID='agent-001']"


def test_get_tech_md_list_for_file():
    """test for _get_tech_md_list_for_file."""
    mets_path = os.path.join(TESTDATADIR, 'mets.xml')
    file_path = os.path.join(TESTDATADIR, 'file.csv')
    result = get_tech_md_list_for_file(file_path, mets_path)
    assert result == {"addml": {
        "charset": "UTF-8",
        "separator": "CR+LF",
        "delimiter": ";",
        "headers": ["Person name", "Person email"]}
        }


def test_to_dict():
    """test for get_addml_dict()."""
    addml_path = os.path.join(TESTDATADIR, 'addml.xml')
    addml_tree = lxml.etree.parse(addml_path)
    expected = {"addml": {
        "charset": "UTF-8",
        "separator": "CR+LF",
        "delimiter": ";",
        "headers": ["Person name", "Person email"]}
        }

    assert to_dict(addml_tree) == expected
