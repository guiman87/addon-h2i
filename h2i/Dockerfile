# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Copy our configuration handler script and test script
COPY run.sh /
COPY test_connection.sh /
COPY diagnostics.sh /
RUN chmod a+x /run.sh /test_connection.sh /diagnostics.sh

# Note: We're not adding a HEALTHCHECK here to avoid compatibility issues
# The healthcheck will be handled by Home Assistant's supervisor

# Use our script as the entry point
ENTRYPOINT ["/run.sh"]
