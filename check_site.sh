#!/bin/bash

# Export da URL do webhook pro ambiente
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

# Verificação do serviço Nginx
if [ $(systemctl is-active nginx.service) = "inactive" ]; then
    log "ERROR: Nginx service is DOWN"
    execute_webhook
    exit 1
fi

# Teste de conexão HTTP
http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
curl_status="$?"

if [ "$curl_status" -ne 0 ]; then
    log "ERROR: Curl exited with status $curl_status"
    exit 2
fi

if [ "$http_code" != "200" ]; then
    log "ERROR: Received HTTP code: $http_code"
    execute_webhook
    exit 3
fi

log "SUCCESS: Received 200 OK"
exit 0
