from setuptools import setup, find_packages
from version import get_version
import os

def scripts_list():
    """Return list of command line tools from package pas.scripts"""
    scripts = []
    for modulename in os.listdir('information-package-tools/scripts'):
        if modulename == '__init__.py':
            continue
        if not modulename.endswith('.py'):
            continue
        modulename = modulename.replace('.py','')
        scriptname = modulename.replace('_','-')
        scripts.append('%s = scripts.%s:main' % (scriptname, modulename))
    print scripts
    return scripts

def main():

    """Install information-package-tools Python libraries"""

    print find_packages("information-package-tools", exclude=["*.tests", "*.tests.*", "tests.*", "tests"])

    excluded_packages = ["*.tests", "*.tests.*", "tests.*", "tests"]

    setup(
        name='information-package-tools',
        packages=find_packages('information-package-tools', exclude=excluded_packages),
        package_dir={'': 'information-package-tools'},
        version=get_version(),
        entry_points = {'console_scripts': scripts_list()})

if __name__ == '__main__':
    main()
