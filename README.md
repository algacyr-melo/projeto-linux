# Projeto Linux PB

## Índice

1. [Pré-requisitos](#pre-requisitos)
2. [Instalação VM](#instalacao-vm)
3. [Instalação Nginx](#instalacao-nginx)
4. [Customização do Index](#custom-index)
5. [Monitoramento](#monitoramento)
    - [Script de Verificação](#script-verificacao)
    - [Configuração do Cronjob](#config-cron)
    - [Criação de Logs](#gestao-logs)

---

## Pré-requisitos <a name="pre-requisitos"></a>

- VirtualBox
- ISO Ubuntu Server

_Links oficiais para download:_
- [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- [https://ubuntu.com/download/server](https://ubuntu.com/download/server)

## Instalação da VM <a name="instalacao-vm"></a>

### Configurações da VM no VirtualBox:
- **Sistema Operacional:**
  - Tipo: Linux
  - Versão: Ubuntu (64-bit)
- **Hardware:**
  - Memória Base: 2048 MB
  - CPUs: 1
  - Armazenamento: 25 GB (alocação dinâmica)

## Instalação do Nginx <a name="instalacao-nginx"></a>

1. Atualização do sistema e instalação:
    ```bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install nginx -y
    ```

2. Verificação do serviço:
    ```bash
    sudo systemctl status nginx
    ```

## Customização do Index <a name="custom-index"></a>

1. **Criar Cópia do Arquivo Padrão:**
    ```bash
    cp /var/www/html/index.nginx-debian.html /var/www/html/index.html
    ```

2. **Editar Conteúdo do Arquivo:**
    ```html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Linux PB</title>
    </head>
    <body>
        <h1>Servidor Configurado com Sucesso! 🐧</h1>
        <footer>Projeto de Algacyr Melo</footer>
    </body>
    </html>
    ```

3. **Reiniciar Nginx:**
    ```bash
    sudo systemctl restart nginx
    ```

## Monitoramento <a name="monitoramento"></a>

### Script de Verificação `check_site.sh` <a name="script-verificacao"></a>
```bash
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
```

### Configuração do Cronjob <a name="config-cron"></a>

1. **Editar arquivo de cron do usuário:**
    ```bash
    crontab -e
    ```

2. **Configurar para execução a cada 1 minuto:**
    ```cron
    * * * * * /home/almelo/pb-linux/check_site.sh >> /var/log/pb-linux/check_site.log 2>&1
    ```

3. **Verificar Agendamento:**
    ```bash
    crontab -l
    ```

### Gestão de Logs <a name="gestao-logs"></a>

1. **Criar Diretório com Arquivo de Log:**
    ```bash
    sudo mkdir /var/log/pb-linux
    sudo touch /var/log/pb-linux/check_site.log
    ```

2. **Ajustar Permissões:**
    ```bash
    sudo chown -R almelo:almelo /var/log/pb-linux
    ```

3. **Verificar Logs em Tempo Real:**
    ```bash
    tail -f /var/log/pb-linux/check_site.log
    ```
