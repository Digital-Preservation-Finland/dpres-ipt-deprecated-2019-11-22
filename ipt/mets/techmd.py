import os
import lxml.etree

ADDML_URI = "http://www.arkivverket.no/standarder/addml"
METS_URI = "http://www.loc.gov/METS/"
PREMIS_URI = "info:lc/xmlns/premis-v2"
XLINK_URI = "http://www.w3.org/1999/xlink"
NAMESPACES = {
    "premis": PREMIS_URI,
    "mets": METS_URI,
    "addml": ADDML_URI,
    "xlink": XLINK_URI}


def get_tech_md_list_for_file(file_path, mets_path):
    """Get a list of techmd sections from mets.xml for a certain file described
    in the fileSec.
    :file_path: a full path of digital object.
    :mets_path: a full path of mets.xml
    :returns: a dict of all relevant techmd data for validation purposes."""
    mets_tree = lxml.etree.parse(mets_path)
    filename = os.path.relpath(file_path, os.path.dirname(mets_path))
    if filename.startswith('../'):
        filename = filename.replace('../', '')

    adm_ids = _get_adm_id_for_file(mets_tree, filename)
    adm_id_string = _get_adm_id_attribute_string(adm_ids)
    query = ".//mets:techMD%s" % adm_id_string
    techmds = mets_tree.xpath(query, namespaces=NAMESPACES)
    techmd_dict = _parse_techmd_to_dict(techmds)
    return techmd_dict


def _get_adm_id_attribute_string(adm_ids):
    """Make an attribute string for xpath query.
    :adm_ids: a list of mets admids.
    :returns: a string with format: [ID=abc|ID=123|...]"""
    adm_id_string = "["
    for adm_id in adm_ids:
        adm_id_string = "%s@ID='%s' or " % (adm_id_string, adm_id)
    adm_id_string = adm_id_string[:-4]
    adm_id_string = "%s]" % adm_id_string
    return adm_id_string


def _get_adm_id_for_file(mets_tree, filename):
    """Get files adm id for mets ElementTree. This information is described in
    mets.xml fileSec part. See below:

    <mets:fileSec>
      <mets:fileGrp>
        <mets:file ADMID="techmd-001 techmd-002 event-001 agent-001"
            ID="fileid-001">
          <mets:FLocat LOCTYPE="URL"
            xlink:href="file://./file.csv" xlink:type="simple"/>
        </mets:file>
      </mets:fileGrp>
    </mets:fileSec>
    :mets_tree: mets.xml as lxml.etree
    :filename: digital obects relative path in sip.
    :returns: a list of adm_id strings
    """
    query = ".//mets:FLocat[contains(@xlink:href, %s)]/.." % (filename)
    file_tree = mets_tree.xpath(query, namespaces=NAMESPACES)[0]
    adm_id = file_tree.attrib['ADMID'].split(" ")
    return adm_id


def _parse_techmd_to_dict(techmds):
    """parse a list of techmd etrees into a dict.
    :techmds: a list of etrees
    :returns: a dict of relevant data."""
    data_dict = {"addml": {}}
    for techmd in techmds:
        query = ".//mets:xmlData"
        data_tree = techmd.xpath(query, namespaces=NAMESPACES)[0]
            data_dict["addml"]["charset"] = data_tree.xpath(
                ".//addml:charset", namespaces=NAMESPACES)[0].text
            data_dict["addml"]["separator"] = data_tree.xpath(
                ".//addml:recordSeparator", namespaces=NAMESPACES)[0].text
            data_dict["addml"]["delimiter"] = data_tree.xpath(
                ".//addml:fieldSeparatingChar",
                namespaces=NAMESPACES)[0].text
            headers = data_tree.xpath(
                ".//addml:description", namespaces=NAMESPACES)
            header_list = []
            for header in headers:
                header_list.append(header.text)
            data_dict["addml"]["headers"] = header_list
    return data_dict


