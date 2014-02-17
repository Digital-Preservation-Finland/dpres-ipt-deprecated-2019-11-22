<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>PREMIS metadata check</sch:title>

<!--
Validates various PREMIS issues.
Juha Lehtonen 2013-10-21 : Initial version
Juha Lehtonen 2014-02-07 : MIME type added for ARC files. Filetype versions and Pronom keys added.
Jukka Kervinen 2014-02-12 : Added <sch:value-of select="."/> to identifier test outputs.
Jukka Kervinen 2014-02-13 : Fixed premis:rightsIdentifierValue -> premis:rightsStatementIdentifierValue.
Juha Lehtonen 2014-02-14 : MIME type related check restricted only in mets:techMD section
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>

	<!-- Allowed MIME types -->
	<sch:let name="mime" value="('application/epub+zip', 'application/xhtml+xml', 'text/xml', 'text/html', 'application/vnd.oasis.opendocument.text', 'application/vnd.oasis.opendocument.spreadsheet', 'application/vnd.oasis.opendocument.database', 'application/vnd.oasis.opendocument.presentation', 'application/vnd.oasis.opendocument.graphics', 'application/pdf', 'text/plain', 'audio/x-aiff', 'audio/x-wave', 'audio/flac', 'audio/aac', 'audio/x-wav', 'video/mj2', 'video/jpeg2000', 'image/jpeg', 'image/jp2', 'image/tiff', 'image/png', 'application/warc', 'application/msword', 'application/vnd.ms-excel', 'application/vnd.ms-powerpoint', 'audio/mpeg', 'audio/x-ms-wma', 'video/dv', 'video/mpeg', 'video/x-ms-wmv', 'application/postscript', 'image/gif', 'application/x-internet-archive')"/>

	<!-- Allowed MIME type versions, grouped by file format, versions in a group divided with a space character. The number and ordering of the groups must be same as formats in MIME type list -->
	<sch:let name="mimeVersion" value="(string('2.0.1'), string('1.0 1.1'), string('1.0'), string('4.01'), string('1.0'), string('1.0'), string('1.0'), string('1.0'), string('1.0'), string('A-1a A-1b A-2a A-2b A-2u 1.2 1.3 1.4 1.5 1.6 1.7'), string('8859-15 UTF-8 UTF-16 UTF-32 utf-8 utf-16 utf-32'), string('1.3'), string('2'), string('1.2.1'), string(''), string(''), string(''), string(''), string('1.00 1.01 1.02'), string(''), string('6.0 1.3'), string('1.2'), string(''), string('8.0 8.5 9.0 10.0 11.0 12.0 14.0'), string('8.0 9.0 10.0 11.0 12.0 14.0'), string('8.0 9.0 10.0 11.0 12.0 14.0'), string(''), string('9'), string(''), string('1 2 4'), string('9'), string('3.0'), string('1987a 1989a'), string('1.0 1.1'))"/>
	
	<!-- Allowed PRONOM registry key versions, grouped by file format, keys in a group divided with a space character. The number and ordering of the groups must be same as formats in MIME type list -->
	<sch:let name="pronom" value="(string('fmt/483'), string('fmt/102 fmt/103'), string('fmt/101'), string('fmt/100'), string('fmt/136'), string('fmt/137'), string('fmt/138'), string('fmt/140'), string('fmt/139'), string('fmt/95 fmt/354 fmt/476 fmt/477 fmt/478 fmt/16 fmt/17 fmt/18 fmt/19 fmt/20 fmt/276'), string('x-fmt/111'), string('x-fmt/135 x-fmt/136'), string('fmt/2'), string('fmt/279'), string(''), string('fmt/141'), string('fmt/337'), string('fmt/392'), string('fmt/42 fmt/43 fmt/44'), string('x-fmt/392'), string('fmt/353 fmt/438'), string('fmt/13'), string('fmt/289'), string('fmt/40 fmt/412'), string('fmt/61 fmt/62 fmt/214'), string('fmt/126 fmt/215'), string('fmt/134'), string('fmt/132'), string('x-fmt/152'), string('x-fmt/386 fmt/199'), string('fmt/133'), string('fmt/124'), string('fmt/3 fmt/4'), string('x-fmt/219 fmt/410'))"/>

	<!-- Allowed checksum types divided with a space character -->
	<sch:let name="checksum" value="string('MD5 SHA-1 SHA-224 SHA-256 SHA-384 SHA-512 md5 sha-1 sha-224 sha-256 sha-384 sha-512')"/>	

	<!-- Check that files have creation dates -->
    <sch:pattern name="CheckCreatedByApp">
        <sch:rule context="premis:objectCharacteristics">
			<sch:assert test=".//premis:dateCreatedByApplication">
				The object creation date must be represented in &lt;premis:dateCreatedByApplication&gt; element.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that mime type and registy key is correct. Version and registry key not obligatory. -->
    <sch:pattern name="CheckFormat">
	    <sch:rule context="mets:techMD//premis:format">
            <sch:assert test=".//premis:formatDesignation">
           		Missing MIME type inside the element &lt;premis:format&gt;.
			</sch:assert>
			<sch:let name="index" value="index-of($mime, normalize-space(.//premis:formatName))"/>
            <sch:assert test="count($index) > 0">
           		Invalid MIME type '<sch:value-of select=".//premis:formatName"/>' in element &lt;premis:formatName&gt;.
			</sch:assert>
            <sch:assert test="(count(.//premis:formatVersion) = 0) or contains(concat(' ', normalize-space($mimeVersion[$index[1]]), ' '), concat(' ', normalize-space(.//premis:formatVersion), ' ')) or (normalize-space(.//premis:formatVersion) = '') or ($mimeVersion[$index[1]] = '')">
           		Invalid version '<sch:value-of select=".//premis:formatVersion"/>' in element &lt;premis:formatVersion&gt;, when format name is '<sch:value-of select=".//premis:formatName"/>'.
			</sch:assert>
            <sch:assert test="not(.//premis:formatRegistryKey) or contains(concat(' ', normalize-space($pronom[$index[1]]), ' '), concat(' ', normalize-space(.//premis:formatRegistryKey), ' ')) or (normalize-space(.//premis:formatRegistryKey) = '') or ($pronom[$index[1]] = '')">
           		Invalid registry key '<sch:value-of select=".//premis:formatRegistryKey"/>' in element &lt;premis:formatRegistryKey&gt;, when format name is '<sch:value-of select=".//premis:formatName"/>'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check that checksum algorithms are correct -->
    <sch:pattern name="CheckDigestAlgorithm">
		<sch:rule context="premis:messageDigestAlgorithm">
           <sch:assert test="contains(concat(' ', normalize-space($checksum), ' '), concat(' ', normalize-space(), ' '))">
				Invalid checksum algorithm '<sch:value-of select="."/>' used in element &lt;premis:messageDigestAlgorithm&gt;.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that Premis object identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="ObjectID">
        <sch:rule context="premis:objectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS object identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        	<sch:assert test="count(ancestor::mets:mets//premis:rightsStatementIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another rights identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
            	Missing target '<sch:value-of select="."/>' with the linking object identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis event identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="EventID">
        <sch:rule context="premis:eventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS event identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        	<sch:assert test="count(ancestor::mets:mets//premis:rightsStatementIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another rights identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingEventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
            	Missing target '<sch:value-of select="."/>'  with the linking event identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis agent identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="AgentID">
        <sch:rule context="premis:agentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS agent identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        	<sch:assert test="count(ancestor::mets:mets//premis:rightsStatementIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another rights identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingAgentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
            	Missing target '<sch:value-of select="."/>' with the linking agent identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that Premis rights identifiers are unique and linkingObjects have a target -->
	<sch:pattern name="RightsID">
		<sch:rule context="premis:rightsStatementIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::mets:mets//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS rights identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS rights identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS rights identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::mets:mets//premis:rightsStatementIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS rights identifiers must be unique. Another rights identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
        <sch:rule context="premis:linkingRightsIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
        	<sch:assert test="count(ancestor::mets:mets//premis:rightsStatementIdentifierValue[normalize-space(.) = $id]) = 1">
            	Missing target '<sch:value-of select="."/>' with the linking rights identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
</sch:schema>
