PREFIX=/usr
ROOT=/
ETC=${ROOT}/etc
SHAREDIR=${ROOT}${PREFIX}/share/information-package-tools
PYTHONDIR=${ROOT}${PREFIX}/lib/python2.6/site-packages
SHELLDIR=${ROOT}${PREFIX}/bin

MODULES=fileutils mets schematron sip xml xmllint

all: info

info:
	@echo
	@echo "PAS information-package-tools"
	@echo
	@echo "Usage:"
	@echo "  make test 			- Run all unit tests"
	@echo "  make install		- Install information-package-tools"
	@echo "  make devinstall	- Quick and Dirty development installation"
	@echo "  make install_deps	- Install required packages with yum"
	@echo

install:
	# Cleanup temporary files
	rm -f INSTALLED_FILES

	# Common data files
	[ -d "${SHAREDIR}" ] || mkdir -p "${SHAREDIR}"
	cp -r include/share/* "${SHAREDIR}/"
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

	# SIP_python package is using Python setuptools
	python setup.py build ; python ./setup.py install -O1 --prefix="${PREFIX}" --root="${ROOT}" --record=INSTALLED_FILES
	INSTALLED_FILES | sed 's/^/\//g' >> INSTALLED_FILES

	# setup.py seems to be unable to create directories,
	# we create them here
	mkdir -p ${ROOT}var/cache/schematron-validation
	chmod 777 ${ROOT}var/cache/schematron-validation

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip
	
test:
	cd tests ; py.test

docs:
	make -C doc html
	make -C doc pdf

docserver:
	make -C doc docserver

killdocserver:
	make -C doc killdocserver

coverage:
	coverage -e
	coverage -x test.py
	coverage -r -m
	coverage -b -d coverage-html

clean:
	find . -iname '*.pyc' -type f -delete
	find . -iname '__pycache__' -exec rm -rf '{}' \; | true
