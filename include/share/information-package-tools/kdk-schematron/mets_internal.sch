<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>METS internal validation</sch:title>

<!--
Validates METS metadata elements and attributes, their values, and METS internal linking.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>

	<sch:include href="./abstracts/deprecated_value_attribute_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_attribute_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_or_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_xor_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_or_element_pattern.incl"/>
	<sch:include href="./abstracts/required_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_element_or_element_pattern.incl"/>
	<sch:include href="./abstracts/required_element_pattern.incl"/>
	<sch:include href="./abstracts/required_max_elements_pattern.incl"/>
	<sch:include href="./abstracts/required_specification_pattern.incl"/>
	<sch:include href="./abstracts/required_values_attribute_pattern.incl"/>
	<sch:include href="./abstracts/unique_value_attribute_pattern.incl"/>
	<sch:include href="./abstracts/required_agent_pattern.incl"/>
	<sch:include href="./abstracts/required_nonempty_attribute_pattern.incl"/>

	<!-- Specification attributes -->
	<sch:pattern id="mets_CATALOG_SPECIFICATION" is-a="required_attribute_or_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute1" value="@fi:CATALOG"/>
		<sch:param name="required_attribute2" value="@fi:SPECIFICATION"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_specification" is-a="required_specification_pattern">
		<sch:param name="required_condition" value="normalize-space(@fi:CATALOG) = normalize-space(@fi:SPECIFICATION)
			or (normalize-space(@fi:CATALOG)='1.4.1' and normalize-space(@fi:SPECIFICATION)='1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets141_CATALOG_deprecated" is-a="deprecated_value_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@fi:CATALOG"/>
		<sch:param name="deprecated_value" value="string('1.4.1')"/>		
		<sch:param name="valid_values" value="string('1.5.0')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets14_CATALOG_deprecated" is-a="deprecated_value_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@fi:CATALOG"/>
		<sch:param name="deprecated_value" value="string('1.4')"/>		
		<sch:param name="valid_values" value="string('1.5.0')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_SPECIFICATION_deprecated" is-a="deprecated_value_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@fi:SPECIFICATION"/>
		<sch:param name="deprecated_value" value="string('1.4')"/>		
		<sch:param name="valid_values" value="string('1.5.0')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS root attributes -->
	<sch:pattern id="mets_OBJID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OBJID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_OBJID_value" is-a="required_nonempty_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OBJID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<sch:pattern id="mets_PROFILE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@PROFILE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_PROFILE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@PROFILE"/>
		<sch:param name="valid_values" value="string('http://www.kdk.fi/kdk-mets-profile')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS root elements -->
	<sch:pattern id="mets_metsHdr" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:metsHdr"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:dmdSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:amdSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_amdSec_max" is-a="required_max_elements_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:amdSec"/>
		<sch:param name="num" value="1"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_structMap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:structMap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_structLink" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:structLink"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_behaviorSec" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:behaviorSec"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS Header attributes -->
	<sch:pattern id="mets_metsHdr_CREATEDATE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@CREATEDATE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_RECORDSTATUS_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@RECORDSTATUS"/>
		<sch:param name="valid_values" value="string('submission')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS Header agent -->
	<sch:pattern id="mets_metsHdr_agent" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:agent"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_agent_ROLE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr/mets:agent"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@ROLE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_agent_TYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:metsHdr/mets:agent"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@TYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_agent_creator" is-a="required_agent_pattern">
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="role" value="string('CREATOR')"/>
		<sch:param name="type" value="string('ORGANIZATION')"/>		
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS Header elements -->
	<sch:pattern id="mets_metsHdr_altRecordID" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:metsHdr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:altRecordID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS amdSec elements -->
	<sch:pattern id="mets_amdSec_techMD" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:amdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:techMD"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_digiprovMD" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:amdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:digiprovMD"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- mdWrap and mdRef elements -->
	<sch:pattern id="mets_dmdSec_mdWrap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:mdWrap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_mdRef" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:dmdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_techMD_mdWrap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:techMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:mdWrap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_techMD_mdRef" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:techMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_mdWrap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:mdWrap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_mdRef" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:rightsMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_sourceMD_mdWrap" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:sourceMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:mdWrap"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_sourceMD_mdRef" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:sourceMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_digiprovMD_mdWrap_mdRef" is-a="required_element_or_element_pattern">
		<sch:param name="context_element" value="mets:digiprovMD"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element1" value="mets:mdWrap"/>
		<sch:param name="required_element2" value="mets:mdRef"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- dmdSec, techMD, rightsMD, sourceMD and digiprovMD attributes -->
	<sch:pattern id="mets_dmdSec_CREATED" is-a="required_attribute_xor_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute1" value="@CREATED"/>
		<sch:param name="required_attribute2" value="@fi:CREATED"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_CREATED" is-a="required_attribute_xor_attribute_pattern">
		<sch:param name="context_element" value="mets:amdSec/*"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute1" value="@CREATED"/>
		<sch:param name="required_attribute2" value="@fi:CREATED"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('MARC; DC; MODS; EAD; EAC-CPF; LIDO; VRA; DDI; OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_techMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('PREMIS:OBJECT; NISOIMG; TEXTMD; OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('PREMIS:RIGHTS; OTHER')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_rightsMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('METSRIGHTS; PREMIS:RIGHTS; OTHER')"/>
		<sch:param name="specifications" value="string('1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_digiprovMD_MDTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('PREMIS:EVENT; PREMIS:AGENT; OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_PID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec"/>
		<sch:param name="context_condition" value="@fi:PIDTYPE"/>
		<sch:param name="required_attribute" value="@fi:PID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_PID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:amdSec"/>
		<sch:param name="context_condition" value="@fi:PIDTYPE"/>
		<sch:param name="required_attribute" value="@fi:PID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_PIDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec"/>
		<sch:param name="context_condition" value="@fi:PID"/>
		<sch:param name="required_attribute" value="@fi:PIDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_amdSec_PIDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:amdSec/*"/>
		<sch:param name="context_condition" value="@fi:PID"/>
		<sch:param name="required_attribute" value="@fi:PIDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- mdWrap elements and attributes -->
	<sch:pattern id="mets_mdWrap_xmlData" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:xmlData"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdWrap_binData" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:binData"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_OTHERMDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER'"/>
		<sch:param name="required_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_no_OTHERMDTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)!='OTHER'"/>
		<sch:param name="disallowed_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdWrap_CHECKSUM" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="@CHECKSUMTYPE"/>
		<sch:param name="required_attribute" value="@CHECKSUM"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdWrap_CHECKSUMTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="@CHECKSUM"/>
		<sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
   	<sch:pattern id="mets_MDTYPEVERSION" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdWrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>

	<!-- Attribute MDTYPE version values -->
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_OBJECT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:OBJECT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MIX" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='NISOIMG'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_RIGHTS" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:rightsMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:RIGHTS'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EVENT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:EVENT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_AGENT" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='PREMIS:AGENT'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.1; 2.2; 2.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DC" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='DC'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('1.1')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MODS" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='MODS'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('3.0; 3.1; 3.2; 3.3; 3.4; 3.5; 3.6')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAD" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='EAD'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2002')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAC" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='EAC-CPF'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2010')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_LIDO" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='LIDO'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('1.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_VRA" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='VRA'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('4.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_DDI" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='DDI'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('3.2; 3.1; 2.5.1; 2.5; 2.1')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_MARC" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='MARC'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('marcxml=1.2;marc=marc21; marcxml=1.2;marc=finmarc')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_TEXTMD" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='TEXTMD'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('3.01a')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_AudioMD" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='AudioMD'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_VideoMD" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='VideoMD'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('2.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_ADDML" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:techMD/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='ADDML'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('8.2; 8.3')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_dmdSec_MDTYPEVERSION_values_EAD3" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:dmdSec/mets:mdWrap"/>
		<sch:param name="context_condition" value="normalize-space(@MDTYPE)='OTHER' and normalize-space(@OTHERMDTYPE)='EAD3'"/>
		<sch:param name="context_attribute" value="@MDTYPEVERSION"/>
		<sch:param name="valid_values" value="string('1.0.0')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>

	<!-- mdRef attributes -->
	<sch:pattern id="mets_mdRef_MDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@MDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERMDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_LOCTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@LOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERLOCTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_CHECKSUM" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="@CHECKSUMTYPE"/>
		<sch:param name="required_attribute" value="@CHECKSUM"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_CHECKSUMTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mdRef"/>
		<sch:param name="context_condition" value="@CHECKSUM"/>
		<sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- mdRef attribute values -->
	<sch:pattern id="mets_mdRef_MDTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@MDTYPE"/>
		<sch:param name="valid_values" value="string('OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERMDTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OTHERMDTYPE"/>
		<sch:param name="valid_values" value="string('KDKPreservationPlan')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_LOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('OTHER')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_OTHERLOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="valid_values" value="string('PreservationPlanID')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mdRef_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:digiprovMD/mets:mdRef"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- Elements and attributes inside fileSec -->
	<sch:pattern id="mets_fileGrp_file" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:fileGrp"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:file"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_ADMID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@ADMID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_CHECKSUM" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="@CHECKSUMTYPE"/>
		<sch:param name="required_attribute" value="@CHECKSUM"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_CHECKSUMTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="@CHECKSUM"/>
		<sch:param name="required_attribute" value="@CHECKSUMTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FLocat" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:FLocat"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FLocat_max" is-a="required_max_elements_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:FLocat"/>
		<sch:param name="num" value="1"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_FContent" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:FContent"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_stream" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:stream"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_file" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:file"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_file_transformFile" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="mets:transformFile"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- FLocat attributes -->
	<sch:pattern id="mets_FLocat_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_OTHERLOCTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_LOCTYPE" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('URL')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_FLocat_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:FLocat"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- StructMap div and attributes -->
	<sch:pattern id="mets_structMap_div" is-a="required_element_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:div"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_structMap_div_max" is-a="required_max_elements_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="mets:div"/>
		<sch:param name="num" value="1"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets14_structMap_PID" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="fi:PID"/>
		<sch:param name="specifications" value="string('1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets14_structMap_PIDTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="fi:PIDTYPE"/>
		<sch:param name="specifications" value="string('1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_structMap_PID" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="@fi:PIDTYPE"/>
		<sch:param name="required_attribute" value="@fi:PID"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_structMap_PIDTYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:structMap"/>
		<sch:param name="context_condition" value="@fi:PID"/>
		<sch:param name="required_attribute" value="@fi:PIDTYPE"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="mets_div_TYPE" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:div"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@TYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- fptr and mptr attributes -->
	<sch:pattern id="mets_fptr_FILEID" is-a="required_attribute_or_element_pattern">
		<sch:param name="context_element" value="mets:fptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@FILEID"/>
		<sch:param name="required_element" value=".//mets:area"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>	
	<sch:pattern id="mets_mptr_href" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:href"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_type" is-a="required_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_attribute" value="@xlink:type"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_OTHERLOCTYPE" is-a="disallowed_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_attribute" value="@OTHERLOCTYPE"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_LOCTYPE_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@LOCTYPE"/>
		<sch:param name="valid_values" value="string('URL')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>
	<sch:pattern id="mets_mptr_type_values" is-a="required_values_attribute_pattern">
		<sch:param name="context_element" value="mets:mptr"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@xlink:type"/>
		<sch:param name="valid_values" value="string('simple')"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

	<!-- METS internal linking, cross-check part 1: From link to target -->
	<sch:let name="dmdids" value="//mets:dmdSec/@ID"/>
	<sch:let name="admids" value="//mets:amdSec/*[self::mets:techMD or self::mets:rightsMD or self::mets:sourceMD or self::mets:digiprovMD]/@ID"/>
	<sch:let name="fileids" value="//mets:file/@ID"/>
	<sch:pattern id="link_div_dmdid">
		<sch:rule context="mets:div[@DMDID]">
            <sch:assert test="(count(sets:distinct(str:tokenize(normalize-space(@DMDID),' ') | exsl:node-set($dmdids))) = count(sets:distinct(exsl:node-set($dmdids))))">
				Value '<sch:value-of select="@DMDID"/>' in attribute '<sch:value-of select="name(@DMDID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="link_file_admid">
		<sch:rule context="mets:file[@ADMID]">
            <sch:assert test="(count(sets:distinct(str:tokenize(normalize-space(@ADMID),' ') | exsl:node-set($admids))) = count(sets:distinct(exsl:node-set($admids))))">
				Value '<sch:value-of select="@ADMID"/>' in attribute '<sch:value-of select="name(@ADMID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="link_div_admid">
		<sch:rule context="mets:div[@ADMID]">
            <sch:assert test="(count(sets:distinct(str:tokenize(normalize-space(@ADMID),' ') | exsl:node-set($admids))) = count(sets:distinct(exsl:node-set($admids))))">
				Value '<sch:value-of select="@ADMID"/>' in attribute '<sch:value-of select="name(@ADMID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="link_fptr_fileid">
		<sch:rule context="mets:fptr[@FILEID]">
            <sch:assert test="(count(sets:distinct(str:tokenize(normalize-space(@FILEID),' ') | exsl:node-set($fileids))) = count(sets:distinct(exsl:node-set($fileids))))">
				Value '<sch:value-of select="@FILEID"/>' in attribute '<sch:value-of select="name(@FILEID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	<sch:pattern id="link_area_fileid">
		<sch:rule context="mets:area[@FILEID]">
            <sch:assert test="(count(sets:distinct(str:tokenize(normalize-space(@FILEID),' ') | exsl:node-set($fileids))) = count(sets:distinct(exsl:node-set($fileids))))">
				Value '<sch:value-of select="@FILEID"/>' in attribute '<sch:value-of select="name(@FILEID)"/>' in element '<sch:name/>' contains a link to nowhere. The corresponding target attribute '@ID' with the same value was not found.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS internal linking, cross-check part 2: From target to link -->
	<sch:let name="dmdidlinks" value="//mets:div"/>
	<sch:let name="admidfilelinks" value="//mets:file"/>
	<sch:let name="admiddivlinks" value="//mets:div"/>
	<sch:let name="fileidfptrlinks" value="//mets:fptr"/>
	<sch:let name="fileidarealinks" value="//mets:area"/>
	<sch:pattern name="IDReferencesDesc">
		<sch:rule context="mets:dmdSec">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count($dmdidlinks[contains(concat(' ', normalize-space(@DMDID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@DMDID'.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	<sch:pattern name="IDReferencesAdm">
        <sch:rule context="mets:techMD | mets:rightsMD | mets:sourceMD | mets:digiprovMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count($admidfilelinks[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0
			or count($admiddivlinks[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@ADMID'.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	<sch:pattern name="IDReferencesFile">
        <sch:rule context="mets:file">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count($fileidfptrlinks[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) &gt; 0
			or count($fileidarealinks[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Section containing value '<sch:value-of select="@ID"/>' in attribute '<sch:value-of select="name(@ID)"/>' in element '<sch:value-of select="name(.)"/>' requires a reference from attribute '@FILEID'.
			</sch:assert>
        </sch:rule>
	</sch:pattern>

	<!-- Check that OBJID attribute is unique with METS internal IDs -->
	<sch:pattern id="linked_OBJID" is-a="unique_value_attribute_pattern">
		<sch:param name="context_element" value="mets:mets"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="context_attribute" value="@OBJID"/>
		<sch:param name="another_context_attribute" value="@ID"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

</sch:schema>
