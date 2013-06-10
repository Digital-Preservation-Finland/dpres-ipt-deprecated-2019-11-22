
PREFIX=
ETC=${PREFIX}/etc
INSTALLDIR=${PREFIX}/usr/lib/pas/information-package-tools
SHAREDIR=${PREFIX}/usr/share/information-package-tools
PYTHONDIR=${PREFIX}/usr/lib/python2.6/site-packages/SIPValidation

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
	@prove -r t

install:
	# Install all
	
	[ -d "${SHAREDIR}" ] || mkdir -p "${SHAREDIR}"
	cp -r include/share/* "${SHAREDIR}/"
	chmod -R 755 "${SHAREDIR}"
	find "${SHAREDIR}" -type f -exec chmod 644 \{\} \;
	
	[ -d "${PYTHONDIR}" ] || mkdir -p "${PYTHONDIR}"
	install -m 644 src/SIPValidation_python/src/* "${PYTHONDIR}/"
	

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip unzip

	
