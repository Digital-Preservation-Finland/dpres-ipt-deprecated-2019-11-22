<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<!--
Validates various internal issues in METS metadata.
Juha Lehtonen 2013-07-08 : Initial version
-->

    <sch:title>METS internal inspection</sch:title>
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>

	<!-- Check that METS includes at least one agent with attribute values ROLE='CREATOR' and TYPE='ORGANIZATION' -->
    <sch:pattern name="MetsCreator">
        <sch:rule context="mets:metsHdr">
			<sch:assert test="mets:agent[@ROLE='CREATOR' and @TYPE='ORGANIZATION']">
				METS header requires atleast one agent where ROLE attribute is 'CREATOR' and TYPE attribute is 'ORGANIZATION'.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- Check that OTHERMDTYPE is used, if MDTYPE='OTHER' -->
    <sch:pattern name="WrapOtherType">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER']">
			<sch:assert test="@OTHERMDTYPE">
				If the value of a MDTYPE attribute is 'OTHER', then the OTHERMDTYPE attribute must be used
			</sch:assert>
		</sch:rule>
    </sch:pattern>
    
	<!-- Check that mdWrap element contains both CHECKSUM and CHECKSUMTYPE attributes or niether of them -->
	<sch:pattern name="WrapChecksum">
        <sch:rule context="mets:mdWrap">
            <sch:assert test="count(@CHECKSUM) = count(@CHECKSUMTYPE)">
                CHECKSUM attribute requires the use of CHECKSUMTYPE attribute (and vice versa) in &lt;mdWrap&gt; element. The other of these attributes is missing.
            </sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that file element contains both CHECKSUM and CHECKSUMTYPE attributes or niether of them -->
	<sch:pattern name="FileChecksum">
        <sch:rule context="mets:file">
            <sch:assert test="count(@CHECKSUM) = count(@CHECKSUMTYPE)">
                CHECKSUM attribute requires the use of CHECKSUMTYPE attribute (and vice versa) in &lt;file&gt; element. The other of these attributes is missing.
            </sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that descriptive metadata has a reference -->
	<sch:pattern name="IDReferencesDesc">
		<sch:rule context="mets:dmdSec">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:div/@DMDID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				The ID attribute in element &lt;dmdSec&gt; must be referenced in DMDID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that technical metadata has a reference -->
	<sch:pattern name="IDReferencesTech">
        <sch:rule context="mets:techMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count(ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) = 1">
				The ID attribute in element &lt;techMD&gt; must be referenced in ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that rights metadata has a reference -->
	<sch:pattern name="IDReferencesRights">
        <sch:rule context="mets:rightsMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				The ID attribute in element &lt;rightsMD&gt; must be referenced in ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that source metadata has a reference -->
	<sch:pattern name="IDReferencesSource">
        <sch:rule context="mets:sourceMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				The ID attribute in element &lt;sourceMD&gt; must be referenced in ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that provenance metadata has a reference -->
	<sch:pattern name="IDReferencesProv">
        <sch:rule context="mets:digiprovMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) &gt; 0">
				The ID attribute in element &lt;digiprovMD&gt; must be referenced in ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that files have a reference -->
	<sch:pattern name="IDReferencesFile">
        <sch:rule context="mets:file">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count((ancestor::mets:mets//mets:fptr[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) | 
								(ancestor::mets:mets//mets:area[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))])) &gt; 0">
				The ID attribute in element &lt;file&gt; must be referenced in FILEID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that either FILEID attribute or area element is used in fptr element, but not both -->
	<sch:pattern name="IDReferencesFptrArea">
        <sch:rule context="mets:fptr[@FILEID]">
			<sch:assert test="not(.//mets:area)">
				If &lt;area&gt; element is used inside &lt;fprt&gt; element, then FILEID attribute should not be used in &lt;fprt&gt; element.
			</sch:assert>
        </sch:rule>
        <sch:rule context="mets:fptr">
			<sch:assert test=".//mets:area or @FILEID">
				Either &lt;area&gt; element or FILEID attribute should be used inside &lt;fprt&gt; element.
			</sch:assert>
        </sch:rule>		
	</sch:pattern>	
	
</sch:schema>
