""" VideoMD library module. This module maps videoMD data needed by validation
to dict. VideoMD format is described below.

<vmd:VIDEOMD xmlns:vmd="http://www.loc.gov/videoMD/" ANALOGDIGITALFLAG="FileDigital">
    <vmd:fileData>
        <vmd:duration>01:31:37</vmd:duration>
        <vmd:dataRate>8</vmd:dataRate>
        <vmd:bitsPerSample>24</vmd:bitsPerSample>
        <vmd:color>Color</vmd:color>
        <vmd:compression>
            <vmd:codecCreatorApp>SoundForge</vmd:codecCreatorApp>
            <vmd:codecCreatorAppVersion>10</vmd:codecCreatorAppVersion>
            <vmd:codecName>MPEG 2</vmd:codecName>
            <vmd:codecQuality>lossy</vmd:codecQuality>
        </vmd:compression>
        <vmd:dataRateMode>Fixed</vmd:dataRateMode>
        <vmd:frame>
            <vmd:pixelsHorizontal>640</vmd:pixelsHorizontal>
            <vmd:pixelsVertical>480</vmd:pixelsVertical>
            <vmd:PAR>1.0</vmd:PAR>
            <vmd:DAR>4/3</vmd:DAR>
        </vmd:frame>
        <vmd:frameRate>24</vmd:frameRate>
        <vmd:sampling>4:2:2</vmd:sampling>
        <vmd:signalFormat>PAL</vmd:signalFormat>
        <vmd:sound>No</vmd:sound>
   </vmd:fileData>
</vmd:VIDEOMD>

"""

from fractions import Fraction

VIDEOMD_URI = "http://www.loc.gov/videoMD/"
NAMESPACES = {"vmd": VIDEOMD_URI}


def to_dict(videomd_xml):
    """parse a list of techmd etrees into a dict.
    :videomd_xml: videomd etree
    :returns: a dict of videomd data."""

    videomd = {"video": []}
    if videomd_xml is None:
        return {}
    video = {}
    video["duration"] = parse_element("duration", videomd_xml)
    video["level"] = parse_element("dataRate", videomd_xml)
    video["codec_name"] = parse_element("codecName", videomd_xml)
    video["avg_frame_rate"] = parse_element("frameRate", videomd_xml)
    video["width"] = parse_element("pixelsHorizontal", videomd_xml)
    video["height"] = parse_element("pixelsVertical", videomd_xml)
    video["display_aspect_ratio"] = parse_element("DAR", videomd_xml)
    video["sample_aspect_ratio"] = get_sar(videomd_xml)

    videomd["video"].append(video)
    return videomd


def parse_element(element, videomd_xml):
    """
    Wrapper for xpath query.
    """
    query = ".//vmd:%s" % element
    return videomd_xml.xpath(query, namespaces=NAMESPACES)[0].text


def get_sar(videomd_xml):
    """
    calculate SAR from DAR and PAR. SAR = DAR / PAR.
    :videomd_xml: input videomd-xml
    :returns: a fractional SAR value.
    """
    par = Fraction(parse_element("PAR", videomd_xml))
    dar = Fraction(parse_element("DAR", videomd_xml))

    sar = dar/par
    return "%s" % str(sar).replace("/", ":")
