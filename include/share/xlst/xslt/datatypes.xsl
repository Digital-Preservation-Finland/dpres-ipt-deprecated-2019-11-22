
<!--  
   Alternative implementation of type checking.
   Normally, we can just use the castable() function.  But this may be useful for some processors.
   Also, note that NOTATIONS and IDREFs may not be tested by default in some processors.
 --> 
 
<xsl:template name="generate-extended-datatypes">
	<xsl:param name="prefix" />
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-normalizedString')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-string')}"/>
	
		<sch:let name="whitespace-char-lf" value="'&#xa;'"/>
		<sch:let name="whitespace-char-cr" value="'&#xd;'"/>
		<sch:let name="whitespace-char-tab" value="'&#x9;'"/>

		<sch:assert test="not(contains(., $whitespace-char-lf))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>normalized string type value.</xsl:text>
		</sch:assert>
		<sch:assert test="not(contains(., $whitespace-char-cr))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>normalized string type value.</xsl:text>
		</sch:assert>
		<sch:assert test="not(contains(., $whitespace-char-tab))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>normalized string type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-token')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-normalizedString')}"/>
	
		<sch:let name="whitespace-char-space" value="'&#x20;'"/>
		
		<sch:assert test="not(starts-with(., $whitespace-char-space))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>token type value.</xsl:text>
		</sch:assert>
		<sch:assert test="not(ends-with(., $whitespace-char-space))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>token type value.</xsl:text>
		</sch:assert>
		<sch:assert test="not(contains(., concat($whitespace-char-space, $whitespace-char-space)))">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>token type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	  
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-language')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-token')}"/>
		
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>language type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NCName')}" >
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>NCName type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NMTOKEN')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>NMTOKEN type value.</xsl:text>
		</sch:assert>
	</sch:rule> 
	   
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ID')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>ID type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-IDREF')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>IDREF type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ENTITY')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-NCName')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>ENTITY type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<!-- ============ -->
	<!-- NUMBER TYPES -->
	<!-- ============ -->
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-nonPositiveInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>nonPositiveInteger type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-negativeInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-nonPositiveInteger')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>negativeInteger type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>unsignedInteger type value.</xsl:text>
		</sch:assert>
	</sch:rule>
		
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-positiveInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-nonNegativeInteger')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>positiveInteger type value.</xsl:text>
		</sch:assert>
	</sch:rule>
		
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-nonNegativeInteger')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedInteger')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>nonNegativeInteger type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedLong')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedInteger')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>unsignedLong type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedInt')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedLong')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>unsignedInt type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedShort')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedLong')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>token type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-unsignedByte')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-unsignedShort')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>unsignedByte type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-long')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-integer')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>long type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-int')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-long')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>int type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-short')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-int')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>short type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-byte')}" > 
		<sch:extends rule="{concat($prefix, '-xsd-datatype-short')}"/>
	
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>byte type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	
	<!-- ============================================== -->
	<!--  --> W3C XML SCHEMAS SIMPLE TYPES - LIST TYPES      -->
	<!--  --> One abstract rule per type.                    -->
	<!--  --> ============================================== --> 
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-IDREFS')}" > 
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>IDREFS type value.</xsl:text>
		</sch:assert>
	</sch:rule>
	 
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-ENTITIES')}" > 
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>ENTITIES type value.</xsl:text>
		</sch:assert>
	</sch:rule> 
	
	
	<sch:rule abstract="true" id="{concat($prefix, '-xsd-datatype-NMTOKENS')}" > 
		<sch:assert test="true()">
			<sch:name/><xsl:text> elements or attributes should have a </xsl:text>
			<xsl:text>NMTOKENS type value.</xsl:text>
		</sch:assert>
	</sch:rule>
</xsl:template>
 