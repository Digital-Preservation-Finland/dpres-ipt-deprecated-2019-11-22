"""Test for utils.py."""

from ipt.utils import merge_dicts, compare_lists_of_dicts

AUDIOMD1 = {"audiomd": [{"codec": "foo"}]}
AUDIOMD2 = {"audiomd": [{"codec": "bar"}]}


def test_merge_dicts():
    """Test for merge dict."""
    fileinfo = {'filename': "sippi"}
    addml = {"addml": {"charset": "UTF-8"}}

    fileinfo = merge_dicts(fileinfo, AUDIOMD1)
    assert fileinfo == {"audiomd": [{"codec": "foo"}], "filename": "sippi"}

    fileinfo = merge_dicts(fileinfo, AUDIOMD2)
    assert fileinfo == {
        "audiomd": [{"codec": "foo"}, {"codec": "bar"}], "filename": "sippi"}

    fileinfo = merge_dicts(fileinfo, addml)
    assert fileinfo == {
        "audiomd": [{"codec": "foo"}, {"codec": "bar"}],
        "filename": "sippi",
        "addml": {"charset": "UTF-8"}}


def test_compare_lists_of_dicts():
    """Test list comparison of dicts."""
    assert compare_lists_of_dicts(None, None) == ([], [])
    assert compare_lists_of_dicts([AUDIOMD1], None) == (
        [AUDIOMD1], [])
    assert compare_lists_of_dicts(None, [AUDIOMD1]) == (
        [], [AUDIOMD1])
    assert compare_lists_of_dicts([AUDIOMD1, AUDIOMD2], [AUDIOMD1]) == (
        [AUDIOMD2], [])
    assert compare_lists_of_dicts([AUDIOMD1], [AUDIOMD1, AUDIOMD2]) == (
        [], [AUDIOMD2])
