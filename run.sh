#!/bin/sh
# Wrapper script called on entry to the image that updates the agent's
# default.properties file, optionally updates the rest service config,
# and then passes on control to supervisor.
 
# setup the required agent properties
AGENT_PORT=${AGENT_PORT:-48004}
PORT_RANGE=$((AGENT_PORT+1))
AGENT_PEER=${AGENT_PEER:-''}
 
# fill out the the agent properties file
/bin/sed -ie "s/#domainPassword =/domainPassword = $DOMAIN_PASSWORD/" /opt/nuodb/etc/default.properties
/bin/sed -ie "s/#port = 48004/port = $AGENT_PORT/" /opt/nuodb/etc/default.properties
/bin/sed -ie "s/portRange = 48005/portRange = $PORT_RANGE/" /opt/nuodb/etc/default.properties
/bin/sed -ie "s/#peer =/peer = $AGENT_PEER/" /opt/nuodb/etc/default.properties
 
# optionally include the REST service under supervisor control 
if [ -n "$START_REST_SVC" ]; then
   CONF_FILE=/etc/supervisor/conf.d/supervisord.conf
   echo "[program:nuorestsvc]"  >> $CONF_FILE
   echo "user=nuodb">> $CONF_FILE
   echo "command=/opt/nuodb/etc/nuorestsvc start">> $CONF_FILE
fi
 
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
 