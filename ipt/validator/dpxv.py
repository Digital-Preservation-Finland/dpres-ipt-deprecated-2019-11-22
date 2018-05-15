"""
This is an DPX V2.0 validator
"""

from ipt.validator.basevalidator import BaseValidator, Shell


class DPXv(BaseValidator):
    """
    DPX validator
    """
    _supported_mimetypes = {
        "image/x-dpx": ["2.0"]
    }

    def validate(self):
        """
        Validate file and version by passing the version from the METS
        metadata_info data as a flavour argument to the validator which
        selects a specific validation profile for the stated version.
        The validator returns an XML validation report to stdout. If the
        file is not valid or the version is not compliant with the
        selected validation profile the validation report is sent to
        stderr.
        """

        try:

            shell = Shell(['dpx_validator.py', self.metadata_info['filename']])

            self.errors(shell.stderr)
            self.messages(shell.stdout)

        finally:
            pass