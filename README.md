# el-libvirt-minimal
Minimal libvirt package for Enterprise Linux

## Building RPMs

This repository uses a consolidated build process with a single entrypoint script (`build-rpm.sh`) that handles all aspects of RPM building:

- Downloads source files using spectool
- Builds source RPMs (SRPM)
- Builds binary RPMs  

### Using Docker

```bash
# Build the Docker image
docker build --build-arg EL_VERSION=9 --build-arg SPEC_FILE=libvirt.spec -t rpm-builder .

# Run the build
docker run --rm -t --name rpm-builder-$(date +%s) rpm-builder
```

### Direct execution

The `build-rpm.sh` script can also be executed directly in an environment with:
- RPM build tools (rpm-build, rpmdevtools)
- Required build dependencies installed
- Running as a non-root user with proper directory permissions
