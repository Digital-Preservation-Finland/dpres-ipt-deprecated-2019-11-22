<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
							  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
							  xmlns:xhtml="http://www.w3.org/1999/xhtml">
	
<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="xhtml:h1 | xhtml:H1" >
	<sch:p class="h1">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h2 | xhtml:H2" >
	<sch:p class="h2">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h3 | xhtml:H3" >
	<sch:p class="h3">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h4 | xhtml:H4" >
	<sch:p class="h4">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h5 | xhtml:H5" >
	<sch:p class="h5">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:h6 | xhtml:H6" >
	<sch:p class="h6">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<xsl:template match="xhtml:li | xhtml:LI" >
	<sch:p class="li">
		<xsl:apply-templates  />
	</sch:p>
</xsl:template>

<!-- both IE and firefox must cover , this is for firefox -->
<xsl:template match="xhtml:span | xhtml:SPAN" >
	<!-- for firefox -->
	<xsl:choose>
		<xsl:when test="contains(@style, 'font-weight: bold;')">
			<sch:emph>
				<xsl:value-of select="text()"/>
			</sch:emph>
		</xsl:when>
		<xsl:when test="contains(@style, 'font-style: italic;')">
			<sch:span class="italic">
				<xsl:value-of select="text()"/>
			</sch:span>
		</xsl:when>
		<xsl:when test="contains(@style, 'text-decoration: underline;')">
			<sch:span class="underline">
				<xsl:value-of select="text()"/>
			</sch:span>
		</xsl:when>
		<xsl:when test="@class = 'valueof'">
			<value-of xmlns="http://purl.oclc.org/dsdl/schematron">
				<xsl:attribute name="select">
					<xsl:value-of select="." />
				</xsl:attribute>
			</value-of>
		</xsl:when>
		<xsl:when test="@class = 'name'">
			<name xmlns="http://purl.oclc.org/dsdl/schematron">
				<xsl:attribute name="path">
					<xsl:value-of select="." />
				</xsl:attribute>
			</name>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="text()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- for IE -->
<xsl:template match="xhtml:strong | xhtml:STRONG" >
	<sch:emph>
		<xsl:value-of select="text()"/>
	</sch:emph>
</xsl:template>	

<xsl:template match="xhtml:em | xhtml:EM" >
	<sch:span class="italic">
		<xsl:value-of select="text()"/>
	</sch:span>
</xsl:template>	

<xsl:template match="xhtml:u | xhtml:U" >
	<sch:span class="underline">
		<xsl:value-of select="text()"/>
	</sch:span>
</xsl:template>

	
</xsl:stylesheet>

