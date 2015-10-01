<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.4.1">
    <sch:title>METS external metadata type validation</sch:title>

<!--
Validates that the used metadata type inside mdWrap element is same as defined in MDTYPE or OTHERMDTYPE attribute.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="mix" uri="http://www.loc.gov/mix/v20"/>
	<sch:ns prefix="textmd" uri="http://www.kdk.fi/standards/textmd"/>
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
	<sch:ns prefix="ddilc" uri="ddi:instance:3_2"/>
	<sch:ns prefix="ddicb" uri="ddi:codebook:2_5"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
    <sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<!-- Mimetypes that has requirements for metadata -->
	<sch:let name="textmd_types" value="string('application/xhtml+xml text/xml text/plain')"/>
	<sch:let name="audiomd_types" value="string('audio/x-aiff audio/x-wave audio/flac audio/aac audio/x-wav audio/mpeg audio/x-ms-wma')"/>
	<sch:let name="videomd_types" value="string('video/jpeg2000 video/mj2 video/dv video/mpeg video/x-ms-wmv')"/>
	<sch:let name="mix_types" value="string('image/tiff image/jpeg image/jp2 image/png image/gif')"/>
	
	<!-- Check the case PREMIS:OBJECT -->
    <sch:pattern name="CheckPremisObject">
        <sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:OBJECT']">
			<sch:assert test="mets:xmlData/premis:object">
				MDTYPE attribute is 'PREMIS:OBJECT'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/premis:object">
			<sch:assert test="../../@MDTYPE='PREMIS:OBJECT'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'PREMIS:OBJECT'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
    <!-- Check the case PREMIS:EVENT -->
	<sch:pattern name="CheckPremisEvent">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:EVENT']">
			<sch:assert test="mets:xmlData/premis:event">
				MDTYPE attribute is 'PREMIS:EVENT'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/premis:event">
			<sch:assert test="../../@MDTYPE='PREMIS:EVENT'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'PREMIS:EVENT'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case PREMIS:AGENT -->
	<sch:pattern name="CheckPremisAgent">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:AGENT']">
			<sch:assert test="mets:xmlData/premis:agent">
				MDTYPE attribute is 'PREMIS:AGENT'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/premis:agent">
			<sch:assert test="../../@MDTYPE='PREMIS:AGENT'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'PREMIS:AGENT'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case METSRIGHTS -->
	<sch:pattern name="CheckMetsrights">
		<sch:rule context="mets:mdWrap[@MDTYPE='METSRIGHTS']">
			<sch:let name="metsrights_count" value="count(mets:xmlData/metsrights:RightsDeclarationMD)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$metsrights_count = 1 and $real_count = 1">
				MDTYPE attribute is 'METSRIGHTS'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/metsrights:*">
			<sch:assert test="../../@MDTYPE='METSRIGHTS'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'METSRIGHTS'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Check the case PREMIS:RIGHTS -->
	<sch:pattern name="CheckPremisRights">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:RIGHTS']">
			<sch:let name="premisrights_count" value="count(mets:xmlData/premis:rights)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$premisrights_count = 1 and $real_count = 1">
				MDTYPE attribute is 'PREMIS:RIGHTS'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/premis:rights">
			<sch:assert test="../../@MDTYPE='PREMIS:RIGHTS'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'PREMIS:RIGHTS'.
			</sch:assert>
		</sch:rule>		
	</sch:pattern>
	
	<!-- Check the case NISOIMG (MIX) -->
	<sch:pattern name="CheckMix">
        <sch:rule context="mets:mdWrap[@MDTYPE='NISOIMG']">
			<sch:assert test="mets:xmlData/mix:mix">
				MDTYPE attribute is 'NISOIMG'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
 		<sch:rule context="mets:xmlData/mix:*">
			<sch:assert test="../../@MDTYPE='NISOIMG'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'NISOIMG'.
			</sch:assert>
		</sch:rule>
   </sch:pattern>

	<!-- Check the case TEXTMD -->
	<sch:pattern name="CheckTextMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='TEXTMD']">
			<sch:assert test="mets:xmlData/textmd:textMD">
				MDTYPE attribute is 'TEXTMD'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/textmd:*">
			<sch:assert test="../../@MDTYPE='TEXTMD'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'TEXTMD'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case AudioMD -->
	<sch:pattern name="CheckAudioMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @OTHERMDTYPE='AudioMD']">
			<sch:assert test="(mets:xmlData/audiomd:AUDIOMD) or (mets:xmlData/audiomd:AUDIOSRC)">
				OTHERMDTYPE attribute is 'AudioMD'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/audiomd:*">
			<sch:assert test="../../@MDTYPE='OTHER' and ../../@OTHERMDTYPE='AudioMD'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'OTHER' and OTHERMDTYPE attribute value '<sch:value-of select="../../@OTHERMDTYPE"/>' must be 'AudioMD'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case VideoMD -->
	<sch:pattern name="CheckVideoMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @OTHERMDTYPE='VideoMD']">
			<sch:assert test="(mets:xmlData/videomd:VIDEOMD) or (mets:xmlData/videomd:VIDEOSRC)">
				OTHERMDTYPE attribute is 'VideoMD'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/videomd:*">
			<sch:assert test="../../@MDTYPE='OTHER' and ../../@OTHERMDTYPE='VideoMD'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'OTHER' and OTHERMDTYPE attribute value '<sch:value-of select="../../@OTHERMDTYPE"/>' must be 'AudioMD'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case LIDO -->
	<sch:pattern name="CheckLido">
        <sch:rule context="mets:mdWrap[@MDTYPE='LIDO']">
			<sch:let name="lido_count" value="count(mets:xmlData/lido:lido) + count(mets:xmlData/lido:lidoWrap)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$lido_count = 1 and $real_count = 1">
				MDTYPE attribute is 'LIDO'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/lido:*">
			<sch:assert test="../../@MDTYPE='LIDO'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'LIDO'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case EAC-CPF -->
	<sch:pattern name="CheckEAC">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAC-CPF']">
			<sch:let name="eac_count" value="count(mets:xmlData/eac:eac-cpf)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$eac_count = 1 and $real_count = 1">
				MDTYPE attribute is 'EAC-CPF'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
		<sch:rule context="mets:xmlData/eac:*">
			<sch:assert test="../../@MDTYPE='EAC-CPF'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'EAC-CPF'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case EAD -->
	<sch:pattern name="CheckEAD">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAD']">
			<sch:let name="ead_count" value="count(mets:xmlData/ead:ead)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$ead_count = 1 and $real_count = 1">
				MDTYPE attribute is 'EAD'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
 		<sch:rule context="mets:xmlData/ead:*">
			<sch:assert test="../../@MDTYPE='EAD'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'EAD'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case VRA -->
	<sch:pattern name="CheckVraCore">
        <sch:rule context="mets:mdWrap[@MDTYPE='VRA']">
			<sch:let name="vra_count" value="count(mets:xmlData/vra:vra) + count(mets:xmlData/vra:collection) + count(mets:xmlData/vra:work) + count(mets:xmlData/vra:image)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$vra_count = 1 and $real_count = 1">
				MDTYPE attribute is 'VRA'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
  		<sch:rule context="mets:xmlData/vra:*">
			<sch:assert test="../../@MDTYPE='VRA'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'VRA'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case MODS -->
	<sch:pattern name="CheckMods">
        <sch:rule context="mets:mdWrap[@MDTYPE='MODS']">
			<sch:let name="mods_count" value="count(mets:xmlData/mods:mods) + count(mets:xmlData/mods:modsCollection)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$mods_count = 1 and $real_count = 1">
				MDTYPE attribute is 'MODS'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
   		<sch:rule context="mets:xmlData/mods:*">
			<sch:assert test="../../@MDTYPE='MODS'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'MODS'.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case MARC -->
	<sch:pattern name="CheckMarc">
        <sch:rule context="mets:mdWrap[@MDTYPE='MARC']">
			<sch:let name="marc_count" value="count(mets:xmlData/marc21:record) + count(mets:xmlData/marc21:collection)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$marc_count = 1 and $real_count = 1">
				MDTYPE attribute is 'MARC'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
  		<sch:rule context="mets:xmlData/marc21:*">
			<sch:assert test="../../@MDTYPE='MARC'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'MARC'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case DC -->
	<sch:pattern name="CheckDC">
        <sch:rule context="mets:mdWrap[@MDTYPE='DC']">
			<sch:let name="dc_count" value="count(mets:xmlData/dc:contributor) + count(mets:xmlData/dc:coverage) + count(mets:xmlData/dc:creator) + count(mets:xmlData/dc:date) + count(mets:xmlData/dc:description) + count(mets:xmlData/dc:format) + count(mets:xmlData/dc:identifier) + count(mets:xmlData/dc:language) + count(mets:xmlData/dc:publisher) + count(mets:xmlData/dc:relation) + count(mets:xmlData/dc:rights) + count(mets:xmlData/dc:source) + count(mets:xmlData/dc:subject) + count(mets:xmlData/dc:title) + count(mets:xmlData/dc:type)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="$real_count = $dc_count">
				MDTYPE attribute is 'DC'. The contained XML data must match to the given type.
			</sch:assert>
		</sch:rule>
  		<sch:rule context="mets:xmlData/dc:*">
			<sch:assert test="../../@MDTYPE='DC'">
				The MDTYPE attribute value '<sch:value-of select="../../@MDTYPE"/>' must be 'DC'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case DDI -->
	<sch:pattern name="CheckDDI">
        <sch:rule context="mets:mdWrap[@MDTYPE='DDI']">
			<sch:let name="ddilc_count" value="count(mets:xmlData/ddilc:DDIInstance) + count(mets:xmlData/ddilc:Fragment) + count(mets:xmlData/ddilc:FragmentInstance) + count(mets:xmlData/ddilc:TopLevelReference) + count(mets:xmlData/ddilc:TranslationInformation)"/>
			<sch:let name="ddicb_count" value="count(mets:xmlData/ddicb:codeBook)"/>
			<sch:let name="real_count" value="count(mets:xmlData/*)"/>
			<sch:assert test="($ddilc_count = $real_count) or (($ddicb_count = 1) and ($real_count = 1))">
				MDTYPE attribute is 'DDI'. The contained XML data must match to the given type, and it must have only one root element.
			</sch:assert>
		</sch:rule>
   		<sch:rule context="mets:xmlData/ddilc:*">
			<sch:assert test="../../@MDTYPE='DDI'">
				The MDTYPE attribute value must be 'DDI'.
			</sch:assert>
		</sch:rule>
   		<sch:rule context="mets:xmlData/ddicb:*">
			<sch:assert test="../../@MDTYPE='DDI'">
				The MDTYPE attribute value must be 'DDI'.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	<!-- Check for organizational specific metadata formats. -->
	<sch:pattern name="CheckOther">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER']">
			<!-- Check that allowed MDTYPE attribute values are not used in OTHERMDTYPE attribute. -->
			<sch:assert test="not(@OTHERMDTYPE='LIDO' or @OTHERMDTYPE='EAC-CPF' or @OTHERMDTYPE='EAD' or @OTHERMDTYPE='VRA' or @OTHERMDTYPE='MODS' or @OTHERMDTYPE='MARC' or @OTHERMDTYPE='DC' or @OTHERMDTYPE='PREMIS' or @OTHERMDTYPE='PREMIS:OBJECT' or @OTHERMDTYPE='PREMIS:RIGHTS' or @OTHERMDTYPE='PREMIS:EVENT' or @OTHERMDTYPE='PREMIS:AGENT' or @OTHERMDTYPE='METSRIGHTS' or @OTHERMDTYPE='TEXTMD' or @OTHERMDTYPE='NISOIMG')">
				OTHERMDTYPE attribute value '<sch:value-of select="@OTHERMDTYPE"/>' must be moved to MDTYPE attribute.
			</sch:assert>
			<!-- Check for organizational specific metadata formats. Prints out notification, but won't fail validation. -->
			<sch:report test="@OTHERMDTYPE!='AudioMD' and @OTHERMDTYPE!='VideoMD' and @OTHERMDTYPE!='EN15744' and @OTHERMDTYPE!='EN15907' and @OTHERMDTYPE!='FINMARC' and not(@OTHERMDTYPE='LIDO' or @OTHERMDTYPE='EAC-CPF' or @OTHERMDTYPE='EAD' or @OTHERMDTYPE='VRA' or @OTHERMDTYPE='MODS' or @OTHERMDTYPE='MARC' or @OTHERMDTYPE='DC' or @OTHERMDTYPE='PREMIS' or @OTHERMDTYPE='PREMIS:OBJECT' or @OTHERMDTYPE='PREMIS:RIGHTS' or @OTHERMDTYPE='PREMIS:EVENT' or @OTHERMDTYPE='PREMIS:AGENT' or @OTHERMDTYPE='METSRIGHTS' or @OTHERMDTYPE='TEXTMD' or @OTHERMDTYPE='NISOIMG')">
				Unsupported but allowed metadata format '<sch:value-of select="@OTHERMDTYPE"/>' found. Validation omitted by using basic XML syntax check.
			</sch:report>
		</sch:rule>
    </sch:pattern>

	<!-- Check for organizational specific metadata formats (sourceMD). Prints out notification, but won't fail validation. -->
	<sch:pattern name="CheckSourceOther">
        <sch:rule context="mets:sourceMD/mets:mdWrap">
			<sch:report test="@MDTYPE='LC-AV' or @MDTYPE='TEIHDR' or @MDTYPE='FGDC' or @MDTYPE='LOM' or @MDTYPE='ISO 19115:2003 NAP'">
				Unsupported but allowed metadata format '<sch:value-of select="@MDTYPE"/>' found. Validation omitted by using basic XML syntax check.
			</sch:report>
		</sch:rule>
    </sch:pattern>
	
	
	<!-- Check that Standard portfolio schema has been used for descriptive metadata -->
	<sch:pattern name="CheckPortfolio">
        <sch:rule context="mets:mets">
			<sch:let name="lido_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='LIDO'])"/>
			<sch:let name="eac_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='EAC-CPF'])"/>
			<sch:let name="ead_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='EAD'])"/>
			<sch:let name="vra_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='VRA'])"/>
			<sch:let name="mods_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='MODS'])"/>
			<sch:let name="marc_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='MARC'])"/>
			<sch:let name="dc_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='DC'])"/>
			<sch:let name="ddi_count" value="count(mets:dmdSec/mets:mdWrap[@MDTYPE='DDI'])"/>
			<sch:let name="en15744_count" value="count(mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='EN15744'])"/>
			<sch:let name="en15907_count" value="count(mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='EN15907'])"/>
			<sch:let name="finmarc_count" value="count(mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='FINMARC'])"/>
			<sch:assert test="($lido_count + $eac_count + $ead_count + $vra_count + $mods_count + $marc_count + $dc_count + $ddi_count + $en15744_count + $en15907_count + $finmarc_count) > 0">
				Descriptive metadata with atleast one of the formats listed in the Standard portfolio does not exist.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check that known rights, technical or provenance metadata is not used inside descriptive metadata section -->
	<sch:pattern name="CheckDMD">
        <sch:rule context="mets:dmdSec">
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/premis:rights) or (./mets:mdWrap/mets:xmlData/metsrights:*))">
				Rights metadata format must not be used inside descriptive metadata section.
			</sch:assert>
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/premis:object) or (./mets:mdWrap/mets:xmlData/textmd:*) or (./mets:mdWrap/mets:xmlData/audiomd:*) or (./mets:mdWrap/mets:xmlData/videomd:*))">
				Technical metadata format must not be used inside descriptive metadata section.
			</sch:assert>
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/premis:agent) or (./mets:mdWrap/mets:xmlData/premis:event))">
				Provenance metadata format must not be used inside descriptive metadata section.
			</sch:assert>			
		</sch:rule>
    </sch:pattern>
	
	<!-- Check that known descriptive, technical or provenance metadata is not used inside rights metadata section -->
	<sch:pattern name="CheckRights">
        <sch:rule context="mets:rightsMD">
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/lido:*) or (./mets:mdWrap/mets:xmlData/ead:*) or (./mets:mdWrap/mets:xmlData/eac:*) or (./mets:mdWrap/mets:xmlData/vra:*) or (./mets:mdWrap/mets:xmlData/mods:*) or (./mets:mdWrap/mets:xmlData/marc21:*) or (./mets:mdWrap/mets:xmlData/dc:*) or (./mets:mdWrap/mets:xmlData/ddilc:*) or (./mets:mdWrap/mets:xmlData/ddicb:*))">
				Descriptive metadata format must not be used inside rights metadata section.
			</sch:assert>
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/premis:object) or (./mets:mdWrap/mets:xmlData/textmd:*) or (./mets:mdWrap/mets:xmlData/audiomd:*) or (./mets:mdWrap/mets:xmlData/videomd:*))">
				Technical metadata format must not be used inside rights metadata section.
			</sch:assert>			
			<sch:assert test="not((./mets:mdWrap/mets:xmlData/premis:agent) or (./mets:mdWrap/mets:xmlData/premis:event))">
				Provenance metadata format must not be used inside rights metadata section.
			</sch:assert>			
		</sch:rule>
    </sch:pattern>
	
	<!-- Check the case textMD requirement -->
	<sch:let name="textmd_fileid" value=".//mets:techMD[contains(concat(' ', $textmd_types, ' '), concat(' ', .//premis:formatName, ' '))]/@ID"/>
	<sch:let name="textmd_mdids" value=".//mets:techMD[.//textmd:*]/@ID"/>
	<sch:let name="textmd_countfiles" value="count(sets:distinct(exsl:node-set($textmd_fileid)))"/>
	<sch:let name="textmd_countmd" value="count(sets:distinct(exsl:node-set($textmd_mdids)))"/>
	<sch:pattern name="CheckTextMDRequirement">
        <sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($textmd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($textmd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($textmd_countfiles+$countadm)=$countfilescomb) or not(($textmd_countmd+$countadm)=$countmdcomb)">
				Reference to textMD metadata missing from ADMID attribute in element &lt;mets:file&gt; for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case AudioMD requirement -->
	<sch:let name="audiomd_fileid" value=".//mets:techMD[contains(concat(' ', $audiomd_types, ' '), concat(' ', .//premis:formatName, ' '))]/@ID"/>
	<sch:let name="audiomd_mdids" value=".//mets:techMD[.//audiomd:*]/@ID"/>
	<sch:let name="audiomd_countfiles" value="count(sets:distinct(exsl:node-set($audiomd_fileid)))"/>
	<sch:let name="audiomd_countmd" value="count(sets:distinct(exsl:node-set($audiomd_mdids)))"/>
	<sch:pattern name="CheckAudioMDRequirement">
        <sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($audiomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($audiomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($audiomd_countfiles+$countadm)=$countfilescomb) or not(($audiomd_countmd+$countadm)=$countmdcomb)">
				Reference to AudioMD metadata missing from ADMID attribute in element &lt;mets:file&gt; for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case VideoMD requirement -->
	<sch:let name="videomd_fileid" value=".//mets:techMD[contains(concat(' ', $videomd_types, ' '), concat(' ', .//premis:formatName, ' '))]/@ID"/>
	<sch:let name="videomd_mdids" value=".//mets:techMD[.//videomd:*]/@ID"/>
	<sch:let name="videomd_countfiles" value="count(sets:distinct(exsl:node-set($videomd_fileid)))"/>
	<sch:let name="videomd_countmd" value="count(sets:distinct(exsl:node-set($videomd_mdids)))"/>
	<sch:pattern name="CheckVideoMDRequirement">
        <sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($videomd_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($videomd_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($videomd_countfiles+$countadm)=$countfilescomb) or not(($videomd_countmd+$countadm)=$countmdcomb)">
				Reference to VideoMD metadata missing from ADMID attribute in element &lt;mets:file&gt; for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case MIX requirement -->
	<sch:let name="mix_fileid" value=".//mets:techMD[contains(concat(' ', $mix_types, ' '), concat(' ', .//premis:formatName, ' '))]/@ID"/>
	<sch:let name="mix_mdids" value=".//mets:techMD[.//mix:*]/@ID"/>
	<sch:let name="mix_countfiles" value="count(sets:distinct(exsl:node-set($mix_fileid)))"/>
	<sch:let name="mix_countmd" value="count(sets:distinct(exsl:node-set($mix_mdids)))"/>
	<sch:pattern name="CheckMixRequirement">
        <sch:rule context="mets:file">
			<sch:let name="admids" value="normalize-space(@ADMID)"/>
			<sch:let name="countadm" value="count(sets:distinct(str:tokenize($admids, ' ')))"/>
			<sch:let name="countfilescomb" value="count(sets:distinct(exsl:node-set($mix_fileid) | str:tokenize($admids, ' ')))"/>
			<sch:let name="countmdcomb" value="count(sets:distinct(exsl:node-set($mix_mdids) | str:tokenize($admids, ' ')))"/>
			<sch:assert test="(($mix_countfiles+$countadm)=$countfilescomb) or not(($mix_countmd+$countadm)=$countmdcomb)">
				Reference to MIX metadata missing from ADMID attribute in element &lt;mets:file&gt; for file '<sch:value-of select="./mets:FLocat/@xlink:href"/>'
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
</sch:schema>
