Overview: Information Package Tools
=======================================

This project implements tools for creating and validating Open Archival Information System (OAIS) compliant SIP/AIP/DIP packages for long term storage project (KDK PAS) at CSC - Center of Scientific Computing.

You can checkout this project from version control::

        git clone https://firname.secondname@source.csc.fi/scm/git/pas/information-package-tools

if you have a user account on source.csc.fi with read permissions. If not,
contact `EDEN team`_. You can also see the current source files at:

        https://source.csc.fi/scm/git/pas/information-package-tools/.

.. _`EDEN team`: https://confluence.csc.fi/display/EDEN

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


Installing from RPM packages
****************************

For production deployment there are separate build scripts for RPM packages::

        git clone https://firstname:lastname@source.csc.fi/scm/git/pas/pas-rpm

See documentation at pas-rpm repository for instructions how to build these RPM packages.

.. _setup.py: http://docs.python.org/2/distutils/setupscript.html


Testing
=======

For development / testing it is easiest to use pre-configured VirtualBox_ virtual machines. These are managed with VagrantUp_. Required configuration files are maintained in version control::

        git clone https://firstname.lastname@source.csc.fi/scm/git/pas/vm

For installing and operating development virtualmachines see the docs at pas/vm repository.

.. _VirtualBox: http://www.virtualbox.org
.. _VagrantUp: http://www.vagrantup.com

Start your server with and login to server::

        cd vm/ingest
        vagrant up
        ssh ingest

TODO: tools/sip path will be removed after code cleanup/ refactoring

Change to project directory and run all tests::

        cd scratch/information-package-tools/tools/sip
        make test

For debugging single component it is faster to run single test::

        py.test -s -v tests/modulename_test.py

                or continuous testing...

        while true ; do
                py.test -s -v tests/modulename_test.py
                sleep 5
        done

If you're using a GUI editor / IDE you may find it useful to run rsync_. from `localhost` to `virtual machine`::


        while true ; do
                rsync -delete -e ssh -avz information-package-tools spock@ingest:scratch/
                sleep
        done

.. _rsync: http://www.samba.org/rsync/

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

.. note::

        For now documentation is built automatically at pastesti4.csc.fi (build server) & scratch.csc.fi. Just one server should be enough!

To update the online documentation, run::

    scp -r _build/html/* sampo:/p/net/scratch.csc.fi/projects/passi

after rebuilding the docs. If you get a permission error when accessing
https://scratch.csc.fi/projects/passi/, you need to log in to sampo and run::

    chmod -R g+rwX /p/net/scratch.csc.fi/projects/passi
    chmod -R o+rX /p/net/scratch.csc.fi/projects/passi

For for developing documentation you can use Python SimpleHTTPServer to access HTML-documentation from browser::

    make docserver
    while true ; do make html ; sleep 5 ; done
    ... edit documentation and preview with browser ...

    ... done anf finished ...
    make killdocserver

Bugs
====

Report bugs to CSC's Jira_.

.. _Jira: https://jira.csc.fi/browse/KDKPAS


Development Guidelines
======================

#. When you identify a task, report it to Jira_.
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
#. After you have done a task, close the issue in Jira_.
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

