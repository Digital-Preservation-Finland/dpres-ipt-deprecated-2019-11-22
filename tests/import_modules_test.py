"""Test that all modules import correctly.

Note: As (hoped) side-effect also modules that have no specific unit tests
written.

"""

import os
import sys

def test_import_modules():
    """Import all modules from project source directory"""

    source_dir = os.path.abspath(os.path.join(os.path.dirname(__file__),
        '../src'))

    sys.path.insert(0, source_dir)

    for root, dirs, files in os.walk(source_dir):
        for filename in files:
       
            if filename.startswith('__init__'):
                continue

            if filename.endswith('.py'):

                module_name = os.path.relpath(os.path.join(root, filename),
                        source_dir)
                module_name = module_name.replace('.py', '')
                module_name = module_name.replace('/', '.')
                print "importing module: ", module_name
                module = __import__(module_name)
                message = "Failed loading module %s" % module_name
                assert str(type(module)) == "<type 'module'>", message
                assert not (module is None), message




