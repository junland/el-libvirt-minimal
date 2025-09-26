Name:           el-libvirt-minimal
Version:        1.0.0
Release:        1%{?dist}
Summary:        Minimal libvirt package for Enterprise Linux
License:        MIT
URL:            https://github.com/junland/el-libvirt-minimal
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  systemd-rpm-macros

Requires:       libvirt-daemon
Requires:       libvirt-daemon-driver-qemu
Requires:       libvirt-daemon-driver-network
Requires:       libvirt-daemon-driver-storage
Requires:       libvirt-client
Requires:       qemu-kvm
Requires:       qemu-img

%description
A minimal libvirt package for Enterprise Linux that provides essential
virtualization capabilities with a focused set of dependencies.

%prep
%setup -q

%build
# No build steps needed for this minimal package

%install
mkdir -p %{buildroot}%{_sysconfdir}/libvirt
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}%{_bindir}

# Create a simple wrapper script for common operations
cat > %{buildroot}%{_bindir}/el-libvirt-minimal << 'EOF'
#!/bin/bash
# Simple wrapper for el-libvirt-minimal operations

case "$1" in
    start)
        systemctl start libvirtd
        ;;
    stop)
        systemctl stop libvirtd
        ;;
    status)
        systemctl status libvirtd
        ;;
    enable)
        systemctl enable libvirtd
        ;;
    disable)
        systemctl disable libvirtd
        ;;
    *)
        echo "Usage: $0 {start|stop|status|enable|disable}"
        exit 1
        ;;
esac
EOF

chmod +x %{buildroot}%{_bindir}/el-libvirt-minimal

%files
%license LICENSE
%doc README.md
%{_bindir}/el-libvirt-minimal

%post
# Enable libvirtd service
systemctl enable libvirtd >/dev/null 2>&1 || :

%preun
# Stop and disable service before uninstall
if [ $1 -eq 0 ]; then
    systemctl stop libvirtd >/dev/null 2>&1 || :
    systemctl disable libvirtd >/dev/null 2>&1 || :
fi

%changelog
* Thu Sep 26 2024 John Unland <john@example.com> - 1.0.0-1
- Initial minimal libvirt package for Enterprise Linux