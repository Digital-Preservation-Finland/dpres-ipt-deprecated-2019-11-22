"""Utility functions."""

import subprocess

class UnknownException(Exception):
    """Unknown error."""
    pass


class ValidationException(Exception):
    """Validator error."""
    pass


def run_command(cmd, stdout=subprocess.PIPE):
    """Execute command. Validator specific error handling is supported
    by forwarding exceptions.
    :cmd: commandline command.
    :stdout: a file handle can be given, for directing stdout to file.
    :returns: Tuple (statuscode, stdout, stderr)
    """
    proc = subprocess.Popen(cmd,
                            stdout=stdout,
                            stderr=subprocess.PIPE,
                            shell=False)

    (stdout, stderr) = proc.communicate()
    statuscode = proc.returncode

    if statuscode != 0:
        if 'IOError' in stderr:
            raise IOError(stderr)
        if 'Exception' in stderr:
            raise UnknownException(stderr)

    return statuscode, stdout, stderr
