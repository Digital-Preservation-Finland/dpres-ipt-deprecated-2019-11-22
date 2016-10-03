"""Test for utils.py."""

from ipt.utils import merge_dicts, compare_lists_of_dicts, serialize_dict

CODEC1 = {"codec": "foo"}
CODEC2 = {"codec": "bar"}
CODEC1_RESULT = "codec foo"
CODEC2_RESULT = "codec bar"
AUDIOMD1 = {"audiomd": [CODEC1]}
AUDIOMD2 = {"audiomd": [CODEC2]}


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
    assert compare_lists_of_dicts(None, None)
    assert compare_lists_of_dicts([CODEC1, CODEC2], [CODEC1, CODEC2])
    assert not compare_lists_of_dicts([CODEC1], None)
    assert not compare_lists_of_dicts(None, [CODEC1])
    assert not compare_lists_of_dicts([CODEC1, CODEC2], [CODEC1])
    assert not compare_lists_of_dicts([CODEC1], [CODEC1, CODEC2])
    assert not compare_lists_of_dicts([CODEC1], [CODEC1, CODEC1])
    assert not compare_lists_of_dicts([CODEC1, CODEC1], [CODEC1])


def test_serialize_dict():
    assert serialize_dict(CODEC1) == "codec=foo"
    assert serialize_dict({"a": "b", "c": "d"}) == "a=b  c=d"
    assert serialize_dict({"c": "d", "a": "b"}) == "a=b  c=d"
