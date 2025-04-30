# Projeto Linux PB

## Índice

1. [Pré-requisitos](#pre-requisitos)
2. [Instalação VM](#instalacao-vm)
3. [Instalação Nginx](#instalacao-nginx)

## Pré-requisitos <a name="pre-requisitos"></a>

- VirtualBox
- ISO Ubuntu Server

_Links oficiais para download:_
- [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- [https://ubuntu.com/download/server](https://ubuntu.com/download/server)

## Instalação VM <a name="instalacao-vm"></a>

### Configurações da VM no VirtualBox:
- **Sistema Operacional:**
  - Tipo: Linux
  - Versão: Ubuntu (64-bit)
- **Hardware:**
  - Memória Base: 2048 MB
  - CPUs: 1
  - Armazenamento: 25 GB (Alocação Dinâmica)

## Instalação Nginx <a name="instalacao-nginx"></a>

```bash
sudo apt update && apt upgrade -y
sudo apt install nginx -y

# Verificar se o nginx está ativo
sudo systemctl status nginx
```

## Verificação da Disponibilidade do Site <a name="verificacao-da-disponibilidade-do-site"></a>

**Script:**
- ![check_site.sh](check_site.sh)

```bash
# Editar arquivo de configuração do cron
crontab -e
```

```bash
# * * * * * /home/almelo/bin/check_site.sh > /var/log/mysite.log
```

