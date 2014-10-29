import random
import string
import uuid
import lxml.etree
from lxml.etree import Element, SubElement, tostring

PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
PREMIS_SCHEMALOCATION = "premis http://www.loc.gov/standards/premis/premis.xsd"

XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

XSI = "{%s}" %  XSI_NS

NAMESPACES = {'premis': PREMIS_NS, 'xsi': XSI_NS}
PREMIS_VERSION = "2.0"

class Object(lxml.etree._ElementTree):
    
    @property
    def root(self):
        return self.getroot()
    
    @root.setter
    def root(self, value):
        self._setroot(value)
    
    @property
    def identifier(self):
        return self.xpath("//premis:objectIdentifier",
                          namespaces=NAMESPACES)[0]

    @identifier.setter
    def identifier(self, value):
        element = SubElement(self.getroot(), PREMIS + "objectIdentifier" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def originalName(self):
        return self.xpath("//premis:originalName/text()",
                          namespaces=NAMESPACES)[0]
    @originalName.setter
    def originalName(self, value):
        if value:
            element = SubElement(self.getroot(), PREMIS + "originalName" )
            element.text = value.decode("utf-8")

    @property
    def identifierValue(self):
        return self.xpath("//premis:objectIdentifier/premis:objectIdentifierValue/text()",
                          namespaces=NAMESPACES)[0]
    
    @identifierValue.setter
    def identifierValue(self, value):
        element = SubElement(self.identifier, PREMIS + "objectIdentifierValue" )
        element.text = value.decode("utf-8")

    @property
    def identifierType(self):
        return self.xpath("//premis:objectIdentifier/premis:objectIdentifierType/text()",
                          namespaces=NAMESPACES)[0]
    
    @identifierType.setter
    def identifierType(self, value):
        element = SubElement(self.identifier, PREMIS + "objectIdentifierType" )
        element.text = value.decode("utf-8")

    @property
    def environment(self):
        try: return self.xpath("//premis:environment",
                               namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @environment.setter
    def environment(self, value):
        element = SubElement(self.getroot(), PREMIS + "environment" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")
    
    @property
    def dependency(self):
        try: return self.xpath("//premis:environment/premis:dependency",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @dependency.setter
    def dependency(self, value):
        if len(self.environment) == 0:
            self.environment = ""
        
        element = SubElement(self.environment, PREMIS + "dependency" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def dependencyIdentifier(self):
        try: return self.xpath("//premis:environment/premis:dependency/premis:dependencyIdentifier",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @dependencyIdentifier.setter
    def dependencyIdentifier(self, value):
        if len(self.dependency) == 0:
            self.dependency = ""
        
        element = SubElement(self.dependency, PREMIS + "dependencyIdentifier" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def dependencyIdentifierValue(self):
        return self.xpath("//premis:environment/premis:dependency/premis:dependencyIdentifier/premis:dependencyIdentifierValue/text()",
                          namespaces=NAMESPACES)[0]

    @dependencyIdentifierValue.setter
    def dependencyIdentifierValue(self, value):
        if value:
            if len(self.dependency) == 0:
                self.dependency = ""
            
            element = SubElement(self.dependencyIdentifier, PREMIS + "dependencyIdentifierValue" )
            element.text = value.decode("utf-8")


    @property
    def dependencyIdentifierType(self):
        return self.xpath("//premis:environment/premis:dependency/premis:dependencyIdentifier/premis:dependencyIdentifierType/text()",
                          namespaces=NAMESPACES)[0]
    
    @dependencyIdentifierType.setter
    def dependencyIdentifierType(self, value):
        if value:
            if not self.dependencyIdentifier:
                self.dependencyIdentifier = ""
            element = SubElement(self.dependencyIdentifier, PREMIS + "dependencyIdentifierType" )
            element.text = value.decode("utf-8")

    @property
    def relationship(self):
        try: return self.xpath("//premis:relationship",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @relationship.setter
    def relationship(self, value):
        element = SubElement(self.getroot(), PREMIS + "relationship" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def relationshipType(self):
        return self.xpath("//premis:relationship/premis:relationshipType/text()",
                          namespaces=NAMESPACES)[0]
    
    @relationshipType.setter
    def relationshipType(self, value):
        if value:
            if not self.relationship:
                self.relationship = ""
            
            element = SubElement(self.relationship, PREMIS + "relationshipType" )
            element.text = value.decode("utf-8")


    @property
    def relationshipSubType(self):
        return self.xpath("//premis:relationship/premis:relationshipSubType/text()",
                          namespaces=NAMESPACES)[0]


    @relationshipSubType.setter
    def relationshipSubType(self, value):
        if value:
            element = SubElement(self.relationship, PREMIS + "relationshipSubType" )
            element.text = value.decode("utf-8")


    @property
    def relatedObjectIdentification(self):
        try: return self.xpath("//premis:relationship/premis:relatedObjectIdentification",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @relatedObjectIdentification.setter
    def relatedObjectIdentification(self, value):
        if len(self.relationship) == 0:
            self.relationship = ""
        
        element = SubElement(self.relationship, PREMIS + "relatedObjectIdentification" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def relatedObjectIdentifierValue(self):
        return self.xpath("//premis:relationship/premis:relatedObjectIdentification/premis:relatedObjectIdentifierValue/text()",
                          namespaces=NAMESPACES)[0]

    @relatedObjectIdentifierValue.setter
    def relatedObjectIdentifierValue(self, value):
        if value:
            if len(self.relationship) == 0:
                self.relationship = ""
            
            element = SubElement(self.relatedObjectIdentification, PREMIS + "relatedObjectIdentifierValue" )
            element.text = value.decode("utf-8")


    @property
    def relatedObjectIdentifierType(self):
        return self.xpath("//premis:relationship/premis:relatedObjectIdentification/premis:relatedObjectIdentifierType/text()",
                          namespaces=NAMESPACES)[0]
    
    @relatedObjectIdentifierType.setter
    def relatedObjectIdentifierType(self, value):
        if value:
            if not self.relatedObjectIdentification:
                self.relatedObjectIdentification = ""
            element = SubElement(self.relatedObjectIdentification, PREMIS + "relatedObjectIdentifierType" )
            element.text = value.decode("utf-8")

    @property
    def linkingIntellectualEntityIdentifier(self):
        try: return self.xpath("//premis:linkingIntellectualEntityIdentifier",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""

    @linkingIntellectualEntityIdentifier.setter
    def linkingIntellectualEntityIdentifier(self, value):
        element = SubElement(self.root, PREMIS + "linkingIntellectualEntityIdentifier" )
        # Note: only whitespace is allowed in this element by Premis schema
        #element.text = value.decode("utf-8")

    @property
    def linkingIntellectualEntityIdentifierType(self):
        try: return self.xpath("//premis:linkingIntellectualEntityIdentifier/premis:linkingIntellectualEntityIdentifierType/text()",
                          namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @linkingIntellectualEntityIdentifierType.setter
    def linkingIntellectualEntityIdentifierType(self, value):
        if value:
            if not self.linkingIntellectualEntityIdentifier:
                self.linkingIntellectualEntityIdentifier = ""
            element = SubElement(self.linkingIntellectualEntityIdentifier, PREMIS + "linkingIntellectualEntityIdentifierType" )
            element.text = value.decode("utf-8")
    
    @property
    def linkingIntellectualEntityIdentifierValue(self):
        try: return self.xpath("//premis:linkingIntellectualEntityIdentifier/premis:linkingIntellectualEntityIdentifierValue/text()",
                              namespaces=NAMESPACES)[0]
        except IndexError: return ""
    
    @linkingIntellectualEntityIdentifierValue.setter
    def linkingIntellectualEntityIdentifierValue(self, value):
        if value:
            element = SubElement(self.linkingIntellectualEntityIdentifier, PREMIS + "linkingIntellectualEntityIdentifierValue" )
            element.text = value.decode("utf-8")
    
    @property
    def type(self):
        return ""
    
    @type.setter
    def type(self, value):
        if value.startswith("premis"):
            value = value[len("premis:"):]
        self.root.set(XSI + 'type', lxml.etree.QName(PREMIS + value))

    def __init__(self):
        super(Object, self).__init__()
        
        self.root = Element(PREMIS + 'object', nsmap = NAMESPACES)

    def fromvalidator(self, type = "representation", identifierType = "pas-object-id", fileinfo = None, relatedObject = None):

        self.root.set(XSI + 'type', lxml.etree.QName(PREMIS + type))

        if fileinfo:
            self.originalName  = fileinfo.filename
        
        self.identifier = ""
        self.identifierType = identifierType
        self.identifierValue = "pas-object-" + str(uuid.uuid4())
        
        if fileinfo:
            self.dependencyIdentifierType = fileinfo.object_id['type']
            self.dependencyIdentifierValue =  fileinfo.object_id['value']
            
        if relatedObject:
            self.relationshipType =  "structural"
            self.relationshipSubType = "is included in"
            self.relatedObjectIdentifierType = relatedObject.identifierType
            self.relatedObjectIdentifierValue =  relatedObject.identifierValue
                    
        return self.getroot()