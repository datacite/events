#!/bin/sh
cd /home/app/webapp
exec 2>&1
# Disabled with DISABLE_QUEUE_WORKER, start shoryuken
if [ -n "$DISABLE_QUEUE_WORKER" ]; then
  exec /sbin/setuser app bundle exec shoryuken -R -C config/shoryuken.yml
fi
