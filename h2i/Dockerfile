# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Setup base
WORKDIR /data

# Copy data
COPY rootfs /

# Required dependencies for Home Assistant addons
RUN \
    apk add --no-cache \
    bash \
    jq \
    curl \
    ca-certificates \
    netcat-openbsd

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set labels
LABEL \
    io.hass.name="HTML-to-Image (H2I)" \
    io.hass.description="Convert HTML to images" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="guiman87"
