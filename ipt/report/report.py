import lxml.etree
import uuid
import datetime
import dateutil
import premis


def contains_errors(report):
    events = report.findall('.//'+premis.premis_ns('eventOutcome'))
    for event in events:
        if event.text == 'failure':
            return True
    return False


def object_fromvalidator(representation=True,
                  identifierType="preservation-object-id", fileinfo=None,
                  relatedObject=None):
    """
    From validator.
    """
    object_id = premis.identifier(identifierType, str(uuid.uuid4()))

    childs = []
    if fileinfo:
        originalname = fileinfo['filename']
        dep_id = premis.identifier(fileinfo['object_id']['type'], fileinfo['object_id']['value'], 'dependency') 
        environ = premis.environment(dep_id)
        childs = [environ]
    else:
        originalname = None

    if relatedObject is not None:
        related = premis.relationship('structural', 'is included in', relatedObject)
        childs.append(related)

    if childs == []:
        childs = None

    return premis.object(object_id, originalname, child_elements=childs, representation=representation)


def event_fromvalidator(result,
    linkingObject=None, linkingAgent=None):
    """
    From validator.
    """

    event_id = premis.identifier("preservation-event-id", str(uuid.uuid4()), 'event')
    if result["is_valid"] is True:
        outresult = "success"
    else:
        outresult = "failure"

    detail_note = None
    detail_extension = None  
    try:
        parser = lxml.etree.XMLParser(
            dtd_validation=False, no_network=True)
        tree = lxml.etree.fromstring(result["messages"])

        for node in childNodeList:
            detail_extension = detail_extension + " " + node

        if result["errors"]:
            detail_note = result["errors"]

    except lxml.etree.XMLSyntaxError as exception:
        if result["errors"]:
            detail_note = (result["messages"] + result["errors"])
        else:
            detail_note = result["messages"]

    outcome = premis.outcome(outresult, detail_note=detail_note, detail_extension=detail_extension)
    childs = [outcome]

    if linkingAgent is not None:
        childs.append(linkingAgent)

    if linkingObject is not None:
        childs.append(linkingObject)

    return premis.event(event_id, "validation", get_edtf_time(), "Digital object validation", child_elements=childs)

def get_edtf_time():
    time_now = datetime.datetime.now()
    localtz = dateutil.tz.tzlocal()
    timezone_offset = localtz.utcoffset(time_now)
    timezone_offset = (timezone_offset.days * 86400 +
                       timezone_offset.seconds) / 3600
    return time_now.strftime('%Y-%m-%dT%H:%M:%S')

