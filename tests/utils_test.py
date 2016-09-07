"""Test for utils.py."""

from ipt.utils import merge_dicts


def test_merge_dicts():
    """Test for merge dict."""
    fileinfo = {'filename': "sippi"}
    audiomd1 = {"audiomd": [{"codec": "foo"}]}
    audiomd2 = {"audiomd": [{"codec": "bar"}]}
    addml = {"addml": {"charset": "UTF-8"}}

    fileinfo = merge_dicts(fileinfo, audiomd1)
    assert fileinfo == {"audiomd": [{"codec": "foo"}], "filename": "sippi"}

    fileinfo = merge_dicts(fileinfo, audiomd2)
    assert fileinfo == {
        "audiomd": [{"codec": "foo"}, {"codec": "bar"}], "filename": "sippi"}

    fileinfo = merge_dicts(fileinfo, addml)
    assert fileinfo == {
        "audiomd": [{"codec": "foo"}, {"codec": "bar"}],
        "filename": "sippi",
        "addml": {"charset": "UTF-8"}}
