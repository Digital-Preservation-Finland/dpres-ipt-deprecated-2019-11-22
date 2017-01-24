"""Utility functions."""

import subprocess
import urllib
from collections import defaultdict


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
