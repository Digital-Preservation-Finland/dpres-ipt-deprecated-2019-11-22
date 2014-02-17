"""
Gets the current version number.
If in a git repository, it is the current git tag.
Otherwise it is the one contained in the PKG-INFO file.
 
To use this script, simply import it in your setup.py file
and use the results of get_version() as your package version:
 
    from version import *
 
    setup(
        ...
        version=get_version(),
        ...
    )
"""

__all__ = ('get_version')

import os.path
import re
import sys
from subprocess import Popen, PIPE

VERSION_RE = re.compile('^Version: (.+)$', re.M)

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
PKG_INFO_FILENAME = os.path.join(PROJECT_ROOT, 'PKG-INFO')

def call_git_describe():
    """docstirng"""
    cmd = 'git describe --abbrev --tags --match v[0-9]*'.split()
    print >> sys.stderr, ' '.join(cmd)
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE)
    stdout = proc.communicate()[0]
    return stdout.strip()

def write_pkg_info():

    if os.path.isfile(PKG_INFO_FILENAME):
        return

    match = re.match(r".*-v([\d\.]+-[^-]+-g[^/]+)", PROJECT_ROOT)
    if match:
        version = match.group(1)
    else:
        version = '0.0'

    #print >> sys.stderr, "%s: Writing version info to '%s'..." % (
    #        PKG_INFO_FILENAME)
    print >> sys.stderr, "Writing version info to '%s'..." % (
            PKG_INFO_FILENAME)
    with open(PKG_INFO_FILENAME, 'w') as info:
        info.write("Metadata-Version: 1.0\n")
        info.write("Name: microservice\n")
        info.write("Version: %s\n" % version)
        info.write("Summary: UNKNOWN\n")
        info.write("Home-page: UNKNOWN\n")
        info.write("Author: UNKNOWN\n")
        info.write("Author-email: UNKNOWN\n")
        info.write("License: UNKNOWN\n")
        info.write("Description: UNKNOWN\n")
        info.write("Platform: UNKNOWN\n")
        info.close()


def get_version():
    if os.path.isdir(os.path.join(PROJECT_ROOT, '.git')):
        version_git = call_git_describe()

        # PEP 386 compatibility
        if version_git:
            version = "%s-%s" % (
                '.post'.join(version_git.split('-')[:2]),
                '-'.join(version_git.split('-')[2:])
            )
        else:
            version = '0.0'

        print >>sys.stderr, "Version number from GIT repo: " + version

    else:
        write_pkg_info()
        with open(os.path.join(PKG_INFO_FILENAME)) as f:
            version = VERSION_RE.search(f.read()).group(1)
        print >> sys.stderr, "Version number from PKG-INFO: " + version

    return version


if __name__ == '__main__':
    print "__version__ = '%s'" % get_version()
