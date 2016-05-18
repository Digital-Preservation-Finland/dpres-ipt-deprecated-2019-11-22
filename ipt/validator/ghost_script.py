"""
This is a PDF 1.7 valdiator implemented with ghostscript.
"""

from ipt.validator.basevalidator import BaseValidator
from ipt.utils import run_command


class GhostScript(BaseValidator):
    """
    Ghostscript pdf validator
    """
    _supported_mimetypes = {
        'application/pdf': ['1.7']
    }

    def __init__(self, fileinfo):
        """
        init
        :fileinfo: a dictionary with format

            fileinfo["filename"]
            fileinfo["algorithm"]
            fileinfo["digest"]
            fileinfo["format"]["version"]
            fileinfo["format"]["mimetype"]
            fileinfo["format"]["charset"]
            fileinfo["format"]["format_registry_key"]
            fileinfo["object_id"]["type"]
            fileinfo["object_id"]["value"]
        """
        super(GhostScript, self).__init__(fileinfo)
        self.filename = fileinfo["filename"]

    def validate(self):
        """
        Validate file
        :returns: tuple(validity, messages, errors)
        """
        cmd_exec = [
            'gs', '-o', '/dev/null', '-sDEVICE=nullpage', '%s' % self.filename]
        (exitcode, stdout, stderr) = run_command(cmd_exec)

        if 'error' in stderr or 'Error' in stdout or exitcode != 0:
            self.is_valid(False)
            self.errors(stderr)
            self.messages(stdout)

        self._check_version()

        messages = "\n".join(message for message in self.messages())
        errors = "\n".join(error for error in self.errors())
        return (self.is_valid(), messages, errors)

    def _check_version(self):
        """
        Check pdf version
        """
        (exitcode, stdout, stderr) = run_command(['file', self.filename])
        if exitcode != 0:
            self.is_valid(False)
            self.errors("ERROR:%s" % stderr)
            self.messages(stdout)

        if 'PDF document, version 1.7' not in stdout:
            self.is_valid(False)
            self.errors("ERROR: wrong PDF version")
            self.messages(stdout)