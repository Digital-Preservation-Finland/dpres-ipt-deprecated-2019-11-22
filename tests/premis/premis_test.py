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

from premis import premis
import validator.filelist
from validator.plugin.libxml import Libxml

PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
NAMESPACES = {'p': PREMIS_NS }
PREMIS_VERSION = "2.0"

class TestPremisClass:

    # Generate random fileinfo array: seven random strings in a array
    fileinfo = ['%030x' % random.randrange(16**30) for _ in range(0, 7)]
    
    testcases = {
        "test_premis_insert":
        [{
          "testcase": 'Test premis class insert method',
          "fileinfo": fileinfo
        }],
        "test_premis_xsd_validation":
        [{
            "testcase": 'Test XSD validation of Premis report',
            "fileinfo": fileinfo
        }],
        "test_init_event_class":
        [{
            "testcase": 'Test generation for successful validation',
            "fileinfo": fileinfo,
            "arguments": {
                "return_value": 0,
                "stdout": "stdout message",
                "stderr": "stderr message"
            },
            "expected_result": {
                "number_of_events": 1,
                "eventIdentifierValue": "pas-validation-" + fileinfo[6],
                "linkingObjectidenfierValue": fileinfo[6],
                "eventtype": "validation",
                "outcome": "Passed",
                "outcome_details": "stdout message stderr message",
                "datetime": 1
            }
         },
         {
             "testcase": 'Test event generation for unsuccessful validation',
             "fileinfo": fileinfo,
             "arguments": {
               "return_value": 1,
               "stdout": "stdout message",
               "stderr": "stderr message"
             },
             "expected_result": {
               "number_of_events": 1,
               "eventIdentifierValue": "pas-validation-" + fileinfo[6],
               "linkingObjectidenfierValue": fileinfo[6],
               "eventtype": "validation",
               "outcome": "Failed",
               "outcome_details": "stdout message stderr message",
               "datetime": 1
             }
         }]
        }
    
    
    def test_premis_xsd_validation(self, testcase, fileinfo):

        premis_document = premis.Premis()
        object = premis.Object()
        event = premis.Event("validation",
                             0,
                             "stdout message",
                             "stderr message",
                             object)
                             
        premis_document.insert(object)
        premis_document.insert(event)

        with tempfile.NamedTemporaryFile() as temp:
            temp.write( premis_document.serialize() )
            temp.flush()
        
            validator = Libxml('text/xml', '1.0', temp.name)
        
            (returncode, stdout, stderr) = validator.validate()
            assert "XSD validation success" in stdout
        
        #print premis_document.serialize()

    def test_premis_insert(self,
                           testcase,
                           fileinfo):
        

        fileinfo = validator.filelist.FileInfo(fileinfo)
        
        object = premis.Object( identifierValue = fileinfo.object_id )
        event = premis.Event("validation",
                             0, "", "", object)

        prem = premis.Premis()
        
        assert abs( len(prem.events) - 0 ) < 0.1
        
        for number_of_events in range(1,11):
            prem.insert(event)
            assert abs( len(prem.events) - number_of_events ) < 0.1


    def test_init_event_class(self,
                                         testcase,
                                         fileinfo,
                                         arguments,
                                         expected_result):

        fileinfo = validator.filelist.FileInfo(fileinfo)
        
        
        object = premis.Object( identifierValue = fileinfo.object_id )
        event = premis.Event("validation",
                             arguments["return_value"],
                             arguments["stdout"],
                             arguments["stderr"],
                             object)

        premis_el  = event.get_element()

        assert event.ttype != None
        assert event.linking_object_identifier != None
        assert event.identifier != None

        # Is root element?
        assert premis_el is premis_el[0].getparent()

        queries = {}
        # Is there a premis:event element
        queries["number_of_events"] = \
            'count(/p:event)'

        # Is there a p:eventIdentifierValue
        queries["eventIdentifierValue"] = \
            '/p:event/p:eventIdentifier/p:eventIdentifierValue/text()'

        # Is there a p:eventIdentifierValue
        queries["eventIdentifierValue"] = \
            '/p:event/p:eventIdentifier/p:eventIdentifierValue/text()'

        # Is thera a p:linkingObjectIdentifierValue
        queries["linkingObjectidenfierValue"] = \
            '/p:event/p:linkingObjectIdentifier' + \
            '/p:linkingObjectIdentifierValue/text()'

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
        
        # For validating p:eventDateTime take a look
        # http://digital2.library.unt.edu/edtf/


        for query in queries:
            result = premis_el.xpath( queries[query]  , namespaces=NAMESPACES)
            
            if type(result) is list:
                assert result[0] in expected_result[query]
            elif type(result) is str:
                assert result[0] in expected_result[query]
            elif type(result) is float:
                assert abs(result-expected_result[query]) < 0.1
            else:
                assert result is expected_result[query]

        print event.serialize()