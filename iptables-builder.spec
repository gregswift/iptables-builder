%{!?python_sitelib: %define python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

Name:      iptables-builder
Version:   0.1
Release:   1
BuildArch: noarch
Summary:   Simple wrapper script that helps generate iptables configuration
Group:     Applications/System
License:   GPLv3+
URL:       http://github.com/gregswift/%{name}
Source0:   %{name}.tgz

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:  python-setuptools

Requires:  iptables

%description
To help ease configuration management of iptables this script will read
ordered files from a directory and compile the system's iptables configuration
from them.

%prep
%setup -q -n %{name}

%build
%{__python} setup.py build

%install
%{__python} setup.py install --root=%{buildroot}  --record=INSTALLED_FILES

%files
%defattr (0644,root,root)
%config %{_sysconfdir}/${name}.conf
%dir %{_sysconfdir}/%{name}/available.d
%dir %{_sysconfdir}/%{name}/enabled.d
%attr(0750,-,-) %{_bindir}/${name}
%doc README CHANGELOG INSTALL LICENSE

%changelog
* Fri Nov 30 2012 Greg Swift <greg.swiftr@rackspace.com> - 0.1-1
- Initial version of the package
