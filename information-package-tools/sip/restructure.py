"""
Restructure SIP tranfer directory to unified directory structure, for storing
multiple SIPs and additional metadata.

Usage::

    import sip.restructure
    sip.restructure('path-to-sip', 'transfer-name')

Restructuring directory we achieve the following:

    * Make initial SIP creation easier, without restricted directory structure
    * Preserve the original transferred data exactly
    * Store multiple SIPs in single AIP
    * Store additional metadata to SIP
    * Avoid namespace collisions with files in original SIP

Restructuring is done as follows:

Original SIP directory structure after transfer and extraction::

        <sip directory>/mets.xml
        <sip directory>/image.jpg

Unified SIP directory structure after restructuring::

        <sip directory>/logs
        <sip directory>/metadata
        <sip directory>/transfers/<transfer name>/mets.xml
        <sip directory>/transfers/<transfer name>/image.jpg

This directory structure can be stored in various formats. For example see the
:mod:`bagit.bagit` module.

"""

import os
import shutil
import tempfile

def restructure_sip(destination_directory, source_directory):
    """Restructure given source directory to a unified directory
    structure under destination directory.

    :destination_directory: Path to created restuctured directory.
    :source_directory: Path to directory to restructure.
    :returns: None

    Note that source directory is moved under destination directory.

    """

    sip_parent_path = os.path.dirname(destination_directory.rstrip('/'))
    sip_name = os.path.basename(destination_directory.rstrip('/'))

    tempdir = tempfile.mkdtemp(dir=sip_parent_path)

    print 'Restructuring SIP... %s %s'

    directories = ['metadata', 'logs', 'transfers']

    for directory in directories:
        print "...create %s/%s" % (sip_name, directory)
        os.makedirs(os.path.join(tempdir, directory))

    shutil.move(destination_directory, os.path.join(tempdir, 'transfers/',
        source_directory))
    shutil.move(tempdir, destination_directory)

