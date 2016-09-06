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

VIDEOMD_URI = "http://www.loc.gov/videoMD/"
NAMESPACES = {"vmd": VIDEOMD_URI}


def to_dict(videomd_xml):
    """parse a list of techmd etrees into a dict.
    :videomd_xml: videomd etree
    :returns: a dict of videomd data."""

    videomd = {"videomd": {}}
    if videomd_xml is None:
        return {}

    videomd["videomd"]["codecname"] = videomd_xml.xpath(
        ".//vmd:codecName", namespaces=NAMESPACES)[0].text

    return videomd
