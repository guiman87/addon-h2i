# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM="bybetas/h2i:latest"
FROM ${BUILD_FROM}

# Build-time metadata
ARG BUILD_VERSION

# Setup base
WORKDIR /data

# Copy data
# Copy rootfs (scripts, s6 files, etc.) into the image
COPY rootfs /

# NOTE: Many upstream images set a non-root user which prevents package
# managers (apt/apk) from running during build. Attempting to install
# packages in that case causes permission errors in the build system.
# To maximize compatibility, we avoid installing additional packages here.
# If you need runtime helpers, install them in a custom base image or
# build an image where you control the base.

# Use a shell to invoke entrypoint so the file does not need the exec bit
# set at image build time (some build systems preserve non-executable modes).
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

# Set labels
LABEL \
    io.hass.name="HTML-to-Image (H2I)" \
    io.hass.description="Convert HTML to images" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION:-unknown} \
    maintainer="guiman87"
