# Common test imports / boilerplate
import os
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../..'))

import pytest
import testcommon.settings
from testcommon.casegenerator import pytest_generate_tests

import random
import lxml.etree

from ipt.premis import premis
from ipt.validator.xmllint import Xmllint
from tests.testcommon.settings import PROJECTDIR


TESTDATADIR = os.path.join(PROJECTDIR, 'tests', 'data', 'premis')
PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
NAMESPACES = {'p': PREMIS_NS}
PREMIS_VERSION = "2.2"

class TestPremisClass:

    testcases = {
        "test_to_dict": [{
            "testcase": "premis etree to dict"
        }],
        "test_parse_mimetype": [{
            "testcase": "parse formatname"
        }],
        "test_premis_insert":
        [{
            "testcase": 'Test premis class insert method',
        }],
        "test_premis_xsd_validation":
        [{
            "testcase": 'Test XSD validation of Premis report',
        }],
        "test_init_event_class":
        [{
            "testcase": 'Test generation for successful validation',
            "arguments": {
                "is_valid": True,
                "messages": "stdout message",
                "errors": "stderr message"
            },
            "expected_result": {
                "number_of_events": 1,
                "eventtype": "object validation",
                "outcome": "success",
                "outcome_details": "stdout messagestderr message",
                "datetime": 1
            }
        },
            {
            "testcase": 'Test event generation for unsuccessful validation',
            "arguments": {
                "is_valid": False,
                "messages": "stdout message",
                "errors": "stderr message"
            },
            "expected_result": {
                "number_of_events": 1,
                "eventtype": "object validation",
                "outcome": "failure",
                "outcome_details": "stdout messagestderr message",
                "datetime": 1
            }
        }]
    }

    def test_premis_xsd_validation(self, monkeypatch, testcase):

        catalog_path = ('/etc/xml/information-package-tools/'
                        'kdk-mets-catalog/catalog-local.xml')
        monkeypatch.setenv("SGML_CATALOG_FILES", catalog_path)
        premis_document = premis.Premis()
        object = premis.Object()
        object.fromvalidator()

        event = premis.Event()
        result = {
            "is_valid": True,
            "messages": "",
            "errors": "",
        }
        event.fromvalidator(result, linkingObject=object)

        premis_document.insert(object)
        premis_document.insert(event)

        with tempfile.NamedTemporaryFile() as temp:
            temp.write(premis_document.serialize())
            temp.flush()

            fileinfo = {
                "filename": temp.name,
                "format": {
                    "mimetype": "text/xml",
                    "version": "1.0"
                }
            }
            validator = Xmllint(fileinfo)

            validator.validate()

            assert validator.is_valid

        print premis_document.serialize()

    def test_premis_insert(self, testcase):

        fileinfo = {}
        object = premis.Object()
        object.fromvalidator(fileinfo=fileinfo)
        event = premis.Event()
        result = {
            "is_valid": True,
            "messages": "",
            "errors": "",
        }
        event.fromvalidator(result, linkingObject=object)

        agent = premis.Agent()
        agent.fromvalidator()

        prem = premis.Premis()
        prem.insert(object)
        prem.insert(agent)

        assert abs(len(prem.events) - 0) < 0.1

        for number_of_events in range(1, 11):
            prem.insert(event)
            assert abs(len(prem.events) - number_of_events) < 0.1

        prem2 = premis.Premis()
        prem2.fromstring(prem.serialize())
        print prem2.serialize()

    def test_init_event_class(self, testcase, arguments,
                              expected_result):

        fileinfo = {}
        object = premis.Object()
        object.fromvalidator(fileinfo=fileinfo)

        event = premis.Event()
        event.fromvalidator(result=arguments,
                            linkingObject=object)

        premis_el = event.root

        # Is root element?
        assert premis_el is premis_el[0].getparent()

        queries = {}
        # Is there a premis:event element
        queries["number_of_events"] = \
            'count(/p:event)'

        # Does p:eventtype match
        queries["eventtype"] = \
            '/p:event/p:eventType/text()'

        # Does p:eventOutcome match
        queries["outcome"] = \
            '/p:event/p:eventOutcomeInformation/p:eventOutcome/text()'

        # Does p:eventOutcomeDetailNote match
        queries["outcome_details"] = \
            '/p:event/p:eventOutcomeInformation' + \
            '/p:eventOutcomeDetail/p:eventOutcomeDetailNote/text()'

        # Is there a premis:dateTime element
        queries["datetime"] = \
            'count(/p:event/p:eventDateTime)'

        # For validating p:eventDateTime take a look at
        # http://digital2.library.unt.edu/edtf/

        for query in queries:
            result = premis_el.xpath(queries[query], namespaces=NAMESPACES)

            if type(result) is list:
                assert result[0] in expected_result[query]
            elif type(result) is str:
                assert result[0] in expected_result[query]
            elif type(result) is float:
                assert abs(result - expected_result[query]) < 0.1
            else:
                assert result is expected_result[query]

        print event.serialize()

    def test_to_dict(self, testcase):
        """test for premis.to_dict()."""
        premis_path = os.path.join(TESTDATADIR, 'premis.xml')
        premis_tree = lxml.etree.parse(premis_path)
        expected = {
            "algorithm": "MD5",
            "digest": "aa4bddaacf5ed1ca92b30826af257a1b",
            "format": {
                "mimetype": "text/csv",
                "charset": "UTF-8",
                "version": ""},
            "object_id": {"value": "object-001", "type": "local"}
        }

        assert premis.to_dict(premis_tree) == expected

        premis_path = os.path.join(TESTDATADIR, 'premis_1_4.xml')
        premis_tree = lxml.etree.parse(premis_path)
        expected = {
            "algorithm": "MD5",
            "digest": "aa4bddaacf5ed1ca92b30826af257a1b",
            "format": {
                "mimetype": "text/csv",
                "charset": "UTF-8",
                "version": ""},
            "object_id": {"value": "object-001", "type": "local"}
        }
        assert premis.to_dict(premis_tree) == expected

        premis_path = os.path.join(TESTDATADIR, 'premis_text_plain.xml')
        premis_tree = lxml.etree.parse(premis_path)
        expected = {
            "algorithm": "MD5",
            "digest": "aa4bddaacf5ed1ca92b30826af257a1b",
            "format": {
                "mimetype": "text/plain",
                "charset": "UTF-8",
                "version": ""},
            "object_id": {"value": "object-001", "type": "local"}
        }
        assert premis.to_dict(premis_tree) == expected

    def test_parse_mimetype(self, testcase):
        format_name = \
            "text/xml; charset=UTF-8; alt-format=application/mets+xml"

        result = premis.parse_mimetype(format_name)

        assert result['format']['mimetype'] == 'text/xml'
        assert result['format']['charset'] == 'UTF-8'
        assert result['format']['alt-format'] == 'application/mets+xml'

        format_name = "application/x-internet-archive"
        result = premis.parse_mimetype(format_name)

        assert result['format']['mimetype'] == 'application/x-internet-archive'
        assert 'charset' not in result

        format_name = "application/xml, text/xml"
        result = premis.parse_mimetype(format_name)
        assert result["format"]["erroneous-mimetype"]
        assert result["format"]["mimetype"] == format_name
