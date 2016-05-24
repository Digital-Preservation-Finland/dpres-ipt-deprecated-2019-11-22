import hashlib


class BigFile(object):

    def __init__(self, algorithm='sha1'):
        # Accept MD5 and different SHA variations
        algorithm = algorithm.lower().replace('-', '').strip()
        self.checksum = hashlib.new(algorithm)

    def hexdigest(self, filename):
        with open(filename, 'rb') as input_file:
            for chunk in iter(lambda: input_file.read(1024 * 1024), b''):
                self.checksum.update(chunk)
        return self.checksum.hexdigest()

    def checksums_match(self, checksum_expected, checksum_to_test):
        return ((len(checksum_expected) > 0) and
                (checksum_expected == checksum_to_test))

    def verify_file(self, filename, hexdigest):
        file_hexdigest = self.hexdigest(filename)
        return self.checksums_match(file_hexdigest, hexdigest)
