MOCK_CONFIG=stable-6-x86_64
ROOT=/
PREFIX=/usr
PYTHONDIR=${PREFIX}/lib/python2.6/site-packages
SHELLDIR=${PREFIX}/bin

MODULES=fileutils mets schematron sip xml xmllint

all: info

info:
	@echo
	@echo "PAS dpres-ipt"
	@echo
	@echo "Usage:"
	@echo "  make test 			- Run all unit tests"
	@echo "  make install		- Install dpres-ipt"
	@echo "  make devinstall	- Quick and Dirty development installation"
	@echo "  make install_deps	- Install required packages with yum"
	@echo

install:
	# Cleanup temporary files
	rm -f INSTALLED_FILES

	# write version module
	python version.py > "ipt/version.py"

	# Use Python setuptools
	python setup.py build ; python ./setup.py install -O1 --prefix="${PREFIX}" --root="${ROOT}" --record=INSTALLED_FILES
	cat INSTALLED_FILES | sed 's/^/\//g' >> INSTALLED_FILES

	# setup.py seems to be unable to create directories,
	# create them here if needed

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip
	
test:
	py.test -svvvv --junitprefix=dpres-ipt --junitxml=junit.xml tests

docs:
	make -C doc html
	make -C doc pdf

docserver:
	make -C doc docserver

killdocserver:
	make -C doc killdocserver

coverage:
	py.test tests --cov=ipt --cov-report=html
	coverage report -m
	coverage html
	coverage xml

clean: clean-rpm
	find . -iname '*.pyc' -type f -delete
	find . -iname '__pycache__' -exec rm -rf '{}' \; | true

clean-rpm:
	rm -rf rpmbuild

rpm-sources:
	create-archive.sh
	preprocess-spec-m4-macros.sh include/rhel6

rpm: clean-rpm rpm-sources
	build-rpm.sh ${MOCK_CONFIG}

e2e-localhost-cleanup: .e2e/ansible-fetch
	cd .e2e/ansible ; ansible-playbook -i inventory/localhost e2e-pre-test-cleanup.yml

.e2e/ansible:
	git clone https://source.csc.fi/scm/git/pas/ansible-preservation-system .e2e/ansible

.e2e/ansible-fetch: .e2e/ansible
	cd .e2e/ansible ; \
		git fetch ; \
		git checkout master ; \
		git reset --hard origin/master ; \
		git clean -fdx ; \
		git status
