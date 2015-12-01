"""Utility functions."""

import os
import subprocess


def run_command(cmd, stdout=subprocess.PIPE):
    """Execute command.

    :returns: Tuple (statuscode, stdout, stderr)
    """
    #environment = os.environ.copy()
    proc = subprocess.Popen(cmd,
                            stdout=stdout,
                            stderr=subprocess.PIPE,
                            shell=False)

    (stdout, stderr) = proc.communicate()
    statuscode = proc.returncode
    print ":"
    print stdout
    print stderr
    print statuscode
    print ":"

    return statuscode, stdout, stderr
