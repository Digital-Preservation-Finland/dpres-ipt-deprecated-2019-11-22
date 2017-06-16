"""Utility functions."""

import os
import subprocess
import urllib
import unicodedata
import string
from collections import defaultdict


class UnknownException(Exception):
    """Unknown error."""
    pass


class ValidationException(Exception):
    """Validator error."""
    pass


def run_command(cmd, stdout=subprocess.PIPE, ld_library_path=None):
    """Execute command. Validator specific error handling is supported
    by forwarding exceptions.
    :param cmd: commandline command.
    :param ld_library_path: the LD_LIBRARY_PATH value to use
    :param stdout: a file handle can be given, for directing stdout to file.
    :returns: Tuple (statuscode, stdout, stderr)
    """
    env = os.environ.copy()
    if ld_library_path:
        env["LD_LIBRARY_PATH"] = ld_library_path

    proc = subprocess.Popen(cmd,
                            stdout=stdout,
                            stderr=subprocess.PIPE,
                            shell=False,
                            env=env)

    (stdout_result, stderr_result) = proc.communicate()
    if not stdout_result:
        stdout_result = ""
    if not stderr_result:
        stderr_result = ""
    statuscode = proc.returncode
    return statuscode, stdout_result, stderr_result


def merge_dicts(*dicts):
    """
    Merge N dictionaries. List and dict type elements with same key will be
    merged. Elements of other type cannot be merged. If value of an element is
    None, it will be overwritten by value from other dictionary with the same
    key.
    :dicts: a list of dicts.
    :returns: one merged dict
    """
    result = {}
    for dictionary in dicts:
        if len(dictionary) == 0:
            continue
        for key in dictionary.keys():
            if key in result:
                if isinstance(result[key], dict) and isinstance(dictionary[key], dict):
                    result[key] = merge_dicts(result[key], dictionary[key])
                elif isinstance(result[key], list) and isinstance(dictionary[key], list):
                    result[key] = result[key] + dictionary[key]
                elif result[key] is None:
                    result[key] = dictionary[key]
                elif dictionary[key] is None:
                    continue
                else:
                    raise TypeError('Only lists and dictionaries can be merged.')
            else:
                result[key] = dictionary[key]
    return result


def compare_lists_of_dicts(expected, found):
    """
    :excpected: a list of dicts that should be in second 'found' paramater
    :found: a list of dicts that really exist
    :returns: a tuple describing missing and extraneus dicts
    """
    expected_count = dict(count_items_in_dict(expected))
    found_count = dict(count_items_in_dict(found))
    if found_count != expected_count:
        return False
    return True


def count_items_in_dict(expected):
    """
    :excpected: a list of dicts that should be in second 'found' paramater
    :returns: a dict that contains a count of each item
    """
    serialized_dicts = []
    if not expected:
        return {}
    for item in expected:
        serialized_dicts.append(serialize_dict(item))

    count = defaultdict(int)
    for item in serialized_dicts:
        count[item] += 1

    return count


def serialize_dict(data):
    """
    serialize dict to string
    :data: a dict.
    :returns: a list of strings containing dict values
    in format <key value>__<key value>
    """
    serialized_dict = ""
    if data:
        for key in sorted(data.iterkeys()):
            serialized_dict = serialized_dict + "%s=%s  " % (key, data[key])
    return serialized_dict.strip("  ")


def filter_list_of_dicts(list_of_dicts, key):
    """Remove a key from all dicts in a list of dicts

    :param list_of_dicts: The list of dictionaries
    :param key: The key to remove from the dictionaries
    """
    if list_of_dicts:
        for dict_to_edit in list_of_dicts:
            dict_to_edit.pop(key, None)


def uri_to_path(uri):
    """Remove URI scheme from given `URI`:

    file://kuvat/PICT0081.JPG -> kuvat/PICT0081.JPG

    :uri: URI as string
    :returns: Relative path as string

    """
    path = urllib.unquote_plus(uri).replace('file://', '')
    return path.lstrip('./')


def sanitaze_string(dirty_string):
    """Strip non-printable control characters from unicode string"""
    sanitazed_string = "".join(
        char for char in dirty_string if unicodedata.category(char)[0] != "C"
        or char in string.printable)
    return sanitazed_string
