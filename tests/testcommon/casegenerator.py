""" Generate nice parametrized test cases

Your test module should look something like this:

    import pytest
    import testcommon.settings
    from testcommon.casegenerator import casegenerator

    import module.to.test

    class TestMetsFileChecksumTool:

        testcases = {
            "test_first_test_function" : [
                { 
                    "name" : 'CSC_test001',
                    "testdata": [],
                    "expected_result": []
                },
                { ... params for second test case ... },
                ... etc ...
            ],

            "test_second_test_function" : [
                ... etc ...
            ]

        }
        
        def test_first_test_function(self, name, testdata,
                                           expected_result):

            ... do something with testdata & expected_result ...

"""


def pytest_generate_tests(metafunc):
    # called once per each test function
    funcarglist = metafunc.cls.testcases[metafunc.function.__name__]
    argnames = list(funcarglist[0])
    metafunc.parametrize(argnames, [[funcargs[name] for name in argnames]
                                    for funcargs in funcarglist])
