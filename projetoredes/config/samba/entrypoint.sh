#!/bin/bash
set -e

# Cria usuário do sistema (caso não exista)
id -u sambauser &>/dev/null || useradd -M sambauser

# Define senha do usuário samba
echo -e "samba123\nsamba123" | smbpasswd -a -s sambauser

# Garante pasta compartilhada com permissões
mkdir -p /srv/samba/public
chmod 777 /srv/samba/public

# Inicia o Samba
exec smbd --foreground --no-process-group

