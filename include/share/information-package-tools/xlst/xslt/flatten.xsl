<?xml version="1.0"?>
<!-- FLATTEN
	Extract each nested schema (the result of import from the previous INCLUDE stage)
	and put it at the top level in a <namespace> element. But only do it for the 
	first encountered schema for each namespace: no need for duplicates.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="/">
	<schemas>
		<xsl:for-each select="//xs:schema"> 
			<xsl:choose>
				<!-- strip out duplicates -->
				<!-- CX: I think it should be use @schemaLocation to judge if it is the same schema -->
				<xsl:when test="preceding::xs:schema[@targetNamespace=current()/@targetNamespace]">
					<xsl:comment>Duplicate schema import for <xsl:value-of select="@targetNamespace"/></xsl:comment>
				</xsl:when>
				<xsl:otherwise>
					<namespace uri="{@targetNamespace}"	schemaLocation="{@schemaLocation}">
						<xsl:attribute name="prefix">
						    <!-- memoize the current node -->
						    <xsl:variable name="schema" select="." as="node()" /> 
						    <!-- find the prefix used for the target namespace (what if two prefixes?) -->
						    <xsl:variable name="declaredPrefix">
						    	<xsl:for-each select="in-scope-prefixes(.)">
						    		<xsl:if test="namespace-uri-for-prefix(., $schema) 
						    		   = $schema/@targetNamespace"
						    		><xsl:value-of select="."/></xsl:if>
						    	</xsl:for-each>
						    </xsl:variable>
							<xsl:choose>
							    <!-- Try to use the prefix used by the schema -->
								<xsl:when test="not($declaredPrefix ='')">
								   <xsl:value-of select="$declaredPrefix" />
								</xsl:when> 
								
								<!-- build in some well-known cases -->
								<xsl:when test="@targetNamespace='http://www.w3.org/1999/xlink'">xlink</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/XML/1998/namespace'">xml</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/1998/Math/MathML'">mathml</xsl:when>
								<xsl:when test="@targetNamespace='http://www.w3.org/1999/xhtml'">xhtml</xsl:when>
								<xsl:otherwise>ns<xsl:value-of select="position()"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xs:schema>
							<xsl:copy-of select="@*[not(name()= 'schemaLocation')] | namespace::node()"/>
							<!-- copy over all child nodes except xs:schema inside xs:schema -->
							<xsl:copy-of select="*[not(self::xs:schema)]"/>
						</xs:schema>
					</namespace>
			</xsl:otherwise>
		   </xsl:choose>	
		</xsl:for-each>
	</schemas>
</xsl:template>
	
</xsl:stylesheet>

