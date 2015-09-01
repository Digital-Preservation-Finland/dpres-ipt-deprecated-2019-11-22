import tempfile
import os
import subprocess
import shutil


def run_command(cmd, close_fds=False, print_=True):
    """Run command in shell"""
    if print_ is True:
        print cmd
    proc = subprocess.Popen(cmd,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            shell=True,
                            close_fds=close_fds)

    (stdout, stderr) = proc.communicate()

    return (proc.returncode, stdout, stderr)


class Utils:

    temp_dir = None
    sip_directory = None

    def __del__(self):
        """ Remove temp dir

        """

        if self.temp_dir is not None:
            if os.path.exists(self.temp_dir):
                shutil.rmtree(self.temp_dir)

    def __init__(self):
        """Initialize class and create temporary directory"""
        # Setup SIP name and other variables
        self.__del__()
        self.temp_dir = None

    def tempdir(self, directory):
        """Create and return temporary directory with path::

            self.temp_dir + directory

        """
        if self.temp_dir is None:
            self.temp_dir = tempfile.mkdtemp(
                prefix='ipt-test.')

        directory = os.path.join(self.temp_dir, directory)
        if not os.path.exists(directory):
            os.makedirs(directory)

        return directory


def create_test_bagit(bagit_path):
    """Create test bagit."""
    sip_path = os.path.join(bagit_path, 'data', 'transfers', 'sippi')

    os.makedirs(sip_path)

    mets_path = os.path.join(sip_path, 'mets.xml')
    with open(mets_path, 'w') as mets:
        mets.write('asfasdfasdfsda')

    image_path = os.path.join(sip_path, 'kuvat')
    os.makedirs(image_path)

    file_1_path = os.path.join(sip_path, 'file_1.txt')
    file_2_path = os.path.join(image_path, 'image1.jpg')
    with open(file_1_path, 'w') as infile:
        infile.write('abcd')
    with open(file_2_path, 'w') as infile:
        infile.write('abcdef')

    with open(os.path.join(bagit_path, 'manifest-md5.txt'), 'w') as outfile:
        outfile.write('e2fc714c4727ee9395f324cd2e7f331f ' + os.path.join(
            'data', 'file.txt') + '\n')
        outfile.write('e80b5017098950fc58aad83c8c14978e ' + os.path.join(
            'data', 'kuvat', 'file2.txt') + '\n')
    with open(os.path.join(bagit_path, 'bagit.txt'), 'w') as outfile:
        outfile.write('foo\n')
