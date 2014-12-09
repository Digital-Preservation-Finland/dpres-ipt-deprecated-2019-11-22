<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.4.1">
    <sch:title>METS organizational metadata type check</sch:title>

<!--
Validates that the used organizational metadata type inside mdWrap element is same as defined in OTHERMDTYPE attribute.
Juha Lehtonen 2014-12-09 : Initial version
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="nbar" uri="http://muisti.nba.fi/report/"/>

	<!-- Check the case LIDO -->
	<sch:pattern name="CheckLido">
        <sch:rule context="mets:mdWrap[@OTHERMDTYPE='NBAR']">
			<sch:assert test="mets:xmlData/nbar:*">
				MDTYPE attribute is 'NBAR', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	
</sch:schema>
