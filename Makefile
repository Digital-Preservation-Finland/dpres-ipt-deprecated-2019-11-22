
PREFIX=
ROOT=
ETC=${ROOT}/etc
SHAREDIR=${ROOT}/${PREFIX}/share/information-package-tools
PYTHONDIR=${ROOT}/${PREFIX}/lib/python2.6/site-packages
SHELLDIR=${ROOT}/${PREFIX}/bin

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

build:
	# Build all

test:
	make -C tools/sip test

install:

	# Common data files
	[ -d "${SHAREDIR}" ] || mkdir -p "${SHAREDIR}"
	cp -r include/share/* "${SHAREDIR}/"
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;

	# SIP_python package is using Python setuptools
	cd tools/sip ; python ./setup.py install --prefix="${PREFIX}" --root="${ROOT}" --record=INSTALLED_FILES

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip

	
