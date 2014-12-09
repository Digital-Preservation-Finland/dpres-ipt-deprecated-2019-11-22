<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.4.1">
    <sch:title>METS external metadata type check</sch:title>

<!--
Validates that the used metadata type inside mdWrap element is same as defined in MDTYPE or OTHRERMDTYPE attribute.
Juha Lehtonen 2013-07-08 : Initial version
Juha Lehtonen 2013-07-17 : LIDO bugfix
Juha Lehtonen 2014-04-15 : Technical metadata presence check added. Schema version added.
Juha Lehtonen 2014-12-09 : Decriptive metadata standard portfolio format check moved from schema to here.
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
	<sch:ns prefix="ddilc" uri="ddi:instance:3_1"/>
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
				MDTYPE attribute is 'PREMIS:OBJECT', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
    <!-- Check the case PREMIS:EVENT -->
	<sch:pattern name="CheckPremisEvent">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:EVENT']">
			<sch:assert test="mets:xmlData/premis:event">
				MDTYPE attribute is 'PREMIS:EVENT', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case PREMIS:AGENT -->
	<sch:pattern name="CheckPremisAgent">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:AGENT']">
			<sch:assert test="mets:xmlData/premis:agent">
				MDTYPE attribute is 'PREMIS:AGENT', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Check the case METSRIGHTS -->
	<sch:pattern name="CheckMetsrights">
		<sch:rule context="mets:mdWrap[@MDTYPE='METSRIGHTS']">
			<sch:assert test="mets:xmlData/metsrights:*">
				MDTYPE attribute is 'METSRIGHTS', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Check the case PREMIS:RIGHTS -->
	<sch:pattern name="CheckPremisRights">
		<sch:rule context="mets:mdWrap[@MDTYPE='PREMIS:RIGHTS']">
			<sch:assert test="mets:xmlData/premis:rights">
				MDTYPE attribute is 'PREMIS:RIGHTS', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- Check the case NISOIMG (MIX) -->
	<sch:pattern name="CheckMix">
        <sch:rule context="mets:mdWrap[@MDTYPE='NISOIMG']">
			<sch:assert test="mets:xmlData/mix:*">
				MDTYPE attribute is 'NISOIMG', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case TEXTMD -->
	<sch:pattern name="CheckTextMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='TEXTMD']">
			<sch:assert test="mets:xmlData/textmd:*">
				MDTYPE attribute is 'TEXTMD', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case AudioMD -->
	<sch:pattern name="CheckAudioMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @MDTYPEOTHER='AudioMD']">
			<sch:assert test="mets:xmlData/audiomd:*">
				MDTYPEOTHER attribute is 'AudioMD', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case VideoMD -->
	<sch:pattern name="CheckVideoMD">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER' and @MDTYPEOTHER='VideoMD']">
			<sch:assert test="mets:xmlData/videomd:*">
				MDTYPEOTHER attribute is 'VideoMD', but the contained XML data is something else.
			</sch:assert>
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
			<sch:assert test="($lido_count + $eac_count + $ead_count + $vra_count + $mods_count + $marc_count + $dc_count + $ddi_count + $en15744_count + $en15907_count) > 0">
				Descriptive metadata with one of the formats listed in the Standard portfolio does not exist.
			</sch:assert>
		</sch:rule>
    </sch:pattern>
	
	
	<!-- Check the case LIDO -->
	<sch:pattern name="CheckLido">
        <sch:rule context="mets:mdWrap[@MDTYPE='LIDO']">
			<sch:assert test="(mets:xmlData/lido:lido) | (mets:xmlData/lido:lidoWrap)">
				MDTYPE attribute is 'LIDO', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case EAC-CPF -->
	<sch:pattern name="CheckEAC">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAC-CPF']">
			<sch:assert test="mets:xmlData/eac:eac-cpf">
				MDTYPE attribute is 'EAC-CPF', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case EAD -->
	<sch:pattern name="CheckEAD">
        <sch:rule context="mets:mdWrap[@MDTYPE='EAD']">
			<sch:assert test="mets:xmlData/ead:ead">
				MDTYPE attribute is 'EAD', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case VRA -->
	<sch:pattern name="CheckVraCore">
        <sch:rule context="mets:mdWrap[@MDTYPE='VRA']">
			<sch:assert test="(mets:xmlData/vra:vra) | (mets:xmlData/vra:collection) | (mets:xmlData/vra:work) | (mets:xmlData/vra:image)">
				MDTYPE attribute is 'VRA', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case MODS -->
	<sch:pattern name="CheckMods">
        <sch:rule context="mets:mdWrap[@MDTYPE='MODS']">
			<sch:assert test="(mets:xmlData/mods:mods) | (mets:xmlData/mods:modsCollection)">
				MDTYPE attribute is 'MODS', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case MARC -->
	<sch:pattern name="CheckMarc">
        <sch:rule context="mets:mdWrap[@MDTYPE='MARC']">
			<sch:assert test="(mets:xmlData/marc21:record) | (mets:xmlData/marc21:collection)">
				MDTYPE attribute is 'MARC', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case DC -->
	<sch:pattern name="CheckDC">
        <sch:rule context="mets:mdWrap[@MDTYPE='DC']">
			<sch:assert test="mets:xmlData/dc:*">
				MDTYPE attribute is 'DC', but the contained XML data is something else.
			</sch:assert>
		</sch:rule>
    </sch:pattern>

	<!-- Check the case DDI -->
	<sch:pattern name="CheckDDI">
        <sch:rule context="mets:mdWrap[@MDTYPE='DDI']">
			<sch:assert test="(mets:xmlData/ddilc:DDIInstance) | (mets:xmlData/ddilc:TranslationInformation) | (mets:xmlData/ddicb:*)">
				MDTYPE attribute is 'DDI', but the contained XML data is something else.
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
