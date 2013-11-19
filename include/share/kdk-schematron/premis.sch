<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>PREMIS metadata check</sch:title>

<!--
Validates various PREMIS issues.
Juha Lehtonen 2013-10-21 : Initial version
-->

	<!-- Allowed MIME types divided with a space character -->
	<sch:let name="mime" value="string('application/epub+zip application/xhtml+xml text/xml text/html application/vnd.oasis.opendocument.text application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.database application/vnd.oasis.opendocument.presentation application/vnd.oasis.opendocument.graphics application/pdf text/plain audio/x-aiff audio/x-wave audio/flac audio/aac audio/x-wav video/mj2 video/jpeg2000 image/jpeg image/jp2 image/tiff image/png application/warc application/msword application/vnd.ms-excel application/vnd.ms-powerpoint application/pdf audio/x-aiff audio/mpeg audio/x-ms-wma video/dv video/mpeg video/x-ms-wmv image/tiff application/postscript image/gif')"/>

	<!-- Allowed checksum types divided with a space character -->
	<sch:let name="checksum" value="string('MD5 SHA-1 SHA-224 SHA-256 SHA-384 SHA-512')"/>	

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	
	<!-- Check that files have creation dates -->
    <sch:pattern name="CheckCreatedByApp">
        <sch:rule context="premis:objectCharacteristics">
			<sch:assert test=".//premis:dateCreatedByApplication">
				The object creation date must be represented in &lt;premis:dateCreatedByApplication&gt; element.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that mime types algorithm is correct -->
    <sch:pattern name="CheckFormat">
	    <sch:rule context="premis:format">
           <sch:assert test="premis:formatDesignation">
           		Missing MIME type inside the element &lt;premis:format&gt;.
			</sch:assert>
		</sch:rule>
	    <sch:rule context="premis:formatName">
           <sch:assert test="contains(concat(' ', normalize-space($mime), ' '), concat(' ', normalize-space(), ' '))">
           		Invalid MIME type in element &lt;premis:formatName&gt;.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that checksum algorithms are correct -->
    <sch:pattern name="CheckDigestAlgorithm">
	    <sch:rule context="premis:messageDigestAlgorithm">
           <sch:assert test="contains(concat(' ', normalize-space($checksum), ' '), concat(' ', normalize-space(), ' '))">
				Invalid checksum algorithm used in element &lt;premis:messageDigestAlgorithm&gt;.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that Premis object identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="ObjectID">
        <sch:rule context="premis:objectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
				The PREMIS object identifiers must be unique. Another object identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS object identifiers must be unique. Another event identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS object identifiers must be unique. Another agent identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS object identifiers must be unique. Another rights identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//@ID[normalize-space(.) = $id]) = 0">
				The PREMIS object identifiers must be unique. An identifier ID with the same value exists in METS.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets/@OBJID[normalize-space(.) = $id]) = 0">
				The PREMIS object identifiers must be unique. An identifier OBJID with the same value exists in METS.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
				Missing target with the linking object identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis event identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="EventID">
        <sch:rule context="premis:eventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS event identifiers must be unique. Another object identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
				The PREMIS event identifiers must be unique. Another event identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS event identifiers must be unique. Another agent identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS event identifiers must be unique. Another rights identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//@ID[normalize-space(.) = $id]) = 0">
				The PREMIS event identifiers must be unique. An identifier ID with the same value exists in METS.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets/@OBJID[normalize-space(.) = $id]) = 0">
				The PREMIS event identifiers must be unique. An identifier OBJID with the same value exists in METS.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingEventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
				Missing target with the linking event identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis agent identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="AgentID">
        <sch:rule context="premis:agentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS agent identifiers must be unique. Another object identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS agent identifiers must be unique. Another event identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
				The PREMIS agent identifiers must be unique. Another agent identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS agent identifiers must be unique. Another rights identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//@ID[normalize-space(.) = $id]) = 0">
				The PREMIS agent identifiers must be unique. An identifier ID with the same value exists in METS.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets/@OBJID[normalize-space(.) = $id]) = 0">
				The PREMIS agent identifiers must be unique. An identifier OBJID with the same value exists in METS.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingAgentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
				Missing target with the linking agent identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis rights identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="RightsID">
        <sch:rule context="premis:rightsIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS rights identifiers must be unique. Another object identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS rights identifiers must be unique. Another event identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
				The PREMIS rights identifiers must be unique. Another agent identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsIdentifierValue[normalize-space(.) = $id]) = 1">
				The PREMIS rights identifiers must be unique. Another rights identifier with the same value exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//@ID[normalize-space(.) = $id]) = 0">
				The PREMIS rights identifiers must be unique. An identifier ID with the same value exists in METS.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets/@OBJID[normalize-space(.) = $id]) = 0">
				The PREMIS rights identifiers must be unique. An identifier OBJID with the same value exists in METS.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingRightsIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsIdentifierValue[normalize-space(.) = $id]) = 1">
				Missing target with the linking rights identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
</sch:schema>
