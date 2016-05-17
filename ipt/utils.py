"""Utility functions."""

import os
import subprocess
import urlparse
import urllib


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

    (stdout_result, stderr_result) = proc.communicate()
    if not stdout_result:
        stdout_result = ""
    if not stderr_result:
        stderr_result = ""
    statuscode = proc.returncode
    return statuscode, stdout_result, stderr_result


def url2path(url):
    url = urlparse.urlparse(url)
    url = os.path.abspath(os.path.join(url.netloc, url.path))
    url = urllib.unquote_plus(url)
    url = url.lstrip('/')
