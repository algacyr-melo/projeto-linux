#!/bin/bash

# Export env variable from .env
source $HOME/project/.env

log() {
    echo "[$(date)] $1"
}

execute_webhook() {
    alert_msg="[$(date)] ALERT: Site unavailable at localhost"
    curl -X POST -H "Content-Type: application/json" \
        -d "{\"content\": \"$alert_msg\"}" \
        "$DISCORD_WEBHOOK_URL"
}

# Check Nginx service status
if [ $(systemctl is-active nginx.service) = "inactive" ]; then
    log "ERROR: Nginx service is DOWN"
    execute_webhook
    exit 1
fi

# Did we get a response from localhost:80?
http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
curl_status="$?"
if [ "$curl_status" -ne 0 ]; then
    log "ERROR: Curl exited with status $curl_status"
    exit 2
fi

# Did we get status 200 OK?
if [ "$http_code" != "200" ]; then
    log "ERROR: Unexpected HTTP code: $http_code"
    execute_webhook
    exit 3
fi

log "SUCCESS: Received 200 OK"
exit 0

# vim: ts=4 sts=4 sw=4 et
