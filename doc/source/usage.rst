Command Line Usage Instructions
===============================

Creating and Verifying Digital Signatures
*****************************************

.. automodule:: scripts.sign_sip
.. automodule:: scripts.check_sip_signature

Verifying and Validating METS XML Files
***************************************

.. automodule:: scripts.check_mets_optional_features
.. automodule:: scripts.check_mets_required_features
.. automodule:: scripts.check_mets_schema_features

Validating Digital Objects
**************************

.. automodule:: scripts.check_sip_digital_objects
.. automodule:: scripts.check_sip_file_checksums
.. automodule:: scripts.jhove_pas

Creating Archival Information Packages (AIP)
********************************************

Creating Archival Information Package (AIP) is splitted in three different parts

    1. Restructure transferred SIP to unified directory structure
    2. Create Bagit compliant directory structure and metadata
    3. Compress AIP directory

This process is not dependend of AIP or SIP file naming scheme so
file/directory names are decided outside these components.

Command line example for creating AIP::

    restructure-sip sip-directory-name
    mv sip-directory-name aip-directory-name     # Optional step
    create-aip aip-directory name
    tar czvf aip-directory-name.tar.gz aip-directory-name

This results compressed AIP that is ready for archival storage. This file
contains necessary metatada to check integrity of archived digital objects.

Structure of AIP is described in modules :mod:`sip.restructure`, :mod:`aiptools.create_aip`.

Restructuring Submission Information Package
--------------------------------------------
.. automodule:: scripts.restructure_sip

Creating Archival Information Package
-------------------------------------
.. automodule:: scripts.create_aip
