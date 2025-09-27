ARG EL_VERSION=9
ARG SPEC_FILE=libvirt.spec
FROM rockylinux:${EL_VERSION} AS build

# Enable CRB repository and install build dependencies
RUN dnf upgrade -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf install -y rpm-build rpmdevtools tar gzip

# Add non-root user for building
RUN useradd -m builder && \
    mkdir -vp /home/builder/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS} && \
    chown -R builder:builder /home/builder

# Copy SOURCES and SPECS
COPY SOURCES /home/builder/rpmbuild/SOURCES/
COPY SPECS /home/builder/rpmbuild/SPECS/

# Get dependencies for all the spec files
RUN dnf builddep -y /home/builder/rpmbuild/SPECS/*.spec && \
    dnf clean all

# Get sources of all the spec files
RUN spectool -g -C /home/builder/rpmbuild/SOURCES/ /home/builder/rpmbuild/SPECS/*.spec

# Set ownership for builder user
RUN chown -R builder:builder /home/builder

# Switch to builder user
USER builder

# Set working directory
WORKDIR /home/builder/rpmbuild

# Build the SRPM
RUN rpmbuild -bs SPECS/$SPEC_FILE

# Build the binary RPM
RUN rpmbuild -bb SPECS/$SPEC_FILE

FROM scratch AS output
COPY --from=build /home/builder/rpmbuild/RPMS/ /rpms/
COPY --from=build /home/builder/rpmbuild/SRPMS/ /srpms/
