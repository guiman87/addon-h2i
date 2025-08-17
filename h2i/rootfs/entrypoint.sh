#!/bin/bash
set -e

# Make scripts executable
chmod a+x /etc/s6-overlay/s6-rc.d/init-h2i/run
chmod a+x /etc/s6-overlay/s6-rc.d/init-h2i/finish
chmod a+x /etc/s6-overlay/s6-rc.d/init-h2i/check
chmod a+x /usr/bin/h2i-diagnostics

# Start the S6 init system
exec /init
