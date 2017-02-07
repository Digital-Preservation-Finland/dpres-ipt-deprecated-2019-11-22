Overview: Information Package Tools
=======================================

This project implements tools for creating and validating Open Archival Information System (OAIS) compliant SIP/AIP/DIP packages for long term storage project (KDK PAS) at CSC - Center of Scientific Computing.

You can checkout this project from version control::

        git clone https://github.com/Digital-Preservation-Finland/dpres-ipt.git

The project contains following files:

:file:`src`
    Python packages__ for the project.

:file:`doc`
    This folder contains prose documentation, see `Documentation`__.

:file:`README.rst`
    This README file.

:file:`setup.py`
    Script for installing the project, see `Installation`__.

:file:`tests`
    Contains all the unit tests, see `Testing`__

:file:`tox.ini`
    TODO: We need to test how and if virtualenv can be used in production environments / RPM-deployments. For now RPM-installation integrates straight to system Python and integration testing is done for whole system.

    Configuration file for the test runner, see `Testing`__

__ http://docs.python.org/tutorial/modules.html#packages
__ http://tox.readthedocs.org/en/latest/


Installation
============

This software is tested with Python 2.6 and Centos 6.x / RHEL 6.x. Software will be migrated to Python 2.7 with Centos 7.x / RHEL 7.x releases ( beginning of 2014 ).
Support for Python 3 is not planned in recent future.

Installation and usage requires additional software in system $PATH:

        * Python 2.6 / 2.7
        * GNU Make

For managing SIP and AIP files:

        * Tar
        * Gzip
        * OpenSSL

For validating different file formats:

        * libxslt / xsltproc & xmllint ( with Saxon line number extensions )
        * python-lxml
        * python-mimeparse
        * python-dateutil
        * xml-xommon
        * Jhove
        * Jhove2

For AIP location database:

        * pymongo
        * MongoDB

For running unit testing additional software is required:

        * py.test, version 2.3.4 or greater
          

Installing from source
***********************

Install modules with GNU make command. This will install needed libraries and shared files to default locations::

        make install

If you want to install to some other location use prefix-environment variable::

        PREFIX=/opt/information-package-tools make install

For development setup you may want, instead of copying files, to create just symlinks to source files::

        make devinstall

Documentation
=============

For documenting the project follow de-facto Python practices:

* PEP257_ -- Docstring conventions
* PEP8_ -- Style Guide for Python Code
* PEP287_ -- reStructuredText Docstring Format

.. _PEP257: http://www.python.org/dev/peps/pep-0257/
.. _PEP8: http://www.python.org/dev/peps/pep-0008/
.. _PEP287: http://www.python.org/dev/peps/pep-0287/

Documentation is built using Sphinx_ and also single Makefile at doc/ directory to simplify things::

        cd docs
        make html

Creating PDF documentation is as simple, but you will also need pdflatex_ tool (on RHEL6 / Centos6 install pdfjam_.)::

        make pdf

.. _Sphinx: http://sphinx.pocoo.org
.. _pdflatex: http://www.tug.org/applications/pdftex/
.. _pdfjam: http://freecode.com/projects/pdfjam


Documentation is built automatically by Jenkins at pastesti4.csc.fi (build server).

For for developing documentation you can use Python SimpleHTTPServer to access HTML-documentation from browser::

    make docserver
    while true ; do make html ; sleep 5 ; done
    ... edit documentation and preview with browser http://devhost:8090...

    ... done anf finished ...
    make killdocserver

Development Guidelines
======================

#. If it's more than couple of hours of work, break it into subtasks.
#. If fixing a bug, start by writing a test that shows the bug or fix existing tests.
   If adding a feature, add a test that uses the feature.
   Make sure that the new test is failing. See Testing_.
#. Write code to fix test. Follow PEP8_.
#. Always run all tests before committing.
#. If the fix or feature is large, break it into several commits.
#. If it's really large, do the development in a feature branch
#. Commit with a descriptive commit message. Use max 50 characters on first line.
   You can refer to bugs in commit messages, e.g. "Fix KDKPAS-1", but
   also describe the change so that it's enough to read the commit message.
#. Don't add code to "future proof" the project, when the need isn't clear.
#. When the need becomes clear, don't be afraid to refactor. Don't leave
   broken windows behind!
#. When in doubt, ``import this``

.. _PEP8: http://www.python.org/dev/peps/pep-0008/

.. seealso::

    `Mozilla's commit guide <https://developer.mozilla.org/en-US/docs/Developer_Guide/Committing_Rules_and_Responsibilities>`_
        explains how to write good commit messages.

    `Jacob Kaplan-Moss' presentation <http://blip.tv/pycon-us-videos-2009-2010-2011/pycon-2011-writing-great-documentation-4899042>`_
        shows the qualities of good documentation.

Copyright
======================
All rights reserved to CSC - IT Center for Science Ltd. 
