KDK Schema Change to GML

LIDO imports feature.xsd from GML. However, GML includes all schema files several times,
creating a web structure. This has been transformed to a tree structure with removing
unnecessary include commands. The (web) structure is shown below, and the includes
marked with '#' have been removed from it to form the tree structure. 

./base/feature.xsd:
	<include schemaLocation="gml.xsd"/>
		<include schemaLocation="dynamicFeature.xsd"/>
#			<include schemaLocation="gml.xsd"/>
#			<include schemaLocation="feature.xsd"/>
			<include schemaLocation="direction.xsd"/>
#				<include schemaLocation="gml.xsd"/>
				<include schemaLocation="geometryBasic0d1d.xsd"/>
#					<include schemaLocation="gml.xsd"/>
					<include schemaLocation="measures.xsd">
#						<include schemaLocation="gml.xsd"/>
						<include schemaLocation="units.xsd"/>
#							<include schemaLocation="gml.xsd"/>
							<include schemaLocation="dictionary.xsd"/>
#								<include schemaLocation="gml.xsd"/>
								<include schemaLocation="gmlBase.xsd"/>
#									<include schemaLocation="gml.xsd"/>
									<include schemaLocation="basicTypes.xsd"/>
#										<include schemaLocation="gml.xsd"/>
		<include schemaLocation="topology.xsd"/>
#			<include schemaLocation="gml.xsd"/>
			<include schemaLocation="geometryComplexes.xsd"/>
#				<include schemaLocation="gml.xsd"/>
				<include schemaLocation="geometryAggregates.xsd"/>
#					<include schemaLocation="gml.xsd"/>
					<include schemaLocation="geometryPrimitives.xsd"/>
#						<include schemaLocation="gml.xsd"/>
						<include schemaLocation="geometryBasic2d.xsd"/>
#							<include schemaLocation="gml.xsd"/>
#							<include schemaLocation="geometryBasic0d1d.xsd"/>
		<include schemaLocation="coverage.xsd"/>
#			<include schemaLocation="gml.xsd"/>
#			<include schemaLocation="feature.xsd"/>
			<include schemaLocation="valueObjects.xsd"/>
#				<include schemaLocation="gml.xsd"/>
#				<include schemaLocation="geometryBasic0d1d.xsd"/>
				<include schemaLocation="temporal.xsd"/>
#					<include schemaLocation="gml.xsd"/>
#					<include schemaLocation="gmlBase.xsd"/>
			<include schemaLocation="grids.xsd"/>
#				<include schemaLocation="gml.xsd"/>
#				<include schemaLocation="geometryBasic0d1d.xsd"/>
#			<include schemaLocation="geometryAggregates.xsd"/>
		<include schemaLocation="coordinateReferenceSystems.xsd"/>
#			<include schemaLocation="gml.xsd"/>
			<include schemaLocation="coordinateSystems.xsd"/>
#				<include schemaLocation="gml.xsd"/>
				<include schemaLocation="referenceSystems.xsd"/>
#					<include schemaLocation="gml.xsd"/>
#					<include schemaLocation="geometryBasic2d.xsd"/>
#					<include schemaLocation="temporal.xsd"/>
			<include schemaLocation="datums.xsd"/>
#				<include schemaLocation="gml.xsd"/>
#				<include schemaLocation="referenceSystems.xsd"/>
			<include schemaLocation="coordinateOperations.xsd"/>
#				<include schemaLocation="gml.xsd"/>
#				<include schemaLocation="referenceSystems.xsd"/>
				<include schemaLocation="dataQuality.xsd"/>
#					<include schemaLocation="gml.xsd"/>
#					<include schemaLocation="units.xsd"/>
		<include schemaLocation="observation.xsd"/>
#			<include schemaLocation="gml.xsd"/>
#			<include schemaLocation="feature.xsd"/>
#			<include schemaLocation="direction.xsd"/>
#			<include schemaLocation="valueObjects.xsd"/>
		<include schemaLocation="defaultStyle.xsd"/>
#			<include schemaLocation="gml.xsd"/>
#			<include schemaLocation="measures.xsd"/>
		<include schemaLocation="temporalReferenceSystems.xsd"/>
#			<include schemaLocation="gml.xsd"/>
			<include schemaLocation="temporalTopology.xsd"/>
#				<include schemaLocation="gml.xsd"/>
#				<include schemaLocation="temporal.xsd"/>
#			<include schemaLocation="dictionary.xsd"/>
#	<include schemaLocation="geometryBasic2d.xsd"/>	
#	<include schemaLocation="temporal.xsd"/>
