"""Test that all modules are imported without errors.

This test improves coverage reporting by importing every module in the project.
Coverage calculates line coverage only for imported modules, so untested
modules would not be included in the coverage report.

"""

import os
import pytest


@pytest.mark.parametrize('package', ['ipt'])
def test_import_modules(package):
    """Import all modules from project source directory"""

    project_path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), '..'))

    print 'Testing imports for package:', package

    package_path = os.path.join(project_path, package)

    import_count = 0
    for root, _, files in os.walk(package_path):

        for filename in files:

            if filename == '__init__.py':

                module_name = os.path.relpath(
                    os.path.join(root, filename), project_path)
                module_name = module_name.replace('/__init__.py', '')
                module_name = module_name.replace('/', '.')

                print "Importing package:", module_name
                module = __import__(module_name)

                message = "Failed importing package %s" % module_name
                assert str(type(module)) == "<type 'module'>", message
                assert not (module is None), message

                continue

            if filename.endswith('.py'):

                module_name = os.path.relpath(
                    os.path.join(root, filename), project_path)
                module_name = module_name.replace('.py', '')
                module_name = module_name.replace('/', '.')

                print "Importing module: ", module_name
                module = __import__(module_name)

                message = "Failed loading module %s" % module_name
                assert str(type(module)) == "<type 'module'>", message
                assert not (module is None), message

                import_count = import_count + 1

    assert import_count > 1
