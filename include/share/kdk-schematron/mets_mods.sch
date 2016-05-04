<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>MODS metadata validation</sch:title>

<!--
Validates version differences from MODS metadata.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="mods" uri="http://www.loc.gov/mods/v3"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="xml" uri="http://www.w3.org/XML/1998/namespace"/>

	<sch:include href="./abstracts/deprecated_element_from_version_pattern.incl"/>
	<sch:include href="./abstracts/deprecated_value_attribute_from_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_from_version_pattern.incl"/>
	<sch:include href="./abstracts/required_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/required_subelements_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_value_attribute_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_value_element_smaller_version_pattern.incl"/>

	<!-- Version specific check from version 3.6 -->
	<sch:pattern id="mods36_extraterrestrialArea" is-a="disallowed_element_from_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:extraterrestrialArea"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_province" is-a="deprecated_element_from_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="deprecated_element" value="mods:province"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.6 -->
	<sch:pattern id="mods36_extraTerrestrialArea" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:extraTerrestrialArea"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_itemIdentifier" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:copyInformation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:itemIdentifier"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_nameIdentifier" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:nameIdentifier"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_recordInfoNote" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordInfo"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:recordInfoNote"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_cartographicExtension" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:cartographics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:cartographicExtension"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_otherType" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@otherType"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_otherTypeAuth" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@otherTypeAuth"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_otherTypeAuthURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@otherTypeAuthURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_otherTypeURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@otherTypeURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_space" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:nonSort"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xml:space"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_level" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic/*"/>
		<sch:param name="context_condition" value="not(self::mods:province)"/>
		<sch:param name="disallowed_attribute" value="@level"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_period" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic/*"/>
		<sch:param name="context_condition" value="not(self::mods:province)"/>
		<sch:param name="disallowed_attribute" value="@period"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic/*"/>
		<sch:param name="context_condition" value="not(self::mods:province)"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic/*"/>
		<sch:param name="context_condition" value="not(self::mods:province)"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>
	<sch:pattern id="mods36_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic/*"/>
		<sch:param name="context_condition" value="not(self::mods:province)"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.6')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.5 -->
	<sch:pattern id="mods35_altFormat" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo"/>
		<sch:param name="disallowed_attribute" value="@altFormat"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_contentType" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:abstract or self::mods:accessCondition or self::mods:tableOfContents or self::mods:titleInfo"/>
		<sch:param name="disallowed_attribute" value="@contentType"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_generator" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:classification"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@generator"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_typeURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:identifier or self::mods:note"/>
		<sch:param name="disallowed_attribute" value="@typeURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_typeURI_note" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalDescription/mods:note"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@typeURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_eventType" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:originInfo"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@eventType"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_unit" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalDescription/mods:extent"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@unit"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_otherType" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/mods:titleInfo"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@otherType"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	<sch:pattern id="mods35_authority_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageTerm"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@authority"/>
		<sch:param name="disallowed_value" value="string('rfc5646')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.5')"/>
	</sch:pattern>
	
	
	<!-- Version specific check from 3.4 -->
	<sch:pattern id="mods34_usage_values_deprecated" is-a="deprecated_value_attribute_from_version_pattern">
		<sch:param name="context_element" value="mods:url"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@usage"/>
		<sch:param name="deprecated_value" value="string('primary display')"/>
		<sch:param name="valid_values" value="string('primary')"/>		
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.4 -->
	<sch:pattern id="mods34_shareable" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="@shareable"/>
		<sch:param name="disallowed_attribute" value="@shareable"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_altRepGroup" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="@altRepGroup"/>
		<sch:param name="disallowed_attribute" value="@altRepGroup"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_authorityURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="@authorityURI"/>
		<sch:param name="disallowed_attribute" value="@authorityURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_valueURI" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="@valueURI"/>
		<sch:param name="disallowed_attribute" value="@valueURI"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_supplied" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="@supplied"/>
		<sch:param name="disallowed_attribute" value="@supplied"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_usage" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:classification or self::mods:language
			or self::mods:name or self::mods:subject or self::mods:titleInfo or self::mods:typeOfResource"/>
		<sch:param name="disallowed_attribute" value="@usage"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_languageOfCataloging_usage" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageOfCataloging"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@usage"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_genre_usage" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@usage"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_displayLabel" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:extension or self::mods:language or self::mods:location or self::mods:originInfo
			or self::mods:part or self::mods:physicalDescription or self::mods:recordInfo or self::mods:subject or self::mods:targetAudience
			or self::mods:typeOfResource"/>
		<sch:param name="disallowed_attribute" value="@displayLabel"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_genre_displayLabel" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@displayLabel"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_languageOfCataloging_displayLabel" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageOfCataloging"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@displayLabel"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_name_displayLabel" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@displayLabel"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_language" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:language or self::mods:location or self::mods:part"/>
		<sch:param name="disallowed_attribute" value="@language"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_languageOfCataloging_language" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageOfCataloging"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@language"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_language_scriptTerm" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:language"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@scriptTerm"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_languageOfCataloging_scriptTerm" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageOfCataloging"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@scriptTerm"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_nameTitleGroup" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:name | self::mods:titleInfo"/>
		<sch:param name="disallowed_attribute" value="@nameTitleGroup"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_cartographics_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:cartographics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_hierarchicalGeographic_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_temporal_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:temporal"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="mods:originInfo or self::mods:physicalDescription or self::mods:classification
			or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo
			or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents"/>
		<sch:param name="disallowed_attribute" value="@lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_name_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_genre_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_recordContentSource_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordContentSource"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_physicalLocation_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_xml_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="mods:originInfo or self::mods:physicalDescription or self::mods:classification
			or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo
			or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents"/>
		<sch:param name="disallowed_attribute" value="@xml:lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_name_xml_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xml:lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_genre_xml_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xml:lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_recordContentSource_xml_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordContentSource"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xml:lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_physicalLocation_xml_lang" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xml:lang"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_script" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="mods:originInfo or self::mods:physicalDescription or self::mods:classification
			or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo
			or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents"/>
		<sch:param name="disallowed_attribute" value="@script"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_name_script" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@script"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_genre_script" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@script"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_recordContentSource_script" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordContentSource"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@script"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_physicalLocation_script" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@script"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_transliteration" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="mods:originInfo or self::mods:physicalDescription or self::mods:classification
			or self::mods:identifier or self::mods:accessCondition or self::mods:recordInfo or self::mods:titleInfo
			or self::mods:targetAudience or self::mods:subject or self::mods:abstract or self::mods:tableOfContents"/>
		<sch:param name="disallowed_attribute" value="@transliteration"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_name_transliteration" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@transliteration"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_genre_transliteration" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@transliteration"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_recordContentSource_transliteration" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordContentSource"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@transliteration"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
   	<sch:pattern id="mods34_physicalLocation_transliteration" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@transliteration"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>

	<sch:pattern id="mods34_issuance_values1" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:issuance"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('single unit')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_issuance_values2" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:issuance"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('multipart monograph')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_issuance_values3" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:issuance"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('serial')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_issuance_values4" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:issuance"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('integrating resource')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_encoding_values1" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@encoding"/>
		<sch:param name="disallowed_value" value="string('temper')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_encoding_values2" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods//*"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@encoding"/>
		<sch:param name="disallowed_value" value="string('edtf')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_name_type_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@type"/>
		<sch:param name="disallowed_value" value="string('family')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_relatedItem_type_values1" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@type"/>
		<sch:param name="disallowed_value" value="string('references')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_relatedItem_type_values2" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:relatedItem"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@type"/>
		<sch:param name="disallowed_value" value="string('reviewOf')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>
	<sch:pattern id="mods34_usage_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:url"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@usage"/>
		<sch:param name="disallowed_value" value="string('primary')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.4')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.3 -->
	<sch:pattern id="mods33_authority" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:frequency"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@authority"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_href" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:href"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_role" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:role"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_arcrole" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:arcrole"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_title" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:title"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_show" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:show"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_physicalLocation_xlink_actuate" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@xlink:actuate"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_extraterrestrialArea" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:extraterrestrialArea"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_citySection" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:hierarchicalGeographic"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:citySection"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_shelfLocator" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:location"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:shelfLocator"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_holdingSimple" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:location"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:holdingSimple"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_location_holdingExternal" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:location"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:holdingExternal"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_recordInfo_holdingExternal" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:recordInfo"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:holdingExternal"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_languageTerm_authority_values" is-a="disallowed_value_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageTerm"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@authority"/>
		<sch:param name="disallowed_value" value="string('rfc4646')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_typeOfResource_values" is-a="disallowed_value_element_smaller_version_pattern">
	   	<sch:param name="context_element" value="mods:typeOfResource"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_extension" is-a="required_subelements_smaller_version_pattern">
		<sch:param name="context_element" value="mods:extension"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods33_accessCondition" is-a="required_subelements_smaller_version_pattern">
		<sch:param name="context_element" value="mods:accessCondition"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.2 -->
	<sch:pattern id="mods32_ID" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods/*"/>
		<sch:param name="context_condition" value="self::mods:note or self::mods:relatedItem or self::mods:part"/>
		<sch:param name="disallowed_attribute" value="@ID"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods32_note_ID" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalDescription/mods:note"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@ID"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods32_note" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:url"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@note"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>	
	<sch:pattern id="mods32_access" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:url"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@access"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods32_usage" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:url"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@usage"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>	
	<sch:pattern id="mods32_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:part"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>	
	<sch:pattern id="mods32_order" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:part"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@order"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>	
	<sch:pattern id="mods32_genre" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:subject"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:genre"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.3')"/>
	</sch:pattern>
	<sch:pattern id="mods32_digitalOrigin_values1" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:digitalOrigin"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('digitized microfilm')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.2')"/>
	</sch:pattern>
	<sch:pattern id="mods32_digitalOrigin_values2" is-a="disallowed_value_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:digitalOrigin"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_value" value="string('digitized other analog')"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.2')"/>
	</sch:pattern>

	<!-- Version specific check until smaller than 3.1 -->
	<sch:pattern id="mods31_genre_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:genre"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_dateOther_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:dateOther"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_form_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:form"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_physicalLocation_type" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:physicalLocation"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@type"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_language_objectPart" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:language"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@objectPart"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_languageOfCataloging_objectPart" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:languageOfCataloging"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@objectPart"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_displayLabel" is-a="disallowed_attribute_smaller_version_pattern">
		<sch:param name="context_element" value="mods:classification"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@displayLabel"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_part" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:mods"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mods:part"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_coordinates" is-a="required_element_smaller_version_pattern">
		<sch:param name="context_element" value="mods:cartographics"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mods:coordinates"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_titleInfo" is-a="required_subelements_smaller_version_pattern">
		<sch:param name="context_element" value="mods:titleInfo"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_name" is-a="required_subelements_smaller_version_pattern">
		<sch:param name="context_element" value="mods:name"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>
	<sch:pattern id="mods31_subject" is-a="required_subelements_smaller_version_pattern">
		<sch:param name="context_element" value="mods:subject"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="mdattribute" value="@MDTYPE"/>
		<sch:param name="mdtype_name" value="string('MODS')"/>		
		<sch:param name="mdtype_version" value="string('3.1')"/>
	</sch:pattern>


</sch:schema>
