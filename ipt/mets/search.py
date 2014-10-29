"""Utilities to search METS files from directory tree"""

import os
import sys

def search_mets(path):
    """Search METS file in path or return filename if mets exists.


    :path: Mets filename or directory to search METS XML
    :returns: Mets filename if found from path, else None

    """

    if os.path.isfile(path):
        return path
    elif not os.path.isdir(path):
        raise IOError("No such file or directory: %s" % path)

    mets_path = None
    sip_path = path.rstrip('/')

    for filename in os.listdir(sip_path):
        if (filename.lower().endswith(".xml") and
            filename.lower().find('mets') >= 0):
            mets_path = os.path.join(sip_path, filename)

    if mets_path == None:
        return None

    return os.path.abspath(os.path.join(sip_path, mets_path))

