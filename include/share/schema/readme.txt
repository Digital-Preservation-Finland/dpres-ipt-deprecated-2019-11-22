CATALOGS:
./catalog-local.xml				XML Catalog for local purposes. Untested.
./catalog-web.xml				XML Catalog for web purposes. Untested.
./catalog.dtd					OASIS Catalog specification file

KDK XSD FILES:
./avmd/audiomd.xsd				KDK audioMD schema, based on version 2.0
./avmd/videomd.xsd				KDK videoMD schema, based on version 2.0
./ddi-codebook/codebook.xsd		Patch for DDI-Codebook 2.5, since this has it's own Dublin Core Terms specification
./ddi-codebook/dcterms.xsd		Dublin Core Terms file with KDK namespace for DDI-Codebook
./mets/mets-extensions.xsd		METS extension for KDK METS schema
./mets/mets.xsd					KDK METS schema, based on version 1.9.1
./mix/mix.xsd					KDK MIX schema, based on version 2.0
./premis/premis.xsd				Patches the PREMIS schema by making the fixity element obligatory
./textmd/textmd.xsd				KDK textMD schema, based on version 2.2
./w3/xlink.xsd					Xlink patch for KDK METS, includes ./external/w3/xlink.xsd

EXTERNAL DIRECTORIES:
./external/dc					Dublin Core 1.1 schema (unchanged)
./external/ddi-codebook			DDI Codebook 2.5 schema (unchanged)
./external/ddi-lifecycle		DDI Lifecycle 3.1 schema (unchanged)
./external/eac					EAC-CPF 2010 schema files (unchanged)
./external/ead					EAD 2002 schema files (unchanged)
./external/gml					Opengis GML 3.1.1 schema files (unchanged, used by LIDO)
./external/lido					LIDO 1.0 schema files (unchanged)
./external/marc					MARC21 1.1 schema files (unchanged)
./external/metsrights			METSRights schema files (unchanged)
./external/mods					MODS 3.4 schema files (unchanged)
./external/premis				PREMIS 2.2 schema files (unchanged)
./external/vra					VRA Core 4.0 schema files (unchanged)
./external/w3					W3 schema files (various, unchanged)
