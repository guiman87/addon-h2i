# Use the pre-built h2i image as the base for this addon
# The Home Assistant builder will automatically select the correct architecture
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Copy our scripts - we won't try to chmod them
COPY run.sh /
COPY test_connection.sh /
COPY diagnostics.sh /

# Use our script as the entry point, making sure it's executed through bash
ENTRYPOINT ["/bin/bash", "/run.sh"]
