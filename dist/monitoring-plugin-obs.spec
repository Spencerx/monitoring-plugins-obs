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

%define nagios_plugin_etc_dir /etc/nagios

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
BuildRequires:  perl(YAML)
Requires:       perl(YAML)

%description
This a nagios/NRPE compatible plugin for checking Open Build Service

%prep
%setup

%build
/bin/true

%install
export DESTDIR=%{buildroot}
export NAGIOS_PLUGINDIR=%{nagios_plugindir}
export NAGIOS_PLUGIN_ETC_DIR=%{nagios_plugin_etc_dir}
make install

%check
make test

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root)
%doc README.md LICENSE
%dir %{nagios_libdir}
%dir %{nagios_plugindir}
%dir %{nagios_plugin_etc_dir}
%config (noreplace) %{nagios_plugin_etc_dir}/check_obs_events.yml
%{nagios_plugindir}/check_obs_events

%changelog
