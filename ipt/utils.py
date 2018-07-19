"""Utility functions."""

import os
import subprocess
import urllib
from collections import defaultdict
from copy import deepcopy
import mimeparse


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
                if isinstance(result[key], dict) and \
                        isinstance(dictionary[key], dict):
                    result[key] = merge_dicts(result[key], dictionary[key])
                elif isinstance(result[key], list) and \
                        isinstance(dictionary[key], list):
                    result[key] = result[key] + dictionary[key]
                elif result[key] is None:
                    result[key] = dictionary[key]
                elif dictionary[key] is None:
                    continue
                else:
                    raise TypeError(
                        'Only lists and dictionaries can be merged.')
            else:
                result[key] = dictionary[key]
    return result


def compare_lists_of_dicts(expected, found):
    """
    :excpected: a list of dicts that should be in second 'found' parameter
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


def uri_to_path(uri):
    """Remove URI scheme from given `URI`:

    file://kuvat/PICT0081.JPG -> kuvat/PICT0081.JPG

    :uri: URI as string
    :returns: Relative path as string

    """
    path = urllib.unquote_plus(uri).replace('file://', '')
    return path.lstrip('./')


def parse_mimetype(mimetype):
    """Parse mimetype information from Content-type string.

    ..seealso:: https://www.ietf.org/rfc/rfc2045.txt
    """
    result = {"format": {}}
    # If the mime type can't be parsed, add the erroneous-mimetype item, which
    # can be checked when selecting validators. We need the original mimetype
    # for the error message printed by the UnknownFileformat validator.
    try:
        result_mimetype = mimeparse.parse_mime_type(mimetype)
    except mimeparse.MimeTypeParseException:
        result["format"]["erroneous-mimetype"] = True
        result["format"]["mimetype"] = mimetype
        return result

    params = result_mimetype[2]
    charset = params.get('charset')
    alt_format = params.get('alt-format')
    result["format"]["mimetype"] = (result_mimetype[0] + "/" +
                                    result_mimetype[1])
    if charset:
        result["format"]["charset"] = charset
    if alt_format:
        result["format"]["alt-format"] = alt_format

    return result


def handle_div(div):
    """
    Change a string containing a division or a decimal number to a
    string containing a decimal number with max 2 digits.
    :div: e.g. "16/9" or "1.7777778"
    :returns: e.g. "1.78"
    """
    try:
        if '/' in div:
            div = float(div.split('/')[0])/float(div.split('/')[1])
        else:
            div = float(div)
        return ("%.2f" % round(div, 2)).rstrip('0').rstrip('.')
    except ValueError:
        return div
    except ZeroDivisionError:
        return div


def find_max_complete(list1, list2, forcekeys=None):
    """
    Finds such version in two lists of dicts, where all the elements in all
    dicts exists. Handles also sublists inside dicts and subdicts inside dicts
    and sublists recursively. In other words, removes such elements that do not
    exist in one or more of the given dicts.
    :list1: List of dicts
    :list2: List of dicts
    :forcekeys: List of those keys which will not be changed or removed, if
                exists
    :returns: Filtered list1 and list2
    """
    included_keys = {}
    if list1 is None:
        list1 = []
    if list2 is None:
        list2 = []
    if list1:
        included_keys['root_key'] = set(list1[0])
    elif list2:
        included_keys['root_key'] = set(list2[0])
    else:
        return (list1, list2)
    included_keys = _find_keys(list1=list1, list2=list2,
                               included_keys=included_keys,
                               parent_key='root_key')
    return _filter_dicts(list1=deepcopy(list1), list2=deepcopy(list2),
                         included_keys=included_keys, parent_key='root_key',
                         forcekeys=forcekeys)


def _find_keys(list1, list2, included_keys, parent_key):
    """
    Recursive function for find_max_complete.
    Finds keys for each dicts and subdicts.
    """
    if parent_key not in included_keys:
        if list1:
            included_keys[parent_key] = set(list1[0].keys())
        elif list2:
            included_keys[parent_key] = set(list2[0].keys())
        else:
            included_keys[parent_key] = set([])

    for dictionary in list1 + list2:
        if not isinstance(dictionary, dict):
            continue
        included_keys[parent_key] = included_keys[parent_key].\
            intersection(set(dictionary.keys()))

    for dict1 in list1:
        for dict2 in list2:
            for key in included_keys[parent_key]:
                if isinstance(dict1[key], list) and \
                        isinstance(dict2[key], list):
                    included_keys = _find_keys(
                        dict1[key], dict2[key], included_keys, key)
                elif isinstance(dict1[key], dict) and \
                        isinstance(dict2[key], dict):
                    included_keys = _find_keys(
                        [dict1[key]], [dict2[key]], included_keys, key)
    return included_keys


def _filter_dicts(list1, list2, included_keys, parent_key, forcekeys):
    """
    Recursive function for find_max_complete.
    Filters lists according to given keys.
    """
    for listx in [list1, list2]:
        for index in range(0, len(listx)):
            tmpdict = {key: listx[index][key]
                       for key in included_keys[parent_key]}
            if forcekeys:
                for key in set(listx[index].keys()).\
                               intersection(set(forcekeys)):
                    tmpdict[key] = listx[index][key]
            listx[index] = tmpdict

    for dict1 in list1:
        for dict2 in list2:
            for key in included_keys[parent_key]:
                if isinstance(dict1[key], list) and \
                        isinstance(dict2[key], list):
                    (dict1[key], dict2[key]) = \
                        _filter_dicts(dict1[key], dict2[key],
                                      included_keys, key, forcekeys)
                elif isinstance(dict1[key], dict) and \
                        isinstance(dict2[key], dict):
                    (sublist1, sublist2) = \
                        _filter_dicts([dict1[key]], [dict2[key]],
                                      included_keys, key, forcekeys)
                    if sublist1 and sublist2:
                        dict1[key] = sublist1[0]
                        dict2[key] = sublist2[0]

    return (list1, list2)
