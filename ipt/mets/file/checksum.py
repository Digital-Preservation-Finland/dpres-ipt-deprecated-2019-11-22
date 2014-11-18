import os

import ipt.mets.parser

import ipt.fileutils.checksum
import ipt.fileutils.filefinder


class ValidationResult:

    def __init__(self):
        pass

    def __str__(self):
        return "foo"


class Checker:
    """
    Checker class.
    """
    ignore_filenames = None
    sip_dir = None
    xmlroot = None

    def __init__(self, mets_filename=None, sip_dir=None):

        self.mets = ipt.mets.parser.LXML(mets_filename)
        self.sip_dir = sip_dir

        self.ignore_filenames = ['mets.xml', 'varmiste.sig']

        # Debugging output
        # print self.mets.xmlroot()

    def extract_checksums_from_mets(self):
        """Find all filenames with checksums from the given ElementTree.

        Returns two variables: list of file checksums and list of error
        messages.

            ([filename, algorithm_name, hexdigest],
             [ ... list of errormessages ... ])

        We are doing the searching with XPath,
        https://en.wikipedia.org/wiki/Xpath.
        XPath is a query language for finding elements from XML documents, see
        full definition of it at http://www.w3.org/TR/xpath/.

        This searches for all <file> elements from the METS namespace. The
        namespace definition shorthand in the actual XML doesn't matter, only
        that the full namespace URL is http://www.loc.gov/METS/.

        The returned list of error contains tuples, where the first object
        is the error message, second object is the given line and the third one
        is the criticality.

        The errors are:

        - "Invalid line" if the line does not match the syntax.

        - "Unknown algorithm" if the given algorithm name is not known.

        - "Checksum invalid" if the checksum does not match the algorithm
          (too long, too short, or nonvalid characters).

        - "Checksum mismatch" if the calculated checksum differs from the given.

        - "File does not exist" if a file path given in checksum file is not
          found in the filesystem.

        - "Nonlisted file" if there is a file in the working folder, that no
          checksum is given for. In this case the first part of the tuple is the
          filename."""

        results = []
        errors = []

        mets_files = self.mets.mets_files()

        if not mets_files:
            errors.append(
                ("Element <file> was not found from METS document.", '', 2))
            return results, errors

        # Searches in all techMD elements, that have an ID attribute matching
        # one of the ids in this files' ADMID (a space delimited list of ids)
        for mets_file in mets_files:

            fileurl = self.mets.get_file_location(mets_file)

            if not fileurl:

                if mets_file.attrib['ID']:
                    errors.append(
                        ("File url not found in <file> element with \
                        ID attribute value", mets_file.attrib['ID'], 2))
                else:
                    errors.append(
                        ("File url not found in <file> element. The \
                        <file> element does not have and ID either.", '', 2))
                continue

            # and change it to normal filesystem path
            filename = fileurl.replace('file://', '')

            # print "filename", filename

            if not os.path.isfile(os.path.join(self.sip_dir, filename)):
                errors.append(('File missing: %s' %
                               os.path.relpath(os.path.join(
                                               self.sip_dir, filename),
                                               self.sip_dir)))

            # Sanitize filenames...
            filename = filename.lstrip('/')

            fixity = self.mets.get_file_fixity_with_admid(
                mets_file.attrib['ADMID'])
            if fixity:
                results.append([filename, fixity['algorithm'],
                                fixity['digest']])

            else:
                errors.append(("No checksum found for file", filename, 2))

        return results, errors

    def checkFileExistence(results, files):
        """Check wether files mentioned in mets exist."""

    # TODO: These functions are refactored and fixed from old passi-sources
    #
    # Just brought up to working point and fixed tests. Major code cleanup
    # still needed.
    def get_files_and_checksums_from_mets_file(self, filename):
        """Calls checksum validation between mets file and files

        The input is the mets file. Returns the output of find_checksums()
        """

        self.mets = ipt.mets.parser.LXML(filename)
        self.sip_dir = os.path.dirname(filename)
        self.sip_parent = os.path.dirname(self.sip_dir)

        self.mets_filename = os.path.basename(filename)

        # print "sip_dir", self.sip_dir

        return self.extract_checksums_from_mets()

    def verify_file(self, basepath, filename, algorithm, hexdigest):
        """Verify hash of a file with given algorithm and hexdigest.

        Updates error message list in case of error.
        """

        errors = []

        checksum = ipt.fileutils.checksum.BigFile(algorithm)
        file_hexdigest = checksum.hexdigest(filename)

        filename_relative = os.path.relpath(filename, basepath)

        if hexdigest != file_hexdigest:
            errors.append(("Checksum does not match. expected: %s got: %s" %
                           (hexdigest, file_hexdigest), filename_relative, 2))
        else:
            errors.append(("Checksum OK %s" % algorithm, filename_relative, 0))

        return errors

    def remove_ignored_files(self, files):
        for filename in self.ignore_filenames:
            if filename in files:
                files.remove(filename)
        return files

    def check_file_existence_and_checksums(self, mets_file_checksums):
        """Verify file existance and checksums based on given checksum file.

        Input is the mets file, e.g. "./mets.xml"

        """

        errors = []

        files = ipt.fileutils.filefinder.get_files_in_tree(self.sip_dir)

        for mets_fixity in mets_file_checksums:

            print self.sip_dir
            print mets_fixity[0]
            print "files: ", files

            filename = mets_fixity[0]
            algorithm = mets_fixity[1]
            digest = mets_fixity[2]

            if filename.startswith('./'):
                filename = filename[len('./'):]

            if filename in files:
                files.remove(filename)
                result_errors = self.verify_file(
                    self.sip_dir, os.path.join(self.sip_dir, filename),
                    algorithm, digest)
                errors.extend(result_errors)
            else:
                errors.append(("File does not exist", filename, 2))

        files = self.remove_ignored_files(files)

        errors.extend(map(lambda x: ("Nonlisted file", x, 2), files))

        return errors
