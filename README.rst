Information Package Tools
=========================

This repository contains tools for validating Submission/Archival/Dissemination Information
Packages (SIP/AIP/DIP) based on Open Archival Information System (OAIS) standard.

The tools are used in the preservation services of Finnish National Digital Library
and Open Science and Research Initiative. The aim is to provide digital preservation
services for culture and research to ensure the access and use of materials long in
the future.

Installation
------------

This software is tested with Python 2.7 with Centos 7.x / RHEL 7.x releases.
Support for Python 3 is not planned in recent future.

Installation and usage requires additional software in system $PATH:

        * Python 2.7
        * GNU Make

Install the scripts with command::

        make install

Additional requirements
+++++++++++++++++++++++

The following software is required for validation tools, depending on the file formats in the package:

        * dpres-xml-schemas, see https://github.com/Digital-Preservation-Finland/dpres-xml-schemas
        * mets, see https://github.com/Digital-Preservation-Finland/mets
        * premis, see https://github.com/Digital-Preservation-Finland/premis
        * libxml2 & libxslt / xmllint & xsltproc ( with exslt and Saxon line number extensions )
        * python-lxml
        * python-mimeparse
        * python-dateutil
        * xml-common
        * Jhove
        * veraPDF
        * LibreOffice
        * PSPP
        * pngcheck
        * file, version 5.30 or greater
        * ImageMagick
        * python-wand
        * warctools
        * Gzip

Form the above list, you can install the Python related software with command::

        pip install -r requirements_github.txt

Other software listed above needs to be installed separately.

Usage
-----

To validate a METS document::

        check-xml-schema-features <METS document>
        check-xml-schematron-features <METS document>

To validate digital objects in an information package::

        check-sip-digital-objects <package directory>

To check fixity of digital objects in an information package::

        check-sip-file-checksums <package directory>

Copyright
---------
All rights reserved to CSC - IT Center for Science Ltd.

