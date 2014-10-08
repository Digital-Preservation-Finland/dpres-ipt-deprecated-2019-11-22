PREFIX=/usr
ROOT=/
ETC=/etc
SHAREDIR=${ROOT}${PREFIX}/share/information-package-tools
XMLCATALOGDIR=${ETC}/xml
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

	# Install XML Schema catalogs
	#if [ -a "${XMLCATALOGDIR}/catalog" ]; then mv "${XMLCATALOGDIR}/catalog" "${XMLCATALOGDIR}/catalog."`date +%s`; fi; 
	#install -m 644 include/etc/xml/catalog "${XMLCATALOGDIR}/"

	# write version module
	python version.py > "information-package-tools/version.py"

	# Use Python setuptools
	python setup.py build ; python ./setup.py install -O1 --prefix="${PREFIX}" --root="${ROOT}" --record=INSTALLED_FILES
	INSTALLED_FILES | sed 's/^/\//g' >> INSTALLED_FILES

	# setup.py seems to be unable to create directories,
	# create them here if needed

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip
	
test:
	py.test tests

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
