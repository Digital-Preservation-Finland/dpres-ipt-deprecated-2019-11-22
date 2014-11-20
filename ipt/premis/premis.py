import lxml.etree
from lxml.etree import Element, SubElement, tostring

from object import Object
from event import Event
from agent import Agent

PREMIS_NS = "info:lc/xmlns/premis-v2"
PREMIS = "{%s}" % PREMIS_NS
PREMIS_SCHEMALOCATION = "%s http://www.loc.gov/standards/premis/premis.xsd" % \
    PREMIS_NS

XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"

XSI = "{%s}" % XSI_NS

NAMESPACES = {'premis': PREMIS_NS, 'xsi': XSI_NS}
PREMIS_VERSION = "2.2"


class Premis:

    """
    The purpose of this class is to construct and serialize Premis XML
    document. This class collects other objects which represents Premis XML
    elements such as events, objects and agents and encapsulates them into
    one object. Encapsulated objectes can be serialized as one XML document.

        This class serializes the following XML output

        .. code-block:: xml

            <premis:premis>
                <premis:event>
                    ...
                </premis:event>
            <premis:premis>


        .. note:: At the moment only this class can only encapsulate Premis
        events.
    """

    objects = []
    events = []
    agents = []

    def __init__(self):
        self.events = []
        self.objects = []
        self.agents = []

    def insert(self, object):
        """ Insert new element into Premis XML tree.

            args: object to inserted into XML tree
        """

        if isinstance(object, Event):
            self.events.append(object)

        if isinstance(object, Object):
            self.objects.append(object)

        if isinstance(object, Agent):
            # Check that there's no agent with same agentIdentifier
            for agent in self.agents:
                if agent.identifierValue == object.identifierValue:
                    # FIXME: Perhaps we should rase an exception
                    return False

            self.agents.append(object)

    def fromstring(self, string):

        if (string is None):
            return None

        root = lxml.etree.fromstring(string.decode("utf-8"))

        events = root.findall(PREMIS + 'event')
        for event in events:
            ev = Event()
            ev.root = event
            self.insert(ev)

        objects = root.findall(PREMIS + 'object')
        for object in objects:
            ob = Object()
            ob.root = object
            self.insert(ob)

        agents = root.findall(PREMIS + 'agent')
        for agent in agents:
            ag = Agent()
            ag.root = agent
            self.insert(ag)

    def serialize(self):
        """
        Serialize encapsulated objects to XML.

        Returns:
            content of this class as serialized XML (string).
        """

        el_root = Element(PREMIS + 'premis', nsmap=NAMESPACES)
        el_root.set(XSI + 'schemaLocation', PREMIS_SCHEMALOCATION)
        el_root.set('version', PREMIS_VERSION)

        for ob in self.objects:
            el_root.append(ob.root)

        for ev in self.events:
            el_root.append(ev.root)

        for ag in self.agents:
            el_root.append(ag.root)

        return tostring(el_root, pretty_print=True, xml_declaration=True,
                        encoding='UTF-8')