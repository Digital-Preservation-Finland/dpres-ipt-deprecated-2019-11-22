""" addml.xml library module."""

import lxml.etree

ADDML_URI = "http://www.arkivverket.no/standarder/addml"
NAMESPACES = {"addml": ADDML_URI}


def to_dict(addml_xml):
    """parse a list of techmd etrees into a dict.
    :addml_xml: addml etree
    :returns: a dict of addml data."""

    query = ".//mets:xmlData"
    data_tree = addml_xml.xpath(query, namespaces=NAMESPACES)[0]

    addml = {}
    addml["charset"] = data_tree.xpath(
        ".//addml:charset", namespaces=NAMESPACES)[0].text
    addml["separator"] = data_tree.xpath(
        ".//addml:recordSeparator", namespaces=NAMESPACES)[0].text
    addml["delimiter"] = data_tree.xpath(
        ".//addml:fieldSeparatingChar",
        namespaces=NAMESPACES)[0].text
    headers = data_tree.xpath(
        ".//addml:description", namespaces=NAMESPACES)
    header_list = []
    for header in headers:
        header_list.append(header.text)
    addml["headers"] = header_list
    return addml
