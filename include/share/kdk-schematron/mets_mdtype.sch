<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>METS external metadata type validation</sch:title>

<!--
Validates that the used metadata type inside mdWrap element is same as defined in MDTYPE or OTHERMDTYPE attribute.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="textmd_kdk" uri="http://www.kdk.fi/standards/textmd"/>
	<sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
	<sch:ns prefix="audiomd" uri="http://www.loc.gov/audioMD/"/>
	<sch:ns prefix="videomd" uri="http://www.loc.gov/videoMD/"/>
	<sch:ns prefix="marc21" uri="http://www.loc.gov/MARC21/slim"/>
	<sch:ns prefix="mods" uri="http://www.loc.gov/mods/v3"/>
	<sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
	<sch:ns prefix="dcterms" uri="http://purl.org/dc/terms/"/>
	<sch:ns prefix="dcmitype" uri="http://purl.org/dc/dcmitype/"/>
	<sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
	<sch:ns prefix="ead3" uri="http://ead3.archivists.org/schema/"/>
	<sch:ns prefix="eac" uri="urn:isbn:1-931666-33-4"/>
	<sch:ns prefix="vra" uri="http://www.vraweb.org/vracore4.htm"/>
	<sch:ns prefix="lido" uri="http://www.lido-schema.org"/>
	<sch:ns prefix="ddilc32" uri="ddi:instance:3_2"/>
	<sch:ns prefix="ddilc31" uri="ddi:instance:3_1"/>
	<sch:ns prefix="ddicb25" uri="ddi:codebook:2_5"/>
	<sch:ns prefix="ddicb21" uri="http://www.icpsr.umich.edu/DDI"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<sch:include href="./abstracts/allowed_unsupported_metadata_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_unsupported_metadata_pattern.incl"/>
	<sch:include href="./abstracts/required_metadata_format_specific_pattern.incl"/>
	<sch:include href="./abstracts/required_metadata_match_pattern.incl"/>
	<sch:include href="./abstracts/required_metadata_pattern.incl"/>

	<!-- Check metadata content in mdWrap -->
	<sch:pattern id="mets_mdtype_content" is-a="required_metadata_match_pattern">
		<sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
		<sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rightsStatement)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
			  + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.2')*number(boolean(mets:xmlData/ddilc32:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='3.1')*number(boolean(mets:xmlData/ddilc31:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.5')*number(boolean(mets:xmlData/ddicb25:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI' and normalize-space(@MDTYPEVERSION)='2.1')*number(boolean(mets:xmlData/ddicb21:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='TEXTMD' and (normalize-space(ancestor::mets:mets/@fi:CATALOG)='1.4.1' or normalize-space(ancestor::mets:mets/@fi:CATALOG)='1.4'
				or normalize-space(ancestor::mets:mets/@fi:SPECIFICATION)='1.4'))*number(boolean(mets:xmlData/textmd_kdk:*))*count(mets:xmlData/*)) = 1"/>
		<sch:param name="used_attribute" value="@MDTYPE"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets14_mdtype_content" is-a="required_metadata_match_pattern">
		<sch:param name="context_condition" value="not(@OTHERMDTYPE)"/>
		<sch:param name="required_condition" value="(number(normalize-space(@MDTYPE)='PREMIS:OBJECT')*count(mets:xmlData/premis:object)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:RIGHTS')*count(mets:xmlData/premis:rightsStatement)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:EVENT')*count(mets:xmlData/premis:event)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='PREMIS:AGENT')*count(mets:xmlData/premis:agent)*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='NISOIMG')*number(boolean(mets:xmlData/mix:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='MARC')*number(boolean(mets:xmlData/marc21:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DC')*number(boolean(mets:xmlData/dc:* or mets:xmlData/dcterms:* or mets:xmlData/dcmitype:*))
			  + number(normalize-space(@MDTYPE)='MODS')*number(boolean(mets:xmlData/mods:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAD')*number(boolean(mets:xmlData/ead:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='EAC-CPF')*number(boolean(mets:xmlData/eac:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='LIDO')*number(boolean(mets:xmlData/lido:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='VRA')*number(boolean(mets:xmlData/vra:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='DDI')*number(boolean(mets:xmlData/ddilc32:* or mets:xmlData/ddilc31:* or mets:xmlData/ddicb25:* or mets:xmlData/ddicb21:*))*count(mets:xmlData/*)
			  + number(normalize-space(@MDTYPE)='TEXTMD')*number(boolean(mets:xmlData/textmd_kdk:*))*count(mets:xmlData/*)) = 1"/>
		<sch:param name="used_attribute" value="@MDTYPE"/>
		<sch:param name="specifications" value="string('1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_othermdtype_content" is-a="required_metadata_match_pattern">
		<sch:param name="context_condition" value="@OTHERMDTYPE"/>
		<sch:param name="required_condition" value="(number(normalize-space(@OTHERMDTYPE)='ADDML')*number(boolean(mets:xmlData/addml:*))*count(mets:xmlData/*)
			  + number(normalize-space(@OTHERMDTYPE)='AudioMD')*number(boolean(mets:xmlData/audiomd:*))*count(mets:xmlData/*)
			  + number(normalize-space(@OTHERMDTYPE)='VideoMD')*number(boolean(mets:xmlData/videomd:*))*count(mets:xmlData/*)
			  + number(normalize-space(@OTHERMDTYPE)='EAD3')*number(boolean(mets:xmlData/ead3:*))*count(mets:xmlData/*)
			  + number(normalize-space(@OTHERMDTYPE)!='ADDML' and normalize-space(@OTHERMDTYPE)!='AudioMD' and normalize-space(@OTHERMDTYPE)!='VideoMD' and normalize-space(@OTHERMDTYPE)!='EAD3')*count(mets:xmlData/*)) = 1"/>
		<sch:param name="used_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- Disallow supported EN15744 metadata. This is a temporary check.
	EN15744 metadata schema does not exist, and therefore it's not clear how to support it. -->
	<sch:pattern id="mets_EN15744" is-a="disallowed_unsupported_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="unsupported_mdname" value="string('EN15744')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
	<!-- Notify the existence of unsupported metadata -->
	<sch:pattern id="mets_allowed_unsupported" is-a="allowed_unsupported_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_condition" value="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EN15744' and @OTHERMDTYPE!='EAD3' and @OTHERMDTYPE!='ADDML'"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Standard portfolio schemas -->
	<sch:pattern id="mets_object_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="*[@MDTYPE='PREMIS:OBJECT']"/>
		<sch:param name="metadata_name" value="string('PREMIS:OBJECT')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_event_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="*[@MDTYPE='PREMIS:EVENT']"/>
		<sch:param name="metadata_name" value="string('PREMIS:EVENT')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_descriptive_exists" is-a="required_metadata_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_metadata" value="*[@MDTYPE='LIDO' or @MDTYPE='EAC-CPF' or @MDTYPE='EAD' or @OTHERMDTYPE='EAD3'
		or @MDTYPE='VRA' or @MDTYPE='MODS' or @MDTYPE='MARC' or @MDTYPE='DC' or @MDTYPE='DDI' or @OTHERMDTYPE='EN15744']"/>
		<sch:param name="metadata_name" value="string('Standard portfolio descriptive')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Known descriptive, rights, technical, or provenance metadata can not be used inside wrong section -->
	<sch:pattern id="dmdsec_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rightsStatement"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rightsStatement"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="digiprovmd_no_rights" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:rightsStatement"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="dmdsec_no_tech" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:object or addml:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_tech" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:object or addml:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="digiprovmd_no_tech" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:object or addml:* or textmd_kdk:* or mix:* or audiomd:* or videomd:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="dmdsec_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_digiprov" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="premis:agent or premis:event"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="techmd_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="rights_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 
	<sch:pattern id="digiprovmd_no_descriptive" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap/mets:xmlData"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="lido:* or ead:* or ead3:* or vra:* or mods:* or marc21:* or dc:* or dcterms:* or dcmitype:* or ddilc32:* or ddilc31:* or ddicb25:* or ddicb21:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern> 

	<!-- File format specific technical metadata requirements -->
	<sch:pattern id="TextMD_file" is-a="required_metadata_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('application/xhtml+xml text/html text/xml text/plain')"/>
		<sch:param name="required_element" value="textmd_kdk:*"/>
		<sch:param name="mdtype_name" value="string('TextMD')"/>
		<sch:param name="specifications" value="string('1.4.1; 1.4')"/>	
	</sch:pattern>
	<sch:pattern id="ADDML_file" is-a="required_metadata_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('text/csv')"/>
		<sch:param name="required_element" value="addml:*"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="AudioMD_file" is-a="required_metadata_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('audio/x-aiff audio/x-wav audio/flac audio/mp4 audio/mpeg audio/x-ms-wma')"/>
		<sch:param name="required_element" value="audiomd:*"/>
		<sch:param name="mdtype_name" value="string('AudioMD')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="VideoMD_file" is-a="required_metadata_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('video/jpeg2000 video/mp4 video/dv video/mpeg video/x-ms-wmv')"/>
		<sch:param name="required_element" value="videomd:*"/>
		<sch:param name="mdtype_name" value="string('VideoMD')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="NISOIMG_file" is-a="required_metadata_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('image/tiff image/jpeg image/jp2 image/png image/gif')"/>
		<sch:param name="required_element" value="mix:*"/>
		<sch:param name="mdtype_name" value="string('NISOIMG (MIX)')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	
</sch:schema>
