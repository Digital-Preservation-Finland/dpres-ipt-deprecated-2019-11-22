KDK Schema Change to LIDO

Element gml and http://www.opengis.net/gml schema import commented out.
There exists some problems with imported OpenGIS GML schema, which will be solved later.

The following rows have been commented out:
- Row 59:
	<xsd:import namespace="http://www.opengis.net/gml" schemaLocation="http://schemas.opengis.net/gml/3.1.1/base/feature.xsd"/>

- Rows 651-661:
	<xsd:complexType name="gmlComplexType">
		<xsd:annotation>
			<xsd:documentation>Definition: Specifies the GML instantiation for georeferences.</xsd:documentation>
			<xsd:documentation>Notes: For documentation on GML refer to http://www.opengis.net/gml/. </xsd:documentation>
		</xsd:annotation>
		<xsd:sequence>
			<xsd:element ref="gml:Point" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="gml:LineString" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="gml:Polygon" minOccurs="0" maxOccurs="unbounded"/>
		</xsd:sequence>
	</xsd:complexType>

- Rows 1150-1563:
	<xsd:element name="gml" minOccurs="0" maxOccurs="unbounded">
		<xsd:annotation>
			<xsd:documentation>Definition: Georeferences of the place using the GML specification.</xsd:documentation>
			<xsd:documentation>How to record: Repeat this element only for language variants.</xsd:documentation>
			<xsd:documentation>Notes: For further documentation on GML refer to http://www.opengis.net/gml/. </xsd:documentation>
		</xsd:annotation>
		<xsd:complexType>
			<xsd:complexContent>
				<xsd:extension base="lido:gmlComplexType">
					<xsd:attribute ref="xml:lang"/>
				</xsd:extension>
			</xsd:complexContent>
		</xsd:complexType>
	</xsd:element>
