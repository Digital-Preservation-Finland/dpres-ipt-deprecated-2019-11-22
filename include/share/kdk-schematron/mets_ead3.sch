<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" schemaVersion="1.5.0">
	<sch:title>EAD3 metadata validation</sch:title>

<!--
Validates EAD3 metadata.
-->

	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="fi" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>
	<sch:ns prefix="ead3" uri="http://ead3.archivists.org/schema/"/>

	<sch:include href="./abstracts/disallowed_element_pattern.incl"/>

	<!-- 
	Some schema validators refuse to choose between ##other and ##local namespaces.
	The EAD3 schema was changed so that it allows ##any namespace, allowing also EAD3 metadata.
	This validation disallows the EAD3 metadata.
	-->
	<sch:pattern id="ead3_external" is-a="disallowed_element_pattern">
		<sch:param name="context_element" value="ead3:objectxmlwrap"/>
		<sch:param name="context_condition" value="true()"/>
		<sch:param name="disallowed_element" value="ead3:*"/>
		<sch:param name="specifications" value="string('')"/>
	</sch:pattern>

</sch:schema>
