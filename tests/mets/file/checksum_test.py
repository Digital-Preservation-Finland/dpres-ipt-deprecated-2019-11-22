# Common test imports / boilerplate
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../..'))
import pytest
import testcommon.settings
from testcommon.casegenerator import pytest_generate_tests

# Module to test
import ipt.mets.file.checksum

# Other imports
from hashlib import md5, sha1
import shutil
import tempfile

DATAROOT = os.path.abspath(
    os.path.join(os.path.dirname(__file__), '../../', 'data'))
HASHED_STRING = 'foo'
VALID_MD5HASH = 'acbd18db4cc2f85cedef654fccc4a4d8'
VALID_SHA1HASH = '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'
SIPDIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), '../../data/test-sips'))


class TestFindChecksumsAndFiles:

    testcases = {
        "test_extract_checksums_from_mets": [
            {"testcase": {
             "name": 'CSC_test001',
                "errormessage": [],
                "testpath": os.path.join(DATAROOT, '01_ChecksumParser_test/sips/CSC_test001'),
                "data": [['kuvat/PICT0081.JPG', 'md5', '762108c2ca8680fdb55fb67170a55e70'],
                         ['kuvat/PICT0102.JPG', 'md5',
                          '11c128030f203b76f2e30eeb7454c42b'],
                         ['kuvat/P1020137.JPG', 'md5', 'c29f1b25b22318d11bc7f60cdb48029d']]
             }},
            {"testcase": {
             "name": 'CSC_test002',
                "errormessage": [],
                "testpath": os.path.join(DATAROOT, '01_ChecksumParser_test/sips/CSC_test002'),
                "data": [['kuvat/PICT0081.JPG', 'md5', '762108c2ca8680fdb55fb67170a55e70'],
                         ['kuvat/PICT0102.JPG', 'md5', '11c128030f203b76f2e30eeb7454c42b']]
             }},
            {"testcase": {
             "name": 'CSC_test003',
                "errormessage": [('No checksum found for file', 'metadata.xml', 2)],
                "testpath": os.path.join(DATAROOT, '01_ChecksumParser_test/sips/CSC_test003'),
                "data": [['kuvat/PICT0081.JPG', 'md5', '762108c2ca8680fdb55fb67170a55e70'],
                         ['kuvat/PICT0102.JPG', 'md5', '11c128030f203b76f2e30eeb7454c42b']]
             }},
            {"testcase": {
             "name": 'missingFile',
                "errormessage": [('File missing: kuvat/PICT0081.JPG')],
                "testpath": os.path.join(DATAROOT, '01_ChecksumParser_test/sips/missingFile'),
                "data": [['kuvat/PICT0081.JPG', 'md5', '762108c2ca8680fdb55fb67170a55e70'],
                         ['kuvat/PICT0102.JPG', 'md5',
                          '11c128030f203b76f2e30eeb7454c42b'],
                         ['kuvat/P1020137.JPG', 'md5', 'c29f1b25b22318d11bc7f60cdb48029d']]
             }}
        ]
    }

    def test_extract_checksums_from_mets(self, testcase):

        try:
            resultpath = tempfile.mkdtemp()

            assert 1 == 1, "hello"

            filename = os.path.join(testcase["testpath"], 'mets.xml')

            parser = ipt.mets.file.checksum.Checker(filename, testcase["testpath"])

            # Get result from metsParser
            result = parser.extract_checksums_from_mets()

            # Expected return value
            expected = (testcase["data"],
                        testcase["errormessage"])

            # Error message
            message = '\n'.join(["Testcase: %s" % testcase["name"],
                                 "Expected:", str(expected), "Got:",
                                 str(result)])

            assert result == expected, message

        finally:
            shutil.rmtree(resultpath)


