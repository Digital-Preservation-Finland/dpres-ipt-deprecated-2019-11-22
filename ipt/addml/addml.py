""" addml.xml library module."""

ADDML_URI = "http://www.arkivverket.no/standarder/addml"
NAMESPACES = {"addml": ADDML_URI}


def to_dict(addml_xml):
    """parse a list of techmd etrees into a dict.
    :addml_xml: addml etree
    :returns: a dict of addml data."""

    addml = {"addml": {}}
    if not addml_xml:
        return {}
    addml["addml"]["charset"] = addml_xml.xpath(
        ".//addml:charset", namespaces=NAMESPACES)[0].text
    addml["addml"]["separator"] = addml_xml.xpath(
        ".//addml:recordSeparator", namespaces=NAMESPACES)[0].text
    addml["addml"]["delimiter"] = addml_xml.xpath(
        ".//addml:fieldSeparatingChar",
        namespaces=NAMESPACES)[0].text
    headers = addml_xml.xpath(
        ".//addml:description", namespaces=NAMESPACES)
    header_list = []
    for header in headers:
        header_list.append(header.text)
    addml["addml"]["headers"] = header_list
    return addml
