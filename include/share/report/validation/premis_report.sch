<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<!--
Validates various internal issues in PREMIS validation report.
See: http://www.loc.gov/standards/premis/
Juha Lehtonen 2014-03-26 : Initial version
-->

    <sch:title>PREMIS validation report inspection</sch:title>
	
	<sch:ns prefix="premis" uri="info:lc/xmlns/premis-v2"/>
	<sch:ns prefix="exsl" uri="http://exslt.org/common"/>
	
	<!-- 
	Constant values from PREMIS report. 
	NOTE: Some of these values have been hard coded in sch:rule element's context attribute, since variables do not seem work in there. Everywhere else these values are taken from these variables.
	-->
	
	<!-- All the node values here have been used as hard coded in content attribute -->
	<sch:let name="idtype" value="exsl:node-set('pas-transfer-id') | exsl:node-set('pas-sip-id') | exsl:node-set('pas-sig-id') | exsl:node-set('pas-mets-id') | exsl:node-set('pas-object-id') | exsl:node-set('pas-aip-id')"/>
	
	<!-- All the node values here have been used as hard coded in content attribute -->
	<sch:let name="eventtype" value="exsl:node-set('decompression') | exsl:node-set('virus check') | exsl:node-set('digital signature validation') | exsl:node-set('fixity check') | exsl:node-set('validation') | exsl:node-set('creation') | exsl:node-set('preservation responsibility change') | exsl:node-set('transfer')"/>
	
	<!-- Some of the node values here (values of indexes [5], [6], [7] and [8]) have been used as hard coded in content attribute -->
	<sch:let name="eventdetail" value="exsl:node-set('Decompression of transfer container')
		| exsl:node-set('Virus check of transferred files')
		| exsl:node-set('SIP digital signature validation')
		| exsl:node-set('Fixity check of digital objects in a SIP')
		| exsl:node-set('METS schema validation')
		| exsl:node-set('Additional METS validation of required features')
		| exsl:node-set('Digital object validation')
		| exsl:node-set('Validation compilation of a SIP')
		| exsl:node-set('Creation of AIP')
		| exsl:node-set('Preservation responsibility change to the DP system')
		| exsl:node-set('Transfer of a container that includes one or several submission information packages')
		| exsl:node-set('Validation compilation of a Transfer')"/>

	<!-- Constant values from PREMIS report. The values of these variables below are not used as hard coded anywhere. -->
	<sch:let name="idvalstart" value="exsl:node-set('pas-transfer-') | exsl:node-set('pas-sip-') | exsl:node-set('pas-sig-') | exsl:node-set('pas-mets-') | exsl:node-set('pas-object-') | exsl:node-set('pas-aip-')"/>
	<sch:let name="relationship" value="exsl:node-set('structural') | exsl:node-set('derivation') | exsl:node-set('is included in') | exsl:node-set('has source')"/>
	<sch:let name="agent" value="exsl:node-set('pas-agent-extractSIPTransfer')
		| exsl:node-set('pas-agent-archivematicaClamscan')
		| exsl:node-set('pas-agent-verifySIPSignature')
		| exsl:node-set('pas-agent-verifySIPFileChecksums')
		| exsl:node-set('pas-agent-verifyMetsSchemaFeatures')
		| exsl:node-set('pas-agent-verifyMetsRequiredFeatures')
		| exsl:node-set('pas-agent-check_sip_digital_objects')
		| exsl:node-set('pas-agent-createSIPInspectionReport')
		| exsl:node-set('pas-user-')"/>
	<sch:let name="filenames" value="exsl:node-set('varmiste.sig') | exsl:node-set('mets.xml')"/>
	<sch:let name="agenttype" value="exsl:node-set('software') | exsl:node-set('organization')"/>
	
	<!-- transfer object -->
    <sch:pattern name="TransferObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-transfer-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[1])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[1]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName">
				&lt;originalName&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="not(./premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="not(./premis:relationship)">
				&lt;relationship&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	<!-- sip object -->
    <sch:pattern name="SipObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-sip-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[2])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[2]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName">
				&lt;originalName&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:environment">
				&lt;environment&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="(.//premis:relationshipType=$relationship[1]) and (.//premis:relationshipSubType=$relationship[3])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='<sch:value-of select="$relationship[1]"/>' and relationshipSubType='<sch:value-of select="$relationship[3]"/>'.
			</sch:assert>
			<sch:assert test="(.//premis:relatedObjectIdentifierType=$idtype[1]) and contains(.//premis:relatedObjectIdentifierValue,$idvalstart[1])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a transfer object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- signature object -->
    <sch:pattern name="SigObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-sig-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[3])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[3]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName=$filenames[1]">
				Original name must be '<sch:value-of select="$filenames[1]"/>' in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>			
			<sch:assert test="not(./premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test=".//premis:relationshipType=$relationship[1] and .//premis:relationshipSubType=$relationship[3]">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='<sch:value-of select="$relationship[1]"/>' and relationshipSubType='<sch:value-of select="$relationship[3]"/>'
			</sch:assert>
			<sch:assert test="(.//premis:relatedObjectIdentifierType=$idtype[2]) and contains(.//premis:relatedObjectIdentifierValue,$idvalstart[2])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a sip object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>

	<!-- mets object -->
    <sch:pattern name="MetsObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-mets-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[4])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[4]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName=$filenames[2]">
				Original name must be '<sch:value-of select="$filenames[2]"/>' in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="not(./premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test=".//premis:relationshipType=$relationship[1] and .//premis:relationshipSubType=$relationship[3]">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='<sch:value-of select="$relationship[1]"/>' and relationshipSubType='<sch:value-of select="$relationship[3]"/>'
			</sch:assert>
			<sch:assert test="(.//premis:relatedObjectIdentifierType=$idtype[2]) and contains(.//premis:relatedObjectIdentifierValue,$idvalstart[2])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a sip object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
	
	<!-- digital object -->
	<sch:pattern name="FileObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-object-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[5])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[5]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName">
				Original name must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>			
			<sch:assert test="./premis:environment">
				&lt;environment&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test="./premis:relationship">
				&lt;relationship&gt; element must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>			
			<sch:assert test=".//premis:relationshipType=$relationship[1] and .//premis:relationshipSubType=$relationship[3]">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='<sch:value-of select="$relationship[1]"/>' and relationshipSubType='<sch:value-of select="$relationship[3]"/>'
			</sch:assert>
			<sch:assert test="(.//premis:relatedObjectIdentifierType=$idtype[2]) and contains(.//premis:relatedObjectIdentifierValue,$idvalstart[2])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a sip object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>
	
	<!-- aip object -->
	<sch:pattern name="AipObject">
        <sch:rule context="premis:object[.//premis:objectIdentifierType='pas-aip-id']">
			<sch:assert test="contains(.//premis:objectIdentifierValue,$idvalstart[6])">
				Wrong id type '<sch:value-of select=".//premis:objectIdentifierValue"/>'. The type must be '<sch:value-of select="$idtype[6]"/>'.
			</sch:assert>
			<sch:assert test="./premis:originalName">
				Original name must be used in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>		
			<sch:assert test="not(.//premis:environment)">
				&lt;environment&gt; element not allowed in '<sch:value-of select=".//premis:objectIdentifierValue"/>'.
			</sch:assert>
			<sch:assert test=".//premis:relationshipType=$relationship[2] and .//premis:relationshipSubType=$relationship[4]">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have values relationshipType='<sch:value-of select="$relationship[2]"/>' and relationshipSubType='<sch:value-of select="$relationship[4]"/>'
			</sch:assert>
			<sch:assert test="(.//premis:relatedObjectIdentifierType=$idtype[2]) and contains(.//premis:relatedObjectIdentifierValue,$idvalstart[2])">
				Object '<sch:value-of select=".//premis:objectIdentifierValue"/>' must have relation to a sip object.
			</sch:assert>			
		</sch:rule>	
	</sch:pattern>

	<!-- Ingestion event inspection -->
	<sch:pattern name="EventIngestion">
        <sch:rule context="premis:event[./premis:eventType='ingestion']">
			<sch:assert test="./premis:eventDetail=$eventdetail[11]">
				Ingestion event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[11]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[9])">
				Ingestion event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a ingestion user agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[1]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[1])">
				Ingestion event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a transfer object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>
	
	<!-- Decompression event inspection -->
	<sch:pattern name="EventDecompression">
        <sch:rule context="premis:event[./premis:eventType='decompression']">
			<sch:assert test="./premis:eventDetail=$eventdetail[1]">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[1]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[1])">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a decompression agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[1]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[1])">
				Decompression event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a transfer object.
			</sch:assert>
		</sch:rule>	
	</sch:pattern>

	<!-- Virus check event inspection -->
	<sch:pattern name="EventVirusCheck">
        <sch:rule context="premis:event[./premis:eventType='virus check']">
			<sch:assert test="./premis:eventDetail=$eventdetail[2]">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[2]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[2])">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a virus check agent.
			</sch:assert>
			<sch:assert test="((.//premis:linkingObjectIdentifierType=$idtype[1]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[1])) or ((.//premis:linkingObjectIdentifierType=$idtype[2]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[2]))">
				Virus check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a transfer or a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Signature validation event inspection -->
	<sch:pattern name="EventSignatureCheck">
        <sch:rule context="premis:event[./premis:eventType='digital signature validation']">
			<sch:assert test="./premis:eventDetail=$eventdetail[3]">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[3]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[3])">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a signature validation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[3]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[3])">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a signature object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Fixity check event inspection -->
	<sch:pattern name="EventFixityCheck">
        <sch:rule context="premis:event[./premis:eventType='fixity check']">
			<sch:assert test="./premis:eventDetail=$eventdetail[4]">
				Digital signature validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[4]"/>'
			</sch:assert>		
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[4])">
				Fixity check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a fixity check agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[2]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[2])">
				Fixity check event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS schema validation event inspection -->
	<sch:pattern name="EventMetsSchemaCheck">
        <sch:rule context="premis:event[./premis:eventType='validation' and ./premis:eventDetail='METS schema validation']">
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[5])">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a METS validation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[4]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[4])">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- METS additional validation event inspection -->
	<sch:pattern name="EventMetsAdditionalCheck">
        <sch:rule context="premis:event[./premis:eventType='validation' and ./premis:eventDetail='Additional METS validation of required features']">
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[6])">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a METS validation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[4]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[4])">
				METS validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a METS object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Digital object validation event inspection -->
	<sch:pattern name="EventDigitalObjectValidation">
        <sch:rule context="premis:event[./premis:eventType='validation' and ./premis:eventDetail='Digital object validation']">
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[7])">
				Digital object validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a digital object validation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[5]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[5])">
				Digital object validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a digital object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- SIP validation compilation event inspection -->
	<sch:pattern name="EventSIPValidation">
        <sch:rule context="premis:event[./premis:eventType='validation' and ./premis:eventDetail='Validation compilation of a SIP']">
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[8])">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a inspection report creation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[2]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[2])">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- Transfer validation compilation event inspection -->
	<sch:pattern name="EventTransferValidation">
        <sch:rule context="premis:event[./premis:eventType='validation' and ./premis:eventDetail='Validation compilation of a Transfer']">
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[8])">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a inspection report creation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[1]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[8])">
				Overall SIP validation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a SIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- validation detail check -->
	<sch:pattern name="EventValidationDetail">
        <sch:rule context="premis:event[./premis:eventType='validation']">
			<sch:assert test="((./premis:eventDetail=$eventdetail[5]) or (./premis:eventDetail=$eventdetail[6])) or ((./premis:eventDetail=$eventdetail[7]) or (./premis:eventDetail=$eventdetail[8]) or (./premis:eventDetail=$eventdetail[12]))">
				Incorrect event detail in '<sch:value-of select=".//premis:eventIdentifierValue"/>'.
			</sch:assert>
		</sch:rule>		
	</sch:pattern>

	<!-- AIP creation event inspection -->
	<sch:pattern name="EventAIPCreation">
        <sch:rule context="premis:event[./premis:eventType='creation']">
			<sch:assert test="./premis:eventDetail=$eventdetail[9]">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[9]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[8])">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a inspection report creation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[6]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[6])">
				AIP creation event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a AIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- preservation responsibility change event inspection -->
	<sch:pattern name="EventResponsibilityChange">
        <sch:rule context="premis:event[./premis:eventType='preservation responsibility change']">
			<sch:assert test="./premis:eventDetail=$eventdetail[10]">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have an event detail: '<sch:value-of select="$eventdetail[10]"/>'
			</sch:assert>
			<sch:assert test="contains(.//premis:linkingAgentIdentifierValue,$agent[8])">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must have a inspection report creation agent.
			</sch:assert>
			<sch:assert test="(.//premis:linkingObjectIdentifierType=$idtype[6]) and contains(.//premis:linkingObjectIdentifierValue,$idvalstart[6])">
				Preservation responsibility change event '<sch:value-of select=".//premis:eventIdentifierValue"/>' must link to a AIP object.
			</sch:assert>
		</sch:rule>
	</sch:pattern>
	
	<!-- agent name -->
	<sch:pattern name="AgentName">
        <sch:rule context="premis:agent">
			<sch:assert test="contains(.//premis:agentIdentifierValue, ./premis:agentName)">
				agentIdentifierValue '<sch:value-of select=".//premis:agentIdentifierValue"/>' must contain agent name '<sch:value-of select="./premis:agentName"/>'
			</sch:assert>
			<sch:assert test="(contains(.//premis:agentIdentifierValue, $agent[9]) and .//premis:agentType=$agenttype[2]) or (.//premis:agentType=$agenttype[1])">
				agentIdentifierValue '<sch:value-of select=".//premis:agentIdentifierValue"/>' must has illegal agent type
			</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- PREMIS object ID inspection -->
	<sch:pattern name="ObjectID">
        <sch:rule context="premis:objectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS object identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS object identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
		</sch:rule>		
        <sch:rule context="premis:linkingObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the linking object identifier.
			</sch:assert>
        </sch:rule>
        <sch:rule context="premis:relatedObjectIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the related object identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>
	
	<!-- PREMIS event ID inspection -->
	<sch:pattern name="EventID">
        <sch:rule context="premis:eventIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS event identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS event identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>		
	</sch:pattern>
	
	<!-- PREMIS agent ID inspection -->
	<sch:pattern name="AgentID">
        <sch:rule context="premis:agentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:objectIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another object identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:eventIdentifierValue[normalize-space(.) = $id]) = 0">
            	The PREMIS agent identifiers must be unique. Another event identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) = 1">
            	The PREMIS agent identifiers must be unique. Another agent identifier with the same value '<sch:value-of select="."/>' exists in Premis.
			</sch:assert>
        </sch:rule>
        <sch:rule context="premis:linkingAgentIdentifierValue">
			<sch:let name="id" value="normalize-space(.)"/>
            <sch:assert test="count(ancestor::premis:premis//premis:agentIdentifierValue[normalize-space(.) = $id]) > 0">
            	Missing target '<sch:value-of select="."/>' with the linking agent identifier.
			</sch:assert>
        </sch:rule>
	</sch:pattern>

	
</sch:schema>
