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
