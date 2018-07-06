Information Package Tools
=========================

This repository contains tools for validating Submission/Archival/Dissemination Information
Packages (SIP/AIP/DIP) based on Open Archival Information System (OAIS) standard.

The aim is to provide digital preservation services for culture and research to ensure
the access and use of materials long in the future. Documentation and specifications
for the digital preservation service can be found in: http://digitalpreservation.fi

Installation
------------

The software is tested with Python 2.7 with Centos 7.x / RHEL 7.x releases.
For running in a tested and isolated environment, get python-virtuelenv
software:

        pip install virtualenv

Run the following to activate the virtual environment:

        virtualenv .venv
        source ./.venv/bin/activate

Additional requirements
+++++++++++++++++++++++

The following software is required for validation tools, depending on the file formats in the package:

        * dpres-xml-schemas, see https://github.com/Digital-Preservation-Finland/dpres-xml-schemas
        * xml-helpers, see https://github.com/Digital-Preservation-Finland/xml-helpers
        * mets, see https://github.com/Digital-Preservation-Finland/mets
        * premis, see https://github.com/Digital-Preservation-Finland/premis
        * dpx-validator, see https://github.com/Digital-Preservation-Finland/dpx-validator
        * libxml2 & libxslt / xmllint & xsltproc ( with exslt and Saxon line number extensions )
        * gcc
        * python-lxml
        * python-mimeparse
        * python-dateutil
        * xml-common
        * Jhove
        * Ghostscript
        * veraPDF
        * LibreOffice
        * PSPP
        * pngcheck
        * file, version 5.30 or greater
        * ImageMagick
        * python-wand
        * v.Nu
        * warctools
        * Gzip

Form the above list, you can install the Python related software with command::

        pip install -r requirements_github.txt

This may require that gcc is installed in your system.

Other software listed above needs to be installed separately.

Usage
-----

To validate a METS document::

        python ipt/scripts/check_xml_schema_features.py <METS document>
        python ipt/scripts/check_xml_schematron_features.py -s <schematron_file> <METS document>

See the schematron files from: https://github.com/Digital-Preservation-Finland/dpres-xml-schemas

To validate digital objects in an information package::

        python ipt/scripts/check_sip_digital_objects.py <package directory> <linking_type> <linking_value>

Parameters <linking_type> and <linking_value> give values to PREMIS <relatedObjectIdentifierType> and
<relatedObjectIdentifierValues> elements in the output. If you are not planning to use these, you
may give random strings.

To check fixity of digital objects in an information package::

        python ipt/scripts/check_sip_file_checksums.py <package directory>

Copyright
---------
All rights reserved to CSC - IT Center for Science Ltd.

