import random
import string

import lxml.etree
from lxml.etree import Element, SubElement, tostring

PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
PREMIS_SCHEMALOCATION = "premis http://www.loc.gov/standards/premis/premis.xsd"

XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

XSI = "{%s}" %  XSI_NS

NAMESPACES = {'premis': PREMIS_NS, 'xsi': XSI_NS}
PREMIS_VERSION = "2.2"

class Agent(lxml.etree._ElementTree):

    @property
    def root(self):
        return self.getroot()

    @root.setter
    def root(self, value):
        self._setroot(value)    
    
    @property
    def identifier(self):
        return self.xpath("//premis:agentIdentifier",
                          namespaces=NAMESPACES)[0]
    
    @identifier.setter
    def identifier(self, value):
        element = SubElement(self.root, PREMIS + "agentIdentifier" )
        # Note: only whitespace is allowed in this element by Premis schema
        # element.text = value.decode("utf-8")
    
    @property
    def identifierValue(self):
        return self.xpath("//premis:agentIdentifier/premis:agentIdentifierValue/text()",
                          namespaces=NAMESPACES)[0]
    
    @identifierValue.setter
    def identifierValue(self, value):
        element = SubElement(self.identifier, PREMIS + "agentIdentifierValue" )
        element.text = value.decode("utf-8")
    
    @property
    def identifierType(self):
        return self.xpath("//premis:agentIdentifier/premis:agentIdentifierType/text()",
                          namespaces=NAMESPACES)[0]
    
    @identifierType.setter
    def identifierType(self, value):
        element = SubElement(self.identifier, PREMIS + "agentIdentifierType" )
        element.text = value.decode("utf-8")

    @property
    def name(self):
        return self.xpath("//premis:agentName/text()",
                          namespaces=NAMESPACES)[0]
    @name.setter
    def name(self, value):
        element = SubElement(self.root, PREMIS + "agentName" )
        element.text = value.decode("utf-8")

    @property
    def type(self):
        return self.xpath("//premis:agentType/text()",
                      namespaces=NAMESPACES)[0]
    @type.setter
    def type(self, value):
        element = SubElement(self.root, PREMIS + "agentType" )
        element.text = value.decode("utf-8")

    @property
    def note(self):
        return self.xpath("//premis:agentNote/text()",
                          namespaces=NAMESPACES)[0]
    @note.setter
    def note(self, value):
        if value:
            element = SubElement(self.root, PREMIS + "agentNote" )
            element.text = value.decode("utf-8")
    
    
    def __init__(self):
        self.root = Element(PREMIS + 'agent', nsmap = NAMESPACES)

    def fromvalidator(self, agentIdentifierType = "",
            agentIdentifierValue = None, 
            agentType=None, 
            agentName=None):
        
        self.identifier = ""
        self.identifierType = agentIdentifierType

        if not agentIdentifierValue:
            agentIdentifierValue = "".join([random.choice(string.ascii_letters + string.digits) for n in xrange(30)])
        self.identifierValue = agentIdentifierValue

        if agentName:
            self.name = agentName

        if agentType:
            self.type = agentType   

        return self.root