"""Utility functions."""

import subprocess


def run_command(cmd, stdout=subprocess.PIPE):
    """Execute command.

    :returns: Tuple (statuscode, stdout, stderr)
    """
    proc = subprocess.Popen(cmd,
                            stdout=stdout,
                            stderr=subprocess.PIPE,
                            shell=False)

    (stdout, stderr) = proc.communicate()
    statuscode = proc.returncode

    return statuscode, stdout, stderr
