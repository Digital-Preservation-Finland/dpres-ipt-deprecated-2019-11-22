Command Line Usage Instructions
===============================

Creating and Verifying Digital Signatures
*****************************************

.. automodule:: pas_scripts.sign_sip
.. automodule:: pas_scripts.check_sip_signature

Verifying and Validating METS XML Files
***************************************

.. automodule:: pas_scripts.check_mets_optional_features
.. automodule:: pas_scripts.check_mets_required_features
.. automodule:: pas_scripts.check_mets_schema_features

Validating Digital Objects
**************************

.. automodule:: pas_scripts.check_sip_digital_objects
.. automodule:: pas_scripts.check_sip_file_checksums
.. automodule:: pas_scripts.jhove_pas

Creating Archival Information Packages (AIP)
********************************************

.. note:: TODO: This will be moved to separated repository / documentation after code refactoring.

Creating AIP package consists of two stages. First we restructure transfer SIP to archival SIP aka. to following directory structure::
       
        transfer-id/mets.xml

        -->

        sip-id/transfers/transfer-id/mets.xml
        sip-id/logs
        sip-id/metadata

For restructuring you may use the :file:`restructure-sip` command line utility:

.. automodule:: kdkpas_scripts.restructure_sip

Next we make Bagit package with command :file:`create-aip`::

        sip-id/transfers/transfer-id/mets.xml
        sip-id/logs
        sip-id/metadata

        -->

        sip-id/bagit.txt
        sip-id/manifest.txt
        sip-id/data/transfers/transfer-id/mets.xml
        sip-id/data/logs
        sip-id/data/metadata

For AIP creation use the :file:`create-aip` command:

.. automodule:: kdkpas_scripts.create_aip


Storing and Fetching files to/from Disk Storage
***************************************************

.. note::

        TODO: This will be moved to separated repository / documentation after code refactoring

