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
Juha Lehtonen 2014-02-18 : Fixed to meet XPath 1.0 and EXSLT.
Juha Lehtonen 2014-03-12 : Fixed to meet the KDK technical metadata specification.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
    <sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<!-- Maximum length of a MIME type value -->
	<sch:let name="padval" value="80"/>
	<sch:let name="pad" value="str:padding($padval)"/>
	
	<!-- MIME types separated with a space character. If the list is modified, the MIME type version lists, PRONOM lists and  mimeNodes-variable needs to be modified. -->
	<sch:let name="mimeSet" value="str:tokenize('application/epub+zip application/xhtml+xml text/xml text/html application/vnd.oasis.opendocument.text application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.presentation application/vnd.oasis.opendocument.graphics application/vnd.oasis.opendocument.formula application/pdf text/plain audio/x-aiff audio/x-wave audio/flac audio/aac audio/x-wav video/mj2 video/jpeg2000 image/jpeg image/jp2 image/tiff image/png application/warc application/msword application/vnd.ms-excel application/vnd.ms-powerpoint audio/mpeg audio/x-ms-wma video/dv video/mpeg video/x-ms-wmv application/postscript image/gif application/x-internet-archive application/vnd.openxmlformatsofficedocument.wordprocessingml.document application/vnd.openxmlformatsofficedocument.spreadsheetml.sheet application/vnd.openxmlformatsofficedocument.presentationml.presentation',' ')"/>

	<!-- Allowed MIME type versions, grouped by file format, versions in a group divided with a space character. The number and ordering of the groups must be same as formats in MIME type list -->
	<sch:let name="mimeVersion" value="exsl:node-set('2.0.1') | exsl:node-set('1.0 1.1') | exsl:node-set('1.0') | exsl:node-set('4.01') | exsl:node-set('1.0') | exsl:node-set('1.0') | exsl:node-set('1.0') | exsl:node-set('1.0')  | exsl:node-set('1.0') | exsl:node-set('A-1a A-1b A-2a A-2b A-2u 1.2 1.3 1.4 1.5 1.6 1.7') | exsl:node-set('8859-15 UTF-8 UTF-16 UTF-32 utf-8 utf-16 utf-32') | exsl:node-set('1.3') | exsl:node-set('2') | exsl:node-set('1.2.1 1.3.0') | exsl:node-set('') | exsl:node-set('') | exsl:node-set('') | exsl:node-set('') | exsl:node-set('1.00 1.01 1.02') | exsl:node-set('') | exsl:node-set('6.0 1.3') | exsl:node-set('1.2') | exsl:node-set('') | exsl:node-set('8.0 8.5 9.0 10.0 11.0 12.0 14.0') | exsl:node-set('8.0 9.0 10.0 11.0 12.0 14.0') | exsl:node-set('8.0 9.0 10.0 11.0 12.0 14.0') | exsl:node-set('') | exsl:node-set('9') | exsl:node-set('') | exsl:node-set('1 2 4') | exsl:node-set('9') | exsl:node-set('3.0') | exsl:node-set('1987a 1989a') | exsl:node-set('1.0 1.1') | exsl:node-set('12.0 14.0') | exsl:node-set('12.0 14.0') | exsl:node-set('12.0 14.0')"/>

	<!-- Allowed PRONOM registry key versions, grouped by file format, keys in a group divided with a space character. The number and ordering of the groups must be same as formats in MIME type list -->
	<sch:let name="pronom" value="exsl:node-set('fmt/483') | exsl:node-set('fmt/102 fmt/103') | exsl:node-set('fmt/101') | exsl:node-set('fmt/100') | exsl:node-set('fmt/136') | exsl:node-set('fmt/137') | exsl:node-set('fmt/140') | exsl:node-set('fmt/139') | exsl:node-set('') | exsl:node-set('fmt/95 fmt/354 fmt/476 fmt/477 fmt/478 fmt/16 fmt/17 fmt/18 fmt/19 fmt/20 fmt/276') | exsl:node-set('x-fmt/111') | exsl:node-set('x-fmt/135 x-fmt/136') | exsl:node-set('fmt/527') | exsl:node-set('fmt/279') | exsl:node-set('') | exsl:node-set('fmt/141') | exsl:node-set('fmt/337') | exsl:node-set('fmt/392') | exsl:node-set('fmt/42 fmt/43 fmt/44') | exsl:node-set('x-fmt/392') | exsl:node-set('fmt/353 fmt/438') | exsl:node-set('fmt/13') | exsl:node-set('fmt/289') | exsl:node-set('fmt/40 fmt/412') | exsl:node-set('fmt/61 fmt/62 fmt/214') | exsl:node-set('fmt/126 fmt/215') | exsl:node-set('fmt/134') | exsl:node-set('fmt/132') | exsl:node-set('x-fmt/152') | exsl:node-set('x-fmt/385 x-fmt/386 fmt/199') | exsl:node-set('fmt/133') | exsl:node-set('fmt/124') | exsl:node-set('fmt/3 fmt/4') | exsl:node-set('x-fmt/219 fmt/410') | exsl:node-set('fmt/412') | exsl:node-set('fmt/214') | exsl:node-set('fmt/215')"/>

	<!-- Allowed checksum types divided with a space character -->
	<sch:let name="checksum" value="string('MD5 SHA-1 SHA-224 SHA-256 SHA-384 SHA-512 md5 sha-1 sha-224 sha-256 sha-384 sha-512')"/>	
	

	<!-- MIME types reformatted. If MIME type list is modified, this list needs to be modified according to the number of MIME types -->
	<sch:let name="mimeNodes" value="exsl:node-set(str:align($mimeSet[1], $pad)) | exsl:node-set(str:align($mimeSet[2], $pad)) | exsl:node-set(str:align($mimeSet[3], $pad)) | exsl:node-set(str:align($mimeSet[4], $pad)) | exsl:node-set(str:align($mimeSet[5], $pad)) | exsl:node-set(str:align($mimeSet[6], $pad)) | exsl:node-set(str:align($mimeSet[7], $pad)) | exsl:node-set(str:align($mimeSet[8], $pad)) |
	exsl:node-set(str:align($mimeSet[9], $pad)) | exsl:node-set(str:align($mimeSet[10], $pad)) | exsl:node-set(str:align($mimeSet[11], $pad)) | exsl:node-set(str:align($mimeSet[12], $pad)) | exsl:node-set(str:align($mimeSet[13], $pad)) | exsl:node-set(str:align($mimeSet[14], $pad)) | exsl:node-set(str:align($mimeSet[15], $pad)) | exsl:node-set(str:align($mimeSet[16], $pad)) | exsl:node-set(str:align($mimeSet[17], $pad)) | exsl:node-set(str:align($mimeSet[18], $pad)) | exsl:node-set(str:align($mimeSet[19], $pad)) | exsl:node-set(str:align($mimeSet[20], $pad)) | exsl:node-set(str:align($mimeSet[21], $pad)) | exsl:node-set(str:align($mimeSet[22], $pad)) | exsl:node-set(str:align($mimeSet[23], $pad)) | exsl:node-set(str:align($mimeSet[24], $pad)) | exsl:node-set(str:align($mimeSet[25], $pad)) | exsl:node-set(str:align($mimeSet[26], $pad)) | exsl:node-set(str:align($mimeSet[27], $pad)) | exsl:node-set(str:align($mimeSet[28], $pad)) | exsl:node-set(str:align($mimeSet[29], $pad)) | exsl:node-set(str:align($mimeSet[30], $pad)) | exsl:node-set(str:align($mimeSet[31], $pad)) | exsl:node-set(str:align($mimeSet[32], $pad)) | exsl:node-set(str:align($mimeSet[33], $pad)) | exsl:node-set(str:align($mimeSet[34], $pad)) | exsl:node-set(str:align($mimeSet[35], $pad)) | exsl:node-set(str:align($mimeSet[36], $pad)) | exsl:node-set(str:align($mimeSet[37], $pad))"/>
	
	<sch:let name="mime" value="str:concat($mimeNodes)"/>
	
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
            <sch:assert test="contains(concat(' ', $mime, ' '), concat(' ', normalize-space(.//premis:formatName), ' '))">
           		Invalid MIME type '<sch:value-of select=".//premis:formatName"/>' in element &lt;premis:formatName&gt;.
			</sch:assert>
			<sch:let name="pos" value="string-length(substring-before(concat(' ', $mime, ' '),concat(' ', normalize-space(.//premis:formatName), ' ')))"/>
			<sch:let name="verIndex" value="floor($pos div $padval)+1"/>
            <sch:assert test="not(.//premis:formatVersion) or contains(concat(' ', normalize-space($mimeVersion[$verIndex]), ' '), concat(' ', normalize-space(.//premis:formatVersion), ' ')) or normalize-space(.//premis:formatVersion)='' or $mimeVersion[$verIndex]=''">
           		Invalid version '<sch:value-of select=".//premis:formatVersion"/>' in element &lt;premis:formatVersion&gt;, when format name is '<sch:value-of select=".//premis:formatName"/>'. Valid values are: <sch:value-of select="normalize-space($mimeVersion[$verIndex])"/>.
			</sch:assert>
            <sch:assert test="not(.//premis:formatRegistryKey) or contains(concat(' ', normalize-space($pronom[$verIndex]), ' '), concat(' ', normalize-space(.//premis:formatRegistryKey), ' ')) or normalize-space(.//premis:formatRegistryKey)='' or $pronom[$verIndex]=''">
           		Invalid registry key '<sch:value-of select=".//premis:formatRegistryKey"/>' in element &lt;premis:formatRegistryKey&gt;, when format name is '<sch:value-of select=".//premis:formatName"/>'. . Valid values are: <sch:value-of select="normalize-space($pronom[$verIndex])"/>.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check that checksum algorithms are used -->
    <sch:pattern name="CheckFixity">
		<sch:rule context="premis:object[xsi:type='file']">
           <sch:assert test="//premis:fixity">
				Checksum algorithm missing in PREMIS object with ID: '<sch:value-of select=".//objectIdentifierValue"/>'
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	
	<!-- Check that checksum algorithms are correct -->
    <sch:pattern name="CheckDigestAlgorithm">
		<sch:rule context="premis:messageDigestAlgorithm">
           <sch:assert test="contains(concat(' ', normalize-space($checksum), ' '), concat(' ', normalize-space(), ' '))">
				Invalid checksum algorithm '<sch:value-of select="."/>' used in element &lt;premis:messageDigestAlgorithm&gt;. Valid values are: <sch:value-of select="$checksum"/>
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
