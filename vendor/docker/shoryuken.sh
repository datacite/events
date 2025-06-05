#!/bin/sh
cd /home/app/webapp

# Redirect stdout and stderr to the same place 
exec 2>&1

# Disble starting the queue worker when the environment variable DISABLE_QUEUE_WORKER is set to "true".
# This value is set in the docker-compose.yml file
# if [ "$DISABLE_QUEUE_WORKER" != "true" ]; then
#   echo "Starting Shoryuken worker"
#   exec /sbin/setuser app bundle exec shoryuken -R -C config/shoryuken.yml
# fi