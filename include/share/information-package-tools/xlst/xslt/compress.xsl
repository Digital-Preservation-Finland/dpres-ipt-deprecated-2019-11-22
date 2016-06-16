<?xml version="1.0"?>
<!--
	XSD2SCH
	Compress Big Schematron. 
	1, handle same sch:extend
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:xs="http://www.w3.org/2001/XMLSchema"
							  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
							  xmlns:xhtml="http://www.w3.org/1999/xhtml">

<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

<xsl:variable name="version">v0.1</xsl:variable>	

<xsl:template match="/">
	<xsl:apply-templates />
</xsl:template>

<!-- ===========================================================
 Handle contexts with no "/" 
     =========================================================== -->

<!-- match the first rule that has only one child and which is the first
rule that extends that particular element -->

<xsl:template match=
    "sch:pattern/sch:rule
    [@context]
    [not(contains(@context, '/'))]
    [count(sch:extends) = 1 and count(*) = 1]
    [not(preceding-sibling::sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "13" >			
    <sch:rule>
		<xsl:attribute name="context">
			<!-- merge all the contexts into an | list -->
			<xsl:for-each select=
			"../sch:rule[count(sch:extends) = 1 and count(*) = 1]
				[@context]
				[sch:extends/@rule = current()/sch:extends/@rule]
				[not(contains(@context, '*'))]
				[not(contains(@context, '/'))]">
				<!-- <xsl:text>(</xsl:text> -->
				<xsl:value-of select="@context"/>
				<!-- <xsl:text>)</xsl:text> -->
				<!-- don't generate the | the first time-->
				<xsl:if test="not(position() = last())"> | </xsl:if>
			</xsl:for-each>
		</xsl:attribute>
		<xsl:apply-templates/>
    </sch:rule>
 </xsl:template>

<!-- strip out the rules that have been merged -->
<xsl:template match=
    "sch:pattern/sch:rule
    [@context]
    [not(contains(@context, '/'))]
    [count(sch:extends) = 1 and count(*) = 1]
    [not(preceding-sibling::sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "8" />

<!-- ===========================================================
 Handle contexts with any "/" 
     =========================================================== -->


<!-- match the first rule that has only one child and which is the first
     rule that extends that particular element -->
<xsl:template match=
    "sch:pattern/sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [@context]
    [contains(@context, '/')]
	[not(contains(@context, '*'))]
    [not(preceding-sibling::sch:rule
    	[count(sch:extends)=1 and count(*) = 1]
    	[sch:extends/@rule=current()/sch:extends/@rule]  
		[@context]
    	[contains(@context, '/')])]" 
	priority = "10" >			<!-- I bet the bug is the sch:extends where something else than "=" should be used -->
    <sch:rule>
		<xsl:attribute name="context">
			<!-- merge all the contexts into an | list -->
			<xsl:for-each select=
			"../sch:rule[count(sch:extends)=1 and count(*) = 1]
				[@context]
				[contains(@context, '/')]
				[sch:extends/@rule = current()/sch:extends/@rule]
				[not(contains(@context, '*'))]">
				<!-- <xsl:text>(</xsl:text> -->
				<xsl:value-of select="@context"/>
				<!-- <xsl:text>)</xsl:text> -->
				<!-- don't generate the | the first time-->
				<xsl:if test="not(position() = last())"> | </xsl:if>
			</xsl:for-each>
		</xsl:attribute>
		<xsl:apply-templates/>
    </sch:rule>
 </xsl:template>

<!-- strip out the rules that have been merged -->
<xsl:template match=
    "sch:pattern/sch:rule[count(sch:extends) = 1 and count(*) = 1]
    [@context]
	[contains(@context, '/')]
    [not(preceding-sibling::rule[count(sch:extends)=1 and count(*) = 1]
    [sch:extends/@rule=current()/sch:extends/@rule])]
    [not(contains(@context, '*'))]"
	priority = "5" />


<!-- ===========================================================
 copy everything else
     =========================================================== -->
 
 <xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy> 
 </xsl:template>

</xsl:stylesheet>
