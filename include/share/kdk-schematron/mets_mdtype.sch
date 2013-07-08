<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Joku otsikko</sch:title>
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="textmd" uri="http://kdk.fi/standards/textmd"/>
	<sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>
	<sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>
	<sch:ns prefix="metsrights" uri="http://cosimo.stanford.edu/sdr/metsrights/"/>
	<sch:ns prefix="marc21" uri="http://www.loc.gov/MARC21/slim"/>
	<sch:ns prefix="mods" uri="http://www.loc.gov/mods/v3"/>
	<sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
	<sch:ns prefix="dcterms" uri="http://purl.org/dc/terms/"/>
	<sch:ns prefix="dcmitype" uri="http://purl.org/dc/dcmitype/"/>
	<sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
	<sch:ns prefix="eac" uri="urn:isbn:1-931666-33-4"/>
	<sch:ns prefix="vra" uri="http://www.vraweb.org/vracore4.htm"/>
	<sch:ns prefix="lido" uri="http://www.lido-schema.org"/>
	<sch:ns prefix="ddilc" uri="ddi:instance:3_1"/>
	<sch:ns prefix="ddicb" uri="ddi:codebook:2_5"/>

    <sch:pattern name="CheckPremisObject">
        <sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:OBJECT']">
			<sch:assert test="mets:xmlData/premis:object">
				Ei premisiä
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
    <sch:pattern name="CheckPremisEvent">
        <sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:EVENT']">
			<sch:assert test="mets:xmlData/premis:event">
				Ei premisiä
			</sch:assert>
		</sch:rule>
    </sch:pattern>

    <sch:pattern name="CheckPremisAgent">
        <sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:AGENT']">
			<sch:assert test="mets:xmlData/premis:agent">
				Ei premisiä
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckMetsrights">
        <sch:rule context="mets:mdWrap[@MDTYPE='METSRIGHTS']">
			<sch:assert test="mets:xmlData/metsrights:*">
				Ei metsrights
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<sch:pattern name="CheckMix">
        <sch:rule context="mets:mdWrap[@MDTYPE='NISOIMG']">
			<sch:assert test="mets:xmlData/mix:*">
				Ei mix
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckTextMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='TEXTMD']">
			<sch:assert test="mets:xmlData/textmd:*">
				Ei textmd
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckAudioMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @MDTYPEOTHER='AudioMD']">
			<sch:assert test="mets:xmlData/audiomd:*">
				Ei audiomd
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckVideoMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @MDTYPEOTHER='VideoMD']">
			<sch:assert test="mets:xmlData/videomd:*">
				Ei videomd
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckLido">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @MDTYPEOTHER='LIDO']">
			<sch:assert test="mets:xmlData/lido:*">
				Ei lido
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckEAC">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAC-CPF']">
			<sch:assert test="mets:xmlData/eac:*">
				Ei eac
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckEAD">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAD']">
			<sch:assert test="mets:xmlData/ead:*">
				Ei ead
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckVraCore">
        <sch:rule context="mets:mdWrap[@MDTYPE='VRA']">
			<sch:assert test="mets:xmlData/vra:*">
				Ei vra
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckMods">
        <sch:rule context="mets:mdWrap[@MDTYPE='MODS']">
			<sch:assert test="mets:xmlData/mods:*">
				Ei mods
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckMarc">
        <sch:rule context="mets:mdWrap[@MDTYPE='MARC21' or @MDTYPE='FINMARC']">
			<sch:assert test="mets:xmlData/marc21:*">
				Ei marc
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckDC">
        <sch:rule context="mets:mdWrap[@MDTYPE='DC']">
			<sch:assert test="mets:xmlData/dc:*">
				Ei dc
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<sch:pattern name="CheckDDI">
        <sch:rule context="mets:mdWrap[@MDTYPE='DDI']">
			<sch:assert test="mets:xmlData/ddilc:*|ddicb:*">
				Ei ddi
			</sch:assert>
		</sch:rule>
    </sch:pattern>

</sch:schema>