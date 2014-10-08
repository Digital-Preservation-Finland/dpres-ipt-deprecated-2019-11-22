import os


class File:

    def __init__(self, manifest_filename=None):
        if manifest_filename == None:
            self.manifest_filename = 'MANIFEST'
        else:
            self.manifest_filename = manifest_filename

    def write(self, filelist):
        """Fixity list includes digital objects relative paths in sip, mime
        types, checksums and checkum types.
        """
        manifest_path = os.path.abspath(os.path.dirname(manifest_file))
        if not os.path.exists(manifest_path):
            os.makedirs(manifest_path)

        filename = os.path.join(manifest_path,
                                self.manifest_filename)

        manifestfile = open(filename, "w")

        for fixity in filelist:
            manifestfile.write('%s %s %s %s\n' % (fixity[0], fixity[1],
                                                  fixity[2]), fixity[3])

        manifestfile.close()

    def get_filelist(self):
        """
        Create a list of lists consisting of SIP manifest line files
        """

        manifest = open(self.manifest_filename)
        line_index = 0
        wordList = []

        for lines in manifest:
            wordList.append(lines.split())

        return wordList
