#
# spec file for package monitoring-plugins-apache2
#
# Copyright (c) 2013-2014 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

Name:           monitoring-plugin-obs
Version:        0.0.0
Release:        0
License:        GPL-3.0
Summary:        Nagios/NRPE compatible plugin for checking Open Build Service
Url:            https://github.com/timdaman/check_docker
Group:          System/Monitoring

Source:         %{name}-%{version}.tar.xz

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch
BuildRequires:  nagios-rpm-macros

%description
This a nagios/NRPE compatible plugin for checking Open Build Service

%prep
%setup

%build
/bin/true

%install
make install

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root)
%doc README.md license.txt
%dir %{nagios_libdir}
%dir %{nagios_plugindir}
%{nagios_plugindir}/check_docker

%changelog