class TestFileExistenceAndChecksums:

    #
    # TODO: Implement these tests with parametrized test below
    #

    #    def test_ok_list(self):
    #        checksums =
    #        StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
    #./kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d
    #./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
    #./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
    #        assert mets.file.checksum.check_file_existence_and_checksums(
    #            checksums, os.path.join(SIPDIR, 'CSC_test001')) == [
    #                ('varmiste.sig', u'Nonlisted file')]
    #
    #    def test_missing_files(self):
    #        checksums =
    #        StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
    # missing_file:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    #./kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d
    #./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
    #./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
    #        assert set(mets.file.checksum.check_file_existence_and_checksums(
    #            checksums, os.path.join(SIPDIR, 'CSC_test001'))) == set([
    #                ('missing_file:md5:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    #                'File does not exist'),
    #                ('varmiste.sig', u'Nonlisted file')])
    #
    #    def test_extra_files(self):
    #        checksums =
    #        StringIO("""./mets.xml:md5:ce8e844458963506e0bf790ec1a9546e
    #./kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70
    #./kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b""")
    #        assert set(mets.file.checksum.check_file_existence_and_checksums(
    #            checksums, os.path.join(SIPDIR, 'CSC_test001'))) == set([
    #                ('kuvat/P1020137.JPG', 'Nonlisted file'),
    #                ('varmiste.sig', u'Nonlisted file')])

    testcases = {
        "test_check_file_existence_and_checksums": [
            {
                "testcase": 'Test succesful validation',
                "sip_name": 'CSC_test001',
                "mets_file": 'mets.xml',
                "checksums": ["mets.xml:md5:3880512309cbf38fe46ff8cb0e73935e",
                              "kuvat/P1020137.JPG:md5:c29f1b25b22318d11bc7f60cdb48029d",
                              "kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70",
                              "kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b",
                              "varmiste.sig:md5:638b00faf5b39816eded1ede9fe43eec"],
                "expected_result":
                [('Checksum OK md5', 'mets.xml', 0),
                 ('Checksum OK md5', 'kuvat/P1020137.JPG', 0),
                 ('Checksum OK md5', 'kuvat/PICT0081.JPG', 0),
                 ('Checksum OK md5', 'kuvat/PICT0102.JPG', 0),
                 ('Checksum OK md5', 'varmiste.sig', 0)]
            },
            {
                "testcase": 'Test extra files files',
                "sip_name": 'CSC_test002',
                "mets_file": 'mets.xml',
                "checksums": [
                    "mets.xml:md5:3880512309cbf38fe46ff8cb0e73935e",
                    "kuvat/P1020137.JPG:md5:aaaaaaaaaaaaaaaaa",
                    "kuvat/PICT0081.JPG:md5:762108c2ca8680fdb55fb67170a55e70",
                    "kuvat/PICT0102.JPG:md5:11c128030f203b76f2e30eeb7454c42b"],
                "expected_result":
                [('Checksum does not match. expected: 3880512309cbf38fe46ff8cb0e73935e got: 8be50ba15a2cd28c59b8d6248ef3da58', 'mets.xml', 2),
                 ('File does not exist', 'kuvat/P1020137.JPG', 2),
                 ('Checksum OK md5', 'kuvat/PICT0081.JPG', 0),
                 ('Checksum OK md5', 'kuvat/PICT0102.JPG', 0),
                 ('Nonlisted file', 'varmiste.sig', 2)]
            }
        ],
    }

    def test_check_file_existence_and_checksums(self, testcase, sip_name,
                                                mets_file, checksums,
                                                expected_result):

        # Prepare parameters
        sip_path = os.path.join(SIPDIR, sip_name)
        mets_file = os.path.join(sip_path, mets_file)
        mets_files = []
        # print checksums

        for line in checksums:
            fixity = line.split(':')
            print "fixity", fixity
            mets_files.append(fixity)

        print "mets_files", mets_files

        # Run test
        checksumtool = ipt.mets.file.checksum.Checker()
        checksumtool.sip_dir = sip_path
        checksumtool.ignore_filenames = []
        test_result = checksumtool.check_file_existence_and_checksums(
            mets_files)

        # Print report
        assert test_result == expected_result, '\n'.join([
            "Error in testcase %s" % sip_name,
            "Expected:", str(expected_result),
            "Got:", str(test_result)])
