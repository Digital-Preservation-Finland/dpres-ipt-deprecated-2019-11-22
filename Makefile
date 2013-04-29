
PREFIX=
ETC=${PREFIX}/etc
INSTALLDIR=${PREFIX}/usr/lib/pas/microservices

all: info

info:
	@echo
	@echo "PAS Microservices"
	@echo
	@echo "Usage:"
	@echo "  make test 			- Run all unit tests"
	@echo "  make install		- Install microservices"
	@echo "  make devinstall	- Quick and Dirty development installation"
	@echo "  make install_deps	- Install required packages with yum"
	@echo

build:
	# Build all

test:
	# Run tests
	prove t

install:
	# Install all
	[ -d "${INSTALLDIR}" ] || mkdir -p "${INSTALLDIR}"
	install -m 755 src/* "${INSTALLDIR}/"
	install -m 644 include/etc/* "${ETC}/archivematica/MCPClient/"

devinstall:
	# quick and dirty installation...
	# not for production
	
install_deps:
	# only for testing environment
	yum -y install zip

	
