# vim:ft=spec

%define file_prefix M4_FILE_PREFIX
%define file_ext M4_FILE_EXT

%define file_version M4_FILE_VERSION
%define file_release_tag %{nil}M4_FILE_RELEASE_TAG
%define file_release_number M4_FILE_RELEASE_NUMBER
%define file_build_number M4_FILE_BUILD_NUMBER
%define file_commit_ref M4_FILE_COMMIT_REF

Name:           information-package-tools
Version:        %{file_version}
Release:        %{file_release_number}%{file_release_tag}.%{file_build_number}.git%{file_commit_ref}%{?dist}
Summary:        Tools for KDKPAS SIP/AIP/DIP-handling
Group:          System Environment/Library
License:        MIT
URL:            http://www.csc.fi
Source0:        %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}.%{file_ext}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch

Requires: python python-mimeparse python-dateutil xml-common pymongo ghostscript
Requires: libxslt unzip jhove python-setuptools python-lxml
# ClamAV installation requires these to work
Requires: clamav libtool-ltdl
Requires: warc-tools >= 4.8.3 ffmpeg kdk-mets-catalog
BuildRequires:	pytest

%description
Tools for KDKPAS SIP/AIP/DIP-handling.

%prep
find %{_sourcedir}
%setup -n %{file_prefix}-v%{file_version}%{?file_release_tag}-%{file_build_number}-g%{file_commit_ref}

%build
# do nothing

%install
make install PREFIX="%{_prefix}" ROOT="%{buildroot}"
echo "-- INSTALLED_FILES"
cat INSTALLED_FILES
echo "--"

%post
# Add our catalogs to the system centralised catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/information-package-tools/digital-object-catalog/digital-object-catalog.xml" \
/etc/xml/catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/information-package-tools/kdk-mets-catalog/catalog-local.xml" \
/etc/xml/catalog
%{_bindir}/xmlcatalog --noout --add "nextCatalog" "catalog" \
"/etc/xml/information-package-tools/private-catalog/private-catalog.xml" \
/etc/xml/catalog

%postun
# When the package is uninstalled, remove the catalogs
if [ "$1" = 0 ]; then
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/information-package-tools/digital-object-catalog/digital-object-catalog.xml" \
  /etc/xml/catalog
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/information-package-tools/kdk-mets-catalog/catalog-local.xml" \
  /etc/xml/catalog
  %{_bindir}/xmlcatalog --noout --del \
  "/etc/xml/information-package-tools/private-catalog/private-catalog.xml" \
  /etc/xml/catalog
fi

%clean

%files -f INSTALLED_FILES
%defattr(-,root,root,-)
/usr/share/information-package-tools
/etc/xml/information-package-tools

# TODO: For now changelot must be last, because it is generated automatically
# from git log command. Appending should be fixed to happen only after %changelog macro
%changelog

