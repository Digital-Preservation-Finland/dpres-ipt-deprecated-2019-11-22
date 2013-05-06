import pytest

# lxml<2.4 doesn't work with Python3.3, and invoking it will raise ValueError
# so we catch that and skip this module if it happens
try:
    from lxml import etree
except ValueError:
    pytest.skip()

from six import b

from blocks.mets_parser import find_checksums

METS_CHECKSUM = b("""<?xml version="1.0" encoding="UTF-8"?>
<mets:mets
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:premis="info:lc/xmlns/premis-v2">
<mets:amdSec>
    <mets:techMD ID="CSC_test001_tech001" CREATED="2012-07-13T00:00:00">
      <mets:mdWrap MDTYPE="PREMIS:OBJECT">
        <mets:xmlData>
          <premis:object xmlns="info:lc/xmlns/premis-v2" xsi:type="file" xsi:schemaLocation="info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/v2/premis-v2-1.xsd" version="2.1">
            <premis:objectCharacteristics>
              <premis:fixity>
                <premis:messageDigestAlgorithm>MD5</premis:messageDigestAlgorithm>
                <premis:messageDigest>11c128030f203b76f2e30eeb7454c42b</premis:messageDigest>
              </premis:fixity>
            </premis:objectCharacteristics>
          </premis:object>
        </mets:xmlData>
      </mets:mdWrap>
    </mets:techMD>
</mets:amdSec>
<mets:fileSec>
    <mets:fileGrp USE="testing">
        <mets:file ID="CSC_test001_file001" ADMID="CSC_test001_tech001">
            <mets:FLocat xlink:href="file://kuvat/PICT0081.JPG" LOCTYPE="URL"/>
        </mets:file>
    </mets:fileGrp>
</mets:fileSec>
</mets:mets>
""")


def test_find_checksums():
    assert find_checksums(etree.fromstring(METS_CHECKSUM)) == \
        [['kuvat/PICT0081.JPG', 'MD5', '11c128030f203b76f2e30eeb7454c42b']]
