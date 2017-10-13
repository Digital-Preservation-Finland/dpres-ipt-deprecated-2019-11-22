#!/usr/bin/python
# vim: set fileencoding=utf-8 :
"""Test that ipt.premis.premis returns utf-8 strings and not unicode."""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import testcommon.settings
# from ipt.report import report as premis


class TestPremisUtf8Support:
    """Test that ipt.premis.premis returns utf-8 strings and not unicode."""
    def test_utf8(self):
        """Test that ipt.premis.premis returns utf-8 strings and not
        unicode."""
        premis_xml_path = os.path.abspath(
            os.path.join(testcommon.settings.TESTDATADIR,
                         ("premis_utf8_filename_test/"
                          "premis-validation-event.xml")))
        premis_data = open(premis_xml_path).read()
        premis_ = premis.Premis()
        premis_.fromstring(premis_data)

        instances_to_check = list()
        instances_to_check.extend(premis_.objects)
        instances_to_check.extend(premis_.events)
        instances_to_check.extend(premis_.agents)

        for instance in instances_to_check:
            property_names = [p for p in dir(instance.__class__) if
                              isinstance(getattr(instance.__class__, p),
                                         property)]
            for prop in property_names:
                prop_value = getattr(instance, prop)
                # These are for print debugging the situation
                # print "instance:", instance, "property:", prop, \
                #    "prop_value type", type(prop_value)
                assert not isinstance(prop_value, unicode),\
                    ("Property %s returns an instance of %s which is a subtype"
                     " of unicode. This can cause problems when saving to"
                     " database via SQLAlchemy.") % (prop, type(prop_value))
