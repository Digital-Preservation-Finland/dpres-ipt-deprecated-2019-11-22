"""Create Archival Information Package (AIP) that contains necessary metadata
for bit preservation.

This is achieved using Bagit_ tool that standardizes directory structure for
payload and metadata. For ensuring file itegrity Bagit uses standardized
manifest file that contain checksums for all digital objects in the payload.

For more information see :mod:`bagit.bagit` module.

Bagit is currently a `Bagit IETF draft`_.

.. _Bagit: http://en.wikipedia.org/wiki/BagIt
.. _`Bagit IETF draft`: http://www.digitalpreservation.gov/documents/\
bagitspec.pdf

"""

import os
import ipt.aiptools.bagit


def create_aip_from_sip(directory):
    """Create AIP with bit preservation metadata

    :directory: Directory to add preservation metadata
    :return: None

    """

    if not os.path.isdir(directory):
        raise IOError("No such directory %s" % directory)

    return ipt.aiptools.bagit.make_bag(directory)
