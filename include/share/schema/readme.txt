KDK SCHEMA CATALOG

Current catalog version is 1.4.1, and it includes the following files and directories.

NOTES:
- Version 1.4.1 changelog compared to 1.4:
  1) METS created with schema 1.4 complies with 1.4.1 schema, in exception of cases 4), 5) and 6).
  2) The value in attribute CATALOG in METS can be either "1.4.1" or "1.4".
     The value in attribute SPECIFICATION in METS remains the same "1.4".
     Data created with schema 1.4 will be validated according to version 1.4.1 in NDL DP system.
  3) PREMIS 2.3 schema updated, which complies with version 2.2.
  4) Possibility to add organizational specific descriptive metadata formats added.
  5) Sections RightsMD and SourceMD require that the metadata has an existing schema.
  6) Bugfix: Use of OTHERMDTYPE attribute is disallowed, if the value of attribute MDTYPE is not "OTHER".

- XML Catalog version 1.4 is included for historical purposes only.
- XML Catalog version 1.3 is included for historical purposes only.

CATALOGS:
./catalog-local.xml				Current XML Catalog for local purposes.
./catalog-web.xml				Current XML Catalog for web purposes.
./catalog-local-1.4.1.xml		XML Catalog version 1.4.1 for local purposes.
./catalog-web-1.4.1.xml			XML Catalog version 1.4.1 for web purposes.
./catalog-local-1.4.xml			XML Catalog version 1.4 for local purposes.
./catalog-web-1.4.xml			XML Catalog version 1.4 for web purposes.
./catalog-local-1.3.xml			XML Catalog version 1.3 for local purposes.
./catalog-web-1.3.xml			XML Catalog version 1.3 for web purposes.
./catalog.dtd					OASIS Catalog specification file

KDK XSD FILES:
./avmd/audiomd.xsd				KDK audioMD schema, based on version 2.0
./avmd/videomd.xsd				KDK videoMD schema, based on version 2.0
./ddi-codebook/codebook.xsd		Patch for DDI-Codebook 2.5.1, since this has it's own Dublin Core Terms specification
./ddi-codebook/dcterms.xsd		Dublin Core Terms file with KDK namespace for DDI-Codebook
./mets/kdk-mets-extensions.xsd	KDK extension for KDK METS schema
./mets/mets-extensions.xsd		METS extension for KDK METS schema
./mets/mets.xsd					KDK METS schema, based on version 1.10
./mix/mix.xsd					KDK MIX schema, based on version 2.0
./textmd/textmd.xsd				KDK textMD schema, based on version 2.2
./w3/xlink.xsd					Xlink patch for KDK METS, includes ./external/w3/xlink.xsd

EXTERNAL DIRECTORIES:
./external/dc					Dublin Core 1.1 schema files (unchanged)
./external/ddi-codebook			DDI Codebook 2.5.1 schema files (unchanged)
./external/ddi-lifecycle		DDI Lifecycle 3.2 schema files (unchanged)
./external/eac					EAC-CPF 2010 schema files (unchanged)
./external/ead					EAD 2002 schema files (unchanged)
./external/gml					Opengis GML 3.1.1 schema files (unchanged, used by LIDO)
./external/lido					LIDO 1.0 schema files (unchanged)
./external/marc					MARC21 1.1 schema files (unchanged)
./external/metsrights			METSRights (2004) schema files (unchanged)
./external/mods					MODS 3.5 schema files (unchanged)
./external/premis				PREMIS 2.3 schema files (unchanged)
./external/vra					VRA Core 4.0 schema files (unchanged)
./external/w3					W3 schema files (various, unchanged)

VERSION DIRECTORIES:
./								Current version
./1.4.1							Catalog version 1.4.1
./1.4							Catalog version 1.4 (for historical purposes only)
./1.3							Catalog version 1.3 (for historical purposes only)