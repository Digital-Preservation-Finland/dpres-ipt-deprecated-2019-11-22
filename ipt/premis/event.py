import datetime
import dateutil.tz
import uuid

import lxml.etree
from lxml.etree import Element, SubElement, tostring

PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
PREMIS_SCHEMALOCATION = "premis http://www.loc.gov/standards/premis/premis.xsd"

XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

XSI = "{%s}" % XSI_NS

NAMESPACES = {'premis': PREMIS_NS, 'xsi': XSI_NS}
PREMIS_VERSION = "2.2"


class Event(lxml.etree._ElementTree):

    """
        The purpose of this class is to construct Premis XML events. The event
        can either be serialized direcly by this class or passed to the Premis
        class which can encapsulate multiple events and serialize them all at
        once.

        This class serializes the following XML output

        .. code-block:: xml

            <premis:event>
                <premis:eventIdentifier>
                    <premis:eventIdentifierType>local
                    </premis:eventIdentifierType>
                    <premis:eventIdentifierValue>
                        pas-validation-6abebf94-94f5-417c-9b60-05c16b985fdd
                </premis:eventIdentifierValue>
                </premis:eventIdentifier>
                <premis:linkingObjectIdentifier>
                    <premis:linkingObjectIdentifierValue>
                        6abebf94-94f5-417c-9b60-05c16b985fdd
                    </premis:linkingObjectIdentifierValue>
                </premis:linkingObjectIdentifier>

                <premis:eventType>validation</premis:eventType>
                <premis:eventDateTime>2013-11-19T17:58:04
                </premis:eventDateTime>
                <premis:eventDetail></premis:eventDetail>
                <premis:eventOutcomeInformation>
                    <premis:eventOutcome>
                        Passed
                    </premis:eventOutcome>
                    <premis:eventOutcomeDetail>
                        <premis:eventOutcomeDetailNote>
                            e.g. Validator output
                        </premis:eventOutcomeDetailNote>
                    </premis:eventOutcomeDetail>
                </premis:eventOutcomeInformation>
            </premis:event>
    """

    @property
    def root(self):
        return self.getroot()

    @root.setter
    def root(self, value):
        self._setroot(value)

    @property
    def eventIdentifier(self):
        try:
            return self.xpath("//premis:eventIdentifier",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            self.eventIdentifier = ""
            return self.xpath("//premis:eventIdentifier",
                              namespaces=NAMESPACES)[0]

    @eventIdentifier.setter
    def eventIdentifier(self, value):
        element = SubElement(self.getroot(), PREMIS + "eventIdentifier")
        # Note: only whitespace is allowed in this element by Premis schema
        # element.text = value.decode("utf-8")

    @property
    def eventIdentifierValue(self):
        try:
            return self.xpath(
                "//premis:eventIdentifier/premis:eventIdentifierValue/text()",
            namespaces=NAMESPACES)[0].encode("utf-8")
        except IndexError:
            return ""

    @eventIdentifierValue.setter
    def eventIdentifierValue(self, value):
        element = SubElement(
            self.eventIdentifier, PREMIS + "eventIdentifierValue")
        element.text = value.decode("utf-8")

    @property
    def eventIdentifierType(self):
        return self.xpath(
            "//premis:eventIdentifier/premis:eventIdentifierType/text()",
                          namespaces=NAMESPACES)[0].encode("utf-8")

    @eventIdentifierType.setter
    def eventIdentifierType(self, value):
        if value:
            element = SubElement(
                self.eventIdentifier, PREMIS + "eventIdentifierType")
            element.text = value.decode("utf-8")

    @property
    def eventType(self):
        try:
            return self.xpath("//premis:eventType/text()",
                              namespaces=NAMESPACES)[0].encode("utf-8")
        except IndexError:
            return ""

    @eventType.setter
    def eventType(self, value):
        element = SubElement(self.getroot(), PREMIS + "eventType")
        element.text = value.decode("utf-8")

    @property
    def eventDateTime(self):
        return self.xpath("//premis:eventDateTime",
                          namespaces=NAMESPACES)[0]

    @eventDateTime.setter
    def eventDateTime(self, value):
        element = SubElement(self.getroot(), PREMIS + "eventDateTime")
        element.text = value.decode("utf-8")

    @property
    def eventDetail(self):
        try:
            return self.xpath("//premis:eventDetail/text()",
                              namespaces=NAMESPACES)[0].encode("utf-8")
        except IndexError:
            return ""

    @eventDetail.setter
    def eventDetail(self, value):
        if value:
            element = SubElement(self.getroot(), PREMIS + "eventDetail")
            element.text = value.decode("utf-8")

    @property
    def eventOutcomeInformation(self):
        try:
            return self.xpath("//premis:eventOutcomeInformation",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            self.eventOutcomeInformation = ""
            return self.xpath("//premis:eventOutcomeInformation",
                              namespaces=NAMESPACES)[0]

    @eventOutcomeInformation.setter
    def eventOutcomeInformation(self, value):
        element = SubElement(
            self.getroot(), PREMIS + "eventOutcomeInformation")
        element.text = value.decode("utf-8")

    @property
    def eventOutcome(self):
        return self.xpath(
            "//premis:eventOutcomeInformation/premis:eventOutcome/text()",
                          namespaces=NAMESPACES)[0].encode("utf-8")

    @eventOutcome.setter
    def eventOutcome(self, value):
        element = SubElement(
            self.eventOutcomeInformation, PREMIS + "eventOutcome")
        element.text = value.decode("utf-8")

    @property
    def eventOutcomeDetail(self):
        try:
            return self.xpath(
                "//premis:eventOutcomeInformation/premis:eventOutcomeDetail",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            self.eventOutcomeDetail = ""
            return self.xpath(
                "//premis:eventOutcomeInformation/premis:eventOutcomeDetail",
                              namespaces=NAMESPACES)[0]

    @eventOutcomeDetail.setter
    def eventOutcomeDetail(self, value):
        element = SubElement(
            self.eventOutcomeInformation, PREMIS + "eventOutcomeDetail")
        # Note: only whitespace is allowed in this element by Premis schema
        # element.text = value.decode("utf-8")

    @property
    def eventOutcomeDetailNote(self):
        try:
            return self.xpath(
                "//premis:eventOutcomeInformation/premis:eventOutcomeDetail/premis:eventOutcomeDetailNote",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            return ""

    @eventOutcomeDetailNote.setter
    def eventOutcomeDetailNote(self, value):
        if value:
            element = SubElement(
                self.eventOutcomeDetail, PREMIS + "eventOutcomeDetailNote")
            element.text = value.decode("utf-8")

    @property
    def eventOutcomeDetailExtension(self):
        try:
            return self.xpath(
                "//premis:eventOutcomeInformation/premis:eventOutcomeDetail/premis:eventOutcomeDetailExtension", namespaces=NAMESPACES)[0]
        except IndexError:
            self.eventOutcomeDetailExtension = ""
            return self.eventOutcomeDetailExtension

    @eventOutcomeDetailExtension.setter
    def eventOutcomeDetailExtension(self, value):
        try:
            parser = lxml.etree.XMLParser(
                dtd_validation=False, no_network=True)
            tree = lxml.etree.fromstring(value)

            element = SubElement(
                self.eventOutcomeDetail, PREMIS +
                "eventOutcomeDetailExtension")
            childNodeList = tree.findall('*')
            for node in childNodeList:
                element.append(node)

        except lxml.etree.XMLSyntaxError as exception:
            element = SubElement(
                self.eventOutcomeDetail, PREMIS +
                "eventOutcomeDetailExtension")
            element.text = value.decode("utf-8")
        except ValueError:
            return

    @property
    def linkingObjectIdentifier(self):
        try:
            return self.xpath("//premis:linkingObjectIdentifier",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            self.linkingObjectIdentifier = ""
            return self.xpath("//premis:linkingObjectIdentifier",
                              namespaces=NAMESPACES)[0]

    @linkingObjectIdentifier.setter
    def linkingObjectIdentifier(self, value):
        element = SubElement(
            self.getroot(), PREMIS + "linkingObjectIdentifier")
        element.text = ""

    @property
    def linkingObjectIdentifierType(self):
        if self.linkingObjectIdentifier is None:
            self.linkingObjectIdentifier = ""

        return self.xpath(
            "//premis:linkingObjectIdentifier/premis:linkingObjectIdentifierType/text()",
                          namespaces=NAMESPACES)[0].encode("utf-8")

    @linkingObjectIdentifierType.setter
    def linkingObjectIdentifierType(self, value):
        if value:
            element = SubElement(
                self.linkingObjectIdentifier, PREMIS +
                "linkingObjectIdentifierType")
            element.text = value.decode("utf-8")

    @property
    def linkingObjectIdentifierValue(self):
        try:
            return self.xpath(
                "//premis:linkingObjectIdentifier/premis:linkingObjectIdentifierValue/text()",
                              namespaces=NAMESPACES)[0].encode("utf-8")
        except IndexError:
            return ""

    @linkingObjectIdentifierValue.setter
    def linkingObjectIdentifierValue(self, value):
        if value:
            element = SubElement(
                self.linkingObjectIdentifier, PREMIS + "linkingObjectIdentifierValue")
            element.text = value.decode("utf-8")

    @property
    def linkingAgentIdentifier(self):
        try:
            return self.xpath("//premis:linkingAgentIdentifier",
                              namespaces=NAMESPACES)[0]
        except IndexError:
            self.linkingAgentIdentifier = ""
            return self.linkingAgentIdentifier

    @linkingAgentIdentifier.setter
    def linkingAgentIdentifier(self, value):
        element = SubElement(self.getroot(), PREMIS + "linkingAgentIdentifier")

    @property
    def linkingAgentIdentifierType(self):
        return self.xpath(
            "//premis:linkingAgentIdentifier/premis:linkingAgentIdentifierType/text()",
                          namespaces=NAMESPACES)[0].encode("utf-8")

    @linkingAgentIdentifierType.setter
    def linkingAgentIdentifierType(self, value):
        element = SubElement(
            self.linkingAgentIdentifier, PREMIS + "linkingAgentIdentifierType")
        element.text = value.decode("utf-8")

    @property
    def linkingAgentIdentifierValue(self):
        try:
            return self.xpath(
                "//premis:linkingAgentIdentifier/premis:linkingAgentIdentifierValue/text()",
                              namespaces=NAMESPACES)[0].encode("utf-8")
        except IndexError:
            return ""

    @linkingAgentIdentifierValue.setter
    def linkingAgentIdentifierValue(self, value):
        element = SubElement(
            self.linkingAgentIdentifier, PREMIS + "linkingAgentIdentifierValue")
        element.text = value.decode("utf-8")

    def __init__(self):
        super(Event, self).__init__()
        self.root = self.root = Element(PREMIS + 'event', nsmap=NAMESPACES)

    def fromvalidator(
            self, result,
            linkingObject=None, linkingAgent=None):
        """
        From valdiator.
        """

        self.eventIdentifier = ""
        self.eventIdentifierType = "preservation-event-id"
        self.eventIdentifierValue = str(uuid.uuid4())
        self.eventType = "validation"
        self.eventDateTime = self.get_edtf_time()
        self.eventDetail = "Digital object validation"

        self.eventOutcomeInformation = ""
        if result["is_valid"] is True:
            self.eventOutcome = "success"
        else:
            self.eventOutcome = "failure"

        try:
            parser = lxml.etree.XMLParser(
                dtd_validation=False, no_network=True)
            tree = lxml.etree.fromstring(result["messages"])

            self.eventOutcomeDetailExtension = ""
            childNodeList = tree.findall('*')
            for node in childNodeList:
                self.eventOutcomeDetailExtension = \
                    self.eventOutcomeDetailExtension + " " + node

            if result["errors"]:
                self.eventOutcomeDetailNote = result["errors"]

        except lxml.etree.XMLSyntaxError as exception:
            if result["errors"]:
                self.eventOutcomeDetailNote = (result["messages"] +
                                               result["errors"])
            else:
                self.eventOutcomeDetailNote = result["messages"]

        if linkingAgent:
            self.linkingAgentIdentifierType = linkingAgent.identifierType
            self.linkingAgentIdentifierValue = linkingAgent.identifierValue

        if linkingObject:
            self.linkingObjectIdentifier = ""
            self.linkingObjectIdentifierType = linkingObject.identifierType
            self.linkingObjectIdentifierValue = linkingObject.identifierValue

    def serialize(self):
        """
        Serialize the data of this class (Premis event) to XML.

        Returns:
            content of this class as serialized XML (string)
        """

        return tostring(self.root, pretty_print=True)

    def get_edtf_time(self):
        time_now = datetime.datetime.now()
        localtz = dateutil.tz.tzlocal()
        timezone_offset = localtz.utcoffset(time_now)
        timezone_offset = (timezone_offset.days * 86400 +
                           timezone_offset.seconds) / 3600
        return time_now.strftime('%Y-%m-%dT%H:%M:%S')
