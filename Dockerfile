ARG EL_VERSION=9

FROM rockylinux:${EL_VERSION} AS build

ARG SPEC_FILE=libvirt.spec

RUN echo "SPEC_FILE is set to $SPEC_FILE"

# Enable CRB repository and install build dependencies
RUN dnf upgrade -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf install -y rpm-build rpmdevtools tar gzip tree

# Add non-root user for building
RUN useradd -m builder && \
    chown -R builder:builder /home/builder

# Copy the entire context (sources, specs, and build script)
COPY --chown=builder:builder . /home/builder/

# Get dependencies for all the spec files
RUN dnf builddep -y /home/builder/SPECS/*.spec && \
    dnf clean all

# Switch to builder user and set working directory
USER builder
WORKDIR /home/builder

# Set the spec file environment variable for the build script
ENV SPEC_FILE=$SPEC_FILE

# Use the consolidated build script as entrypoint
ENTRYPOINT ["/home/builder/build-rpms.sh"]
