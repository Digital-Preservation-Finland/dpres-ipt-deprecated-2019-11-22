<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
	<sch:title>Music Collection Schema</sch:title>
    <sch:pattern name="all">
		<sch:rule context="/">
        	<sch:assert test="mets:mets">
            	Root element must be mets:mets
            </sch:assert>
        </sch:rule>
	</sch:pattern>
</sch:schema>
			        