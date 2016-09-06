""" AudioMD library module. This module maps videoMD data needed by validation 
to dict. AudioMD format is described below.

<amd:AUDIOMD xmlns:amd="http://www.loc.gov/audioMD/" ANALOGDIGITALFLAG="FileDigital">
    <amd:fileData>
        <amd:audioDataEncoding>PCM</amd:audioDataEncoding>
        <amd:bitsPerSample>8</amd:bitsPerSample>
        <amd:compression>
            <amd:codecCreatorApp>SoundForge</amd:codecCreatorApp>
            <amd:codecCreatorAppVersion>10</amd:codecCreatorAppVersion>
            <amd:codecName>MPEG 2</amd:codecName>
            <amd:codecQuality>lossy</amd:codecQuality>
        </amd:compression>
        <amd:dataRate>256</amd:dataRate>
        <amd:dataRateMode>Fixed</amd:dataRateMode>
        <amd:samplingFrequency>44100</amd:samplingFrequency>
    </amd:fileData>
    <amd:audioInfo>
        <amd:duration>00:08:37.9942</amd:duration>
        <amd:numChannels>1</amd:numChannels>
    </amd:audioInfo>
</amd:AUDIOMD>
"""

AUDIOMD_URI = "http://www.loc.gov/audioMD/"
NAMESPACES = {"amd": AUDIOMD_URI}


def to_dict(audiomd_xml):
    """parse a list of techmd etrees into a dict.
    :audiomd_xml: audiomd etree
    :returns: a dict of audiomd data."""

    audiomd = {"audiomd": {}}
    if audiomd_xml is None:
        return {}

    audiomd["audiomd"]["codecname"] = audiomd_xml.xpath(
        ".//amd:codecName", namespaces=NAMESPACES)[0].text

    return audiomd
