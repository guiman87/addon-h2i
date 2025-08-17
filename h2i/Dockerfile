# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Build-time metadata
ARG BUILD_VERSION

# Setup base
WORKDIR /data

# Copy data
COPY rootfs /

# Install helper packages in a distro-agnostic way. The base image for
# `bybetas/h2i` may be Debian/Ubuntu or similar, so don't assume apk exists.
RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
        apk add --no-cache bash jq curl ca-certificates netcat-openbsd; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            bash jq curl ca-certificates netcat-openbsd; \
        rm -rf /var/lib/apt/lists/*; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y epel-release || true; \
        yum install -y bash jq curl ca-certificates nmap-ncat || true; \
        yum clean all || true; \
    else \
        echo "No supported package manager found in base image; skipping package install"; \
    fi

# Make sure our entrypoint is executable (some copy operations can lose modes)
RUN if [ -f /entrypoint.sh ]; then chmod a+x /entrypoint.sh || true; fi

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Set labels
LABEL \
    io.hass.name="HTML-to-Image (H2I)" \
    io.hass.description="Convert HTML to images" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION:-unknown} \
    maintainer="guiman87"
