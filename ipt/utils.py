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
    Merge N dicts. If dictionaries have same keys on root level,
    they will be merged under one key as a list.
    :dicts: a list of dicts.
    :returns: one merged dict
    """
    result = {}
    for dictionary in dicts:
        keys = [x for x in dictionary]
        if len(keys) == 0:
            continue
        if keys[0] in dictionary and keys[0] in result:
            result[keys[0]].append(dictionary[keys[0]][0])
        else:
            result.update(dictionary)
    return result


def compare_lists_of_dicts(expected, found):
    """
    :excpected: a list of dicts that should be in second 'found' paramater
    :found: a list of dicts that really exist
    :returns: a tuple describing missing and extraneus dicts
    """
    missing = find_missing_dict(expected, found)
    extra = find_missing_dict(found, expected)
    return (missing, extra)


def find_missing_dict(expected, found):
    """
    :excpected: a list of dicts that should be in second 'found' paramater
    :found: a list of dicts that really exist
    """
    missing = []
    if not expected:
        return missing
    if not found:
        return expected
    expected_ = list(expected)
    found_ = list(found)
    for excpected_item in expected_:
        match = False
        iterator = 0
        for found_item in found_:
            if excpected_item == found_item:
                found_ = found_[:iterator] + found_[iterator+1:]
                expected_ = expected_[:iterator] + expected_[iterator+1:]
                match = True
            iterator = iterator + 1
        if not match:
            missing.append(excpected_item)
    return missing


def uri_to_path(uri):
    """Remove URI scheme from given `URI`:

    file://kuvat/PICT0081.JPG -> kuvat/PICT0081.JPG

    :uri: URI as string
    :returns: Relative path as string

    """
    path = urllib.unquote_plus(uri).replace('file://', '')
    return path.lstrip('./')
