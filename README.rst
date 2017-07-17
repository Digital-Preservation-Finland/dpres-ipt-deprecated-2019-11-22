Overview: Information Package Tools
===================================

Tools for creating and validating Submission/Archival/Dissemination Information Packages (SIP/AIP/DIP) based on Open Archival Information System (OAIS) standard.


Installation
============

This software is tested with Python 2.7 with Centos 7.x / RHEL 7.x releases.
Support for Python 3 is not planned in recent future.

Installation and usage requires additional software in system $PATH:

        * Python 2.7
        * GNU Make

For managing information packages, install:

        * Tar
        * Gzip

For validating METS documents and different file formats:

        * dpres-xml-schemas, see https://github.com/Digital-Preservation-Finland/dpres-xml-schemas
        * libxslt / xmllint & xsltproc ( with exslt and Saxon line number extensions )
        * python-lxml
        * python-mimeparse
        * python-dateutil
        * xml-common
        * Jhove
        * LibreOffice
        * PSPP
        * pngcheck
        * file, version 5.30 or greater
        * ImageMagick
        * python-wand

Form the above list, you can install the python-* software with command::

        pip install -r requirements_dev.txt

Other software listed above needs to be installed separately.

Usage
=====

To validate a METS document::

        python ipt/scripts/check_xml_schema_features.py <METS document>
        python ipt/scripts/check_xml_schematron_features.py <METS document>

To validate digital objects in an information package::

        python ipt/scripts/check-sip-digital_objects.py <package directory>

To check fixity of digital objects in an information package::

        python ipt/scripts/check_sip_file_checksums.py <package directory>

Copyright
=========
All rights reserved to CSC - IT Center for Science Ltd.

