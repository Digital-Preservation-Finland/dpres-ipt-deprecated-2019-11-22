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
PREMIS_VERSION = "2.2"

CATALOGPATH = os.path.join(testcommon.settings.SHAREDIR, 'schema/catalog-local.xml')


class TestPremisClass:

    # Generate random fileinfo array: seven random strings in a array
    fileinfo = ['%030x' % random.randrange(16**30) for _ in range(0, 8)]
    
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
                "eventtype": "object validation",
                "outcome": "success",
                "outcome_details": "stdout messagestderr message",
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
               "eventtype": "object validation",
               "outcome": "failure",
               "outcome_details": "stdout messagestderr message",
               "datetime": 1
             }
         }]
        }
    
    
    def test_premis_xsd_validation(self, testcase, fileinfo):

        premis_document = premis.Premis()
        object = premis.Object()
        object.fromvalidator()
        
        event = premis.Event()
        event.fromvalidator(linkingObject = object)
                             
        premis_document.insert(object)
        premis_document.insert(event)

        with tempfile.NamedTemporaryFile() as temp:
            temp.write( premis_document.serialize() )
            temp.flush()
        
            validator = Libxml('text/xml', '1.0', temp.name)
            validator.set_catalog(CATALOGPATH)
        
            (returncode, stdout, stderr) = validator.validate()
            assert "XSD validation success" in stdout
        
        print premis_document.serialize()

    def test_premis_insert(self,
                           testcase,
                           fileinfo):
        

        fileinfo = validator.filelist.FileInfo(fileinfo)
        
        object = premis.Object()
        object.fromvalidator( fileinfo = fileinfo )
        event = premis.Event()
        event.fromvalidator(linkingObject = object)


        agent = premis.Agent()
        agent.fromvalidator()

        prem = premis.Premis()
        prem.insert(object)
        prem.insert(agent)
        
        assert abs( len(prem.events) - 0 ) < 0.1
        
        for number_of_events in range(1,11):
            prem.insert(event)
            assert abs( len(prem.events) - number_of_events ) < 0.1
                
        prem2 = premis.Premis()
        prem2.fromstring(prem.serialize())
        print prem2.serialize()

        

    def test_init_event_class(self, testcase, fileinfo, arguments,
                              expected_result):

        fileinfo = validator.filelist.FileInfo(fileinfo)
        
        
        object = premis.Object()
        object.fromvalidator( fileinfo = fileinfo)
    
        event = premis.Event()
        event.fromvalidator(returnstatus = arguments["return_value"],
                            messages = arguments["stdout"],
                            errors = arguments["stderr"],
                            linkingObject = object)

        premis_el  = event.root

        #assert event.ttype != None
        #assert event.linking_object_identifier != None
        #assert event.identifier != None

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
            result = premis_el.xpath( queries[query], namespaces=NAMESPACES)
            
            if type(result) is list:
                assert result[0] in expected_result[query]
            elif type(result) is str:
                assert result[0] in expected_result[query]
            elif type(result) is float:
                assert abs(result-expected_result[query]) < 0.1
            else:
                assert result is expected_result[query]

        print event.serialize()