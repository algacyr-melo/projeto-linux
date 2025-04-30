# Projeto Linux PB

## Índice

1. [Pré-requisitos](#pre-requisitos)
2. [Instalação VM](#instalacao-vm)
3. [Instalação Nginx](#instalacao-nginx)
4. [Script de Monitoramento](#script-de-monitoramento)
5. [Discord Webhook](#discord-webhook)

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
