"""Shell command line utilities for tests"""

import os
import sys
import subprocess
import cStringIO

import testcommon.settings

def run_command(command):
    """Run command using source code binaries and libraries
   
        Note: This should be deprecated. Better to use run_main() function
        below.

    """

    proc = subprocess.Popen([command], shell=True, stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)

    (stdout, stderr) = proc.communicate()

    return (proc.returncode, stdout, stderr)

def run_main(the_main_function, arguments):
    """Emulate exec call for command line tool main() functions.

    This function runs given function and captures any stdout/stderr
    output.

    Usage::

        import scriptmodule
        (returncode, stdout, stderr) = run_command(scriptmodule.main, options, arguments)

    Parameters:

        :the_main_function: Function reference to execute
        :options: Options to pass ass optparse.parse_options() options.
        :args: Options to pass ass optparse.parse_options() argumens.


    """

    stdout_original = sys.stdout
    stderr_original = sys.stderr
    sys.stdout = cStringIO.StringIO()
    sys.stderr = cStringIO.StringIO()

    returnstatus = -1

    try:
        returnstatus = the_main_function(arguments)
    except BaseException as exception:
        sys.stderr.write(str(exception))
    finally:
        stdout = sys.stdout.getvalue()
        stderr = sys.stderr.getvalue()
        sys.stdout = stdout_original
        sys.stderr = stderr_original

    return (returnstatus, stdout, stderr)

