"""Utility functions."""

import subprocess
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


def merge_dicts(*dicts):
    """
    Merge N dicts.
    :dicts: a list of dicts.
    :returns: one merged dict
    """
    result = {}
    for dictionary in dicts:
        result.update(dictionary)
    return result


def uri_to_path(uri):
    """Remove URI scheme from given `URI`:

    file://kuvat/PICT0081.JPG -> kuvat/PICT0081.JPG

    :uri: URI as string
    :returns: Relative path as string

    """
    path = urllib.unquote_plus(uri).replace('file://', '')
    return path.lstrip('./')
