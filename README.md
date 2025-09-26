# el-libvirt-minimal
Minimal libvirt package for Enterprise Linux

## Overview

This package provides a minimal libvirt setup for Enterprise Linux systems, including essential virtualization components and dependencies.

## Features

- Minimal dependency set for basic virtualization
- Support for QEMU/KVM
- Network and storage drivers
- Simple management wrapper script

## Building

### Automated Build (GitHub Actions)

The repository includes a GitHub Actions workflow that automatically builds RPM packages for Enterprise Linux 8 and 9 in Docker containers. The workflow is triggered on:

- Pushes to `main` or `develop` branches
- Pull requests to `main`
- Release publications
- Manual workflow dispatch

Built RPM packages are available as workflow artifacts.

### Manual Build

To build the RPM package manually:

1. On an Enterprise Linux system (8 or 9), install build tools:
   ```bash
   dnf install -y rpm-build rpmdevtools
   rpmdev-setuptree
   ```

2. Copy the spec file and create source tarball:
   ```bash
   cp el-libvirt-minimal.spec ~/rpmbuild/SPECS/
   tar czf ~/rpmbuild/SOURCES/el-libvirt-minimal-1.0.0.tar.gz .
   ```

3. Build the RPM:
   ```bash
   rpmbuild -ba ~/rpmbuild/SPECS/el-libvirt-minimal.spec
   ```

## Installation

Install the built RPM package:
```bash
sudo dnf install el-libvirt-minimal-1.0.0-1.el9.noarch.rpm
```

## Usage

After installation, use the included wrapper script:

```bash
# Start libvirt service
el-libvirt-minimal start

# Check status
el-libvirt-minimal status

# Stop service
el-libvirt-minimal stop

# Enable service at boot
el-libvirt-minimal enable
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
