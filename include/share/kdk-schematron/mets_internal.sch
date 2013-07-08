<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:title>Joku otsikko</sch:title>
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>

    <sch:pattern name="MetsCreator">
        <sch:rule context="mets:metsHdr">
			<sch:assert test="mets:agent[@ROLE='CREATOR' and @TYPE='ORGANIZATION']">
				Ei natsaa 2
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
    <sch:pattern name="WrapOtherType">
        <sch:rule context="mets:mdWrap[@MDTYPE='OTHER']">
			<sch:assert test="@OTHERMDTYPE">
				If the value of a MDTYPE attribute is 'OTHER', then the OTHERMDTYPE attribute must be used
			</sch:assert>
		</sch:rule>
    </sch:pattern>
    
	<sch:pattern name="WrapChecksum">
        <sch:rule context="mets:mdWrap">
            <sch:assert test="count(@CHECKSUM) = count(@CHECKSUMTYPE)">
                Ei natsaa
            </sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="FileChecksum">
        <sch:rule context="mets:file">
            <sch:assert test="count(@CHECKSUM) = count(@CHECKSUMTYPE)">
                Ei natsaa
            </sch:assert>
        </sch:rule>
	</sch:pattern>
    	
	<sch:pattern name="IDReferencesDesc">
		<sch:rule context="mets:dmdSec">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:div/@DMDID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa dmdid
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="IDReferencesTech">
        <sch:rule context="mets:techMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file|mets:div/@ADMID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa tech id				
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="IDReferencesRights">
        <sch:rule context="mets:rightsMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file|mets:div/@ADMID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa rights id				
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="IDReferencesSource">
        <sch:rule context="mets:sourceMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file|mets:div/@ADMID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa source id				
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="IDReferencesProv">
        <sch:rule context="mets:digiprovMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:file|mets:div/@ADMID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa digiprov id				
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<sch:pattern name="IDReferencesFile">
        <sch:rule context="mets:file">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count(ancestor::mets:mets//mets:fptr|mets:area/@FILEID[contains(concat(' ', normalize-space(), ' '), concat(' ', $id, ' '))]) &gt; 0">
				Ei natsaa file id				
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<sch:pattern name="IDReferencesFptrArea">
        <sch:rule context="mets:fptr">
			<sch:let name="id" value="normalize-space(@FILEID)"/>
            <sch:assert test="count(/mets:area/@FILEID[contains(normalize-space(), $id)]) = 0">
				Ei natsaa file id 2	
			</sch:assert>
        </sch:rule>
	</sch:pattern>	
	
</sch:schema>
