"""Module for validating files with warc-tools warc validator"""
import os
import re
import subprocess

from validator.basevalidator import BaseValidator

# The VERSION_CHECK_CMD could be implemented in Python as follows.
# Then it would be possible to use shell=False in Popen.
# import gzip
# fd = gzip.open(warc_filename)
# warc_content = fd.read()
# if "WARC_VERSION" in warc_content:
#     print "ok"
VERSION_CHECK_CMD = 'zcat -q "FILENAME" | head -n1 | grep -q WARC/VERSION || cat "FILENAME" | head -n1 | grep -q WARC/VERSION'

class WarcTools(BaseValidator):

    """ Initializes warctools validator and set ups everything so that
        methods from base class (BaseValidator) can be called, such as
        validate() for file validation.
    
    
    .. seealso:: http://code.hanzoarchives.com/warc-tools
    """
        
    def __init__(self, mimetype, fileversion, filename):
        super(WarcTools, self).__init__()
        self.exec_cmd = ['warcvalid.py']
        self.filename = filename
        self.fileversion = fileversion
        self.mimetype = mimetype
        
        if mimetype != "application/warc":
            raise Exception("Unknown mimetype: %s" % mimetype)

    def check_validity(self):
        return None

    def check_version(self, version):
        """ Check the file version of given file. In WARC format version string
            is stored at the first line of file so this methdos read the first
            line and check that it matches.
        """
        cmd = VERSION_CHECK_CMD.replace('FILENAME', self.filename)
        cmd = cmd.replace('VERSION', version)
        
        proc = subprocess.Popen(cmd, shell=True)
        proc.communicate()
        
        if proc.returncode != 0:
            return "ERROR: File version is '%s', expected '%s'" % (
                report_version, version)
        return None
  
    
    def check_profile(self, profile):
        """ WARC file format does not have profiles """
        return None
