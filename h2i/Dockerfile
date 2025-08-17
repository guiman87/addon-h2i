# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install curl for healthcheck and diagnostics
RUN apt-get update && apt-get install -y curl iputils-ping && apt-get clean

# Copy our configuration handler script and test script
COPY run.sh /
COPY test_connection.sh /
RUN chmod a+x /run.sh /test_connection.sh

# Add healthcheck to verify the service is responding
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80 || exit 1

# Use our script as the entry point
ENTRYPOINT ["/run.sh"]
