<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<!--
Validates various internal issues in METS metadata.
Juha Lehtonen 2013-07-08 : Initial version
Juha Lehtonen 2013-10-21 : CATALOG, SPECIFICATION, CREATED, PID, PIDTYPE attribute check added. FILEID check modified.
-->

    <sch:title>METS internal inspection</sch:title>
	
	<sch:ns prefix="mets" uri="http://www.loc.gov/METS/"/>
	<sch:ns prefix="kdk" uri="http://www.kdk.fi/standards/mets/kdk-extensions"/>

	<!-- Check that METS includes CATALOG or SPECIFICATION attribute -->
    <sch:pattern name="MetsCatalog">
        <sch:rule context="mets:mets">
			<sch:assert test="@kdk:CATALOG or @kdk:SPECIFICATION">
				METS root reqires attribute kdk:CATALOG or kdk:SPECIFICATION (or both) where the used KDK catalog or KDK METS specification version is defined, respectively.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- Check that METS includes at least one agent with attribute values ROLE='CREATOR' and TYPE='ORGANIZATION' -->
    <sch:pattern name="MetsCreator">
        <sch:rule context="mets:metsHdr">
			<sch:assert test="mets:agent[@ROLE='CREATOR' and @TYPE='ORGANIZATION']">
				METS header requires atleast one agent where ROLE attribute is 'CREATOR' and TYPE attribute is 'ORGANIZATION'.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	<!-- Check that METS includes CREATED or kdk:CREATED attribute -->
    <sch:pattern name="MetsCreatedDmd">
        <sch:rule context="mets:dmdSec">
			<sch:assert test="@CREATED or @kdk:CREATED">
				Use of CREATED or kdk:CREATED attribute is required.
			</sch:assert>
			<sch:assert test="not(@CREATED and @kdk:CREATED)">
				Both attributes CREATED and kdk:CREATED can not be used.
			</sch:assert>			
		</sch:rule>		
	</sch:pattern>
    <sch:pattern name="MetsCreatedTech">
        <sch:rule context="mets:techMD">
			<sch:assert test="@CREATED or @kdk:CREATED">
				Use of CREATED or kdk:CREATED attribute is required.
			</sch:assert>
			<sch:assert test="not(@CREATED and @kdk:CREATED)">
				Both attributes CREATED and kdk:CREATED can not be used.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsCreatedRights">
        <sch:rule context="mets:rightsMD">
			<sch:assert test="@CREATED or @kdk:CREATED">
				Use of CREATED or kdk:CREATED attribute is required.
			</sch:assert>
			<sch:assert test="not(@CREATED and @kdk:CREATED)">
				Both attributes CREATED and kdk:CREATED can not be used.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsCreatedSource">
        <sch:rule context="mets:sourceMD">
			<sch:assert test="@CREATED or @kdk:CREATED">
				Use of CREATED or kdk:CREATED attribute is required.
			</sch:assert>
			<sch:assert test="not(@CREATED and @kdk:CREATED)">
				Both attributes CREATED and kdk:CREATED can not be used.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsCreatedDigiprov">
        <sch:rule context="mets:digiprovMD">
			<sch:assert test="@CREATED or @kdk:CREATED">
				Use of CREATED or kdk:CREATED attribute is required.
			</sch:assert>
			<sch:assert test="not(@CREATED and @kdk:CREATED)">
				Both attributes CREATED and kdk:CREATED can not be used.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>

	<!-- Check that both PID and PIDTYPE are used or neither -->	
    <sch:pattern name="MetsPidDmd">
        <sch:rule context="mets:dmdSec">
			<sch:assert test="count(@kdk:PID) = count(@kdk:PIDTYPE)">
				PID attribute requires the use of PIDTYPE attribute (and vice versa).
			</sch:assert>
		</sch:rule>		
	</sch:pattern>
    <sch:pattern name="MetsPidTech">
        <sch:rule context="mets:techMD">
			<sch:assert test="count(@kdk:PID) = count(@kdk:PIDTYPE)">
				PID attribute requires the use of PIDTYPE attribute (and vice versa).
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsPidRights">
        <sch:rule context="mets:rightsMD">
			<sch:assert test="count(@kdk:PID) = count(@kdk:PIDTYPE)">
				PID attribute requires the use of PIDTYPE attribute (and vice versa).
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsPidSource">
        <sch:rule context="mets:sourceMD">
			<sch:assert test="count(@kdk:PID) = count(@kdk:PIDTYPE)">
				PID attribute requires the use of PIDTYPE attribute (and vice versa).
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
    <sch:pattern name="MetsPidDigiprov">
        <sch:rule context="mets:digiprovMD">
			<sch:assert test="count(@kdk:PID) = count(@kdk:PIDTYPE)">
				PID attribute requires the use of PIDTYPE attribute (and vice versa).
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
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;dmdSec&gt; must be referenced from DMDID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that technical metadata has a reference -->
	<sch:pattern name="IDReferencesTech">
        <sch:rule context="mets:techMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count((ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) | 
							(ancestor::mets:mets//mets:div[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))])) &gt; 0">
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;techMD&gt; must be referenced from ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that rights metadata has a reference -->
	<sch:pattern name="IDReferencesRights">
        <sch:rule context="mets:rightsMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count((ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) | 
							(ancestor::mets:mets//mets:div[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))])) &gt; 0">
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;rightsMD&gt; must be referenced from ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that source metadata has a reference -->
	<sch:pattern name="IDReferencesSource">
        <sch:rule context="mets:sourceMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count((ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) |
							(ancestor::mets:mets//mets:div[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))])) &gt; 0">
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;sourceMD&gt; must be referenced from ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that provenance metadata has a reference -->
	<sch:pattern name="IDReferencesProv">
        <sch:rule context="mets:digiprovMD">
			<sch:let name="id" value="normalize-space(@ID)"/>
			<sch:assert test="count((ancestor::mets:mets//mets:file[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))]) |
							(ancestor::mets:mets//mets:div[contains(concat(' ', normalize-space(@ADMID), ' '), concat(' ', $id, ' '))])) > 0">
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;digiprovMD&gt; must be referenced from ADMID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
    
	<!-- Check that files have a reference -->
	<sch:pattern name="IDReferencesFile">
        <sch:rule context="mets:file">
			<sch:let name="id" value="normalize-space(@ID)"/>
            <sch:assert test="count((ancestor::mets:mets//mets:fptr[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))]) | 
								(ancestor::mets:mets//mets:area[contains(concat(' ', normalize-space(@FILEID), ' '), concat(' ', $id, ' '))])) &gt; 0">
				The ID attribute '<sch:value-of select="$id"/>' in element &lt;file&gt; must be referenced from FILEID attribute.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that there's no ID value same as OBJID value -->
	<sch:pattern name="IDReferencesFile">
        <sch:rule context="mets:mets">
			<sch:let name="id" value="normalize-space(@OBJID)"/>
            <sch:assert test="not(normalize-space(//@ID) = $id)">
				ID attribute '<sch:value-of select="//@ID"/>' value must be different than OBJID attribute value.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- Check that either FILEID attribute or area element is used in fptr element, or both -->
	<sch:pattern name="IDReferencesFptrArea">
        <sch:rule context="mets:fptr">
			<sch:assert test=".//mets:area or @FILEID">
				Either FILEID attribute or &lt;area&gt; element should be used inside &lt;fprt&gt; element.
			</sch:assert>
        </sch:rule>		
	</sch:pattern>		
	
</sch:schema>
