<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>ADDML metadata validation</sch:title>

<!--
Validates ADDML metadata.
-->
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="addml" uri="http://www.arkivverket.no/standarder/addml"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	<sch:ns prefix="sets" uri="http://exslt.org/sets"/>
	<sch:ns prefix="str" uri="http://exslt.org/strings"/>
	
	<sch:include href="./abstracts/required_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/disallowed_element_smaller_version_pattern.incl"/>
	<sch:include href="./abstracts/required_element_format_specific_pattern.incl"/>

	<!-- Version differences check -->
	<sch:pattern id="addml_reference" is-a="required_element_smaller_version_pattern">
		<sch:param name="context_element" value="addml:dataset"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="required_element" value="addml:reference"/>
		<sch:param name="mdattribute" value="@OTHERMDTYPE"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="mdtype_version" value="string('8.3')"/>
	</sch:pattern>
	<sch:pattern id="addml_headerLevel" is-a="disallowed_element_smaller_version_pattern">
		<sch:param name="context_element" value="addml:recordDefinition"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="addml:headerLevel"/>
		<sch:param name="mdattribute" value="@OTHERMDTYPE"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="mdtype_version" value="string('8.3')"/>
	</sch:pattern>

	<!-- Mandatory elements --> 
	<sch:pattern id="addml_recordSeparator" is-a="required_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('text/csv')"/>
		<sch:param name="required_element" value="addml:recordSeparator"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>
	<sch:pattern id="addml_fieldSeparatingChar" is-a="required_element_format_specific_pattern">
		<sch:param name="context_element" value="mets:file"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="file_format" value="string('text/csv')"/>
		<sch:param name="required_element" value="addml:fieldSeparatingChar"/>
		<sch:param name="mdtype_name" value="string('ADDML')"/>		
		<sch:param name="specifications" value="string('not: 1.4.1; 1.4')"/>
	</sch:pattern>

</sch:schema>
