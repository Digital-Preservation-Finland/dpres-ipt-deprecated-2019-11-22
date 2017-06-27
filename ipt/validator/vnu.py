"""
A HTML5 validator module using The Nu Html Checker
(https://validator.github.io/validator/)
"""

from ipt.validator.basevalidator import BaseValidator, Shell

VNU_PATH = "/usr/share/java/vnu.jar"


class Vnu(BaseValidator):
    """
    Vnu validator. Supports only HTML version 5.0.
    """

    _supported_mimetypes = {
        'text/html':['5.0']
    }

    def validate(self):
        """
        Validate file using vnu.jar
        """
        shell = Shell([
            'java', '-jar', VNU_PATH, '--verbose', self.fileinfo['filename']])
        self.errors(shell.stderr)
        self.messages(shell.stdout)
