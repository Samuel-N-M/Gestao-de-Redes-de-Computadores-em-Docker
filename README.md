# Documentação do Projeto de Redes com Docker

Este projeto simula uma infraestrutura de rede completa utilizando containers Docker. Cada container representa um serviço essencial em uma rede corporativa, como DHCP, DNS, LDAP, FTP, servidor web, compartilhamento via Samba, e um roteador. O principal objetivo é oferecer um ambiente controlado e reproduzível para estudos e testes de redes.

A orquestração dos containers é feita via `docker-compose`, garantindo que os serviços sejam iniciados na ordem correta, com as devidas dependências de rede entre si.

## 1. Estrutura do Projeto

O projeto está organizado da seguinte forma:

```
projetoredes/
├── docker-compose.yml
└── config/
    ├── dhcp/
    │   ├── dhcpd.conf
    │   ├── Dockerfile
    │   └── leases/
    │       ├── dhcpd.leases
    │       └── dhcpd.leases~
    ├── dns/
    │   ├── db.redes.local
    │   ├── Dockerfile
    │   ├── entrypoint.sh
    │   ├── named.conf
    │   ├── named.conf.local
    │   └── named.conf.options
    ├── ftp/
    │   ├── Dockerfile
    │   ├── entrypoint.sh
    │   └── vsftpd.conf
    ├── ldap/
    │   ├── Dockerfile
    │   └── entrypoint.sh
    ├── router/
    │   ├── Dockerfile
    │   └── entrypoint.sh
    ├── samba/
    │   ├── Dockerfile
    │   ├── entrypoint.sh
    │   └── smb.conf
    └── web/
        ├── Dockerfile
        └── index.html
```

Cada subdiretório dentro de `config/` representa a configuração de um serviço específico da rede. Dentro de cada um, há ao menos um `Dockerfile` com instruções de build da imagem correspondente e os arquivos de configuração necessários para o serviço funcionar corretamente.

## 2. Como executar o projeto:

Entre no github no repositório do projeto e copie o link do repositório.

Em seugida clone o repositório no seu computado dor com o seguinte comando:
```
git clone https://github.com/Samuel-N-M/Gestao-de-Redes-de-Computadores-em-Docker.git
```
Abra a pasta que foi clonada e navegue até a pasta projetoredes.

Abra a pasta projetoredes pelo terminal e execute o seguinte comando:
```
docker compose up -d
```
Esse comando irá criar toda a estrutura do projeto seus conteiner e redes.


## 3. Testes das implementações:
### 1. DHCP
Este teste verifica se o servidor DHCP está atribuindo endereços IP automaticamente para os clientes da rede.
Obter o IP do container DHCP:

```
DHCP_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_dhcp_1)
echo $DHCP_IP
```

Explicação: Esse comando recupera o IP interno do container DHCP dentro da rede criada pelo docker-compose. Esse IP é útil para depuração, embora o cliente DHCP normalmente não precise conhecê-lo diretamente.
Configurar um cliente DHCP em outro container:
Explicação: Para testar, é necessário um cliente DHCP na mesma rede Docker. Criar um container temporário é uma maneira prática de fazer isso.

Exemplo em um container Debian conectado à mesma rede
```
docker run --rm --network projetoredes_default -it debian:latest bash
```

Dentro do container:
```
apt update && apt install -y isc-dhcp-client
dhclient -v eth0
```

Verificar se o IP foi obtido:
```
cat /var/lib/dhcp/dhclient.leases
```

Verificar os leases no servidor:
```
docker exec -it projetoredes_dhcp_1 cat /data/dhcpd.leases
```

### 2. DNS
Este teste verifica se o servidor DNS está resolvendo nomes corretamente, tanto locais quanto externos (com recurso).
Obter o IP do container DNS:
```
DNS_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_dns_1)
echo $DNS_IP
```

Explicação: O IP do container DNS será usado para testar as consultas.
Testar resolução de nome local:
```
dig @$DNS_IP host.redes.local A +short
```

Explicação: O dig consulta o servidor DNS pelo IP associado ao nome host.redes.local.
Testar resolução de nome externo (recursão):
```
dig @$DNS_IP google.com A +short
```

Explicação: Verifica se o servidor DNS consegue resolver nomes externos, repassando a consulta para outros servidores na internet.

### 3. FTP
Este teste verifica se o servidor FTP permite conexões, login e transferência de arquivos.

Obter o IP do container FTP:
```
FTP_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_ftp_1)
echo $FTP_IP
```

Conectar e testar upload/download:
```
ftp $FTP_IP
No prompt FTP: insira usuário/senha (ex: test/test). Antes disso, crie um arquivo para teste:
echo "conteudo de teste" > arquivo_de_teste.txt
```

No prompt do FTP:
```
put arquivo_de_teste.txt   # Envia o arquivo
get arquivo_de_teste.txt   # Baixa o arquivo (se disponível)
quit                       # Encerra a sessão
```
Resultado esperado: Os comandos devem funcionar normalmente, mostrando que é possível autenticar e transferir arquivos.
Verificar o arquivo no servidor:
```
docker exec -it projetoredes_ftp_1 ls /ftp-share
```
### 4. LDAP
Este teste avalia se o servidor LDAP está acessível e responde a consultas.
Obter o IP do container LDAP:
```
LDAP_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_ldap_1)
echo $LDAP_IP
```

Instalar cliente LDAP e consultar:
```
apt install -y ldap-utils
ldapsearch -x -H ldap://$LDAP_IP -b "dc=redes,dc=local" "(objectClass=*)"
```
Explicação:
ldapsearch é o comando de consulta.


-x usa autenticação simples (anônima).


-H define o host/protocolo.


-b define o ponto de partida da busca (Base DN).


O filtro (objectClass=*) retorna todos os objetos.

### 5. Router
Esse teste valida se o container roteador está encaminhando tráfego entre redes diferentes.
Obter o IP do container Router:
```
ROUTER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_router_1)
echo $ROUTER_IP
```

Verificar a tabela de rotas:
```
docker exec -it projetoredes_router_1 ip route
```

Testar comunicação entre sub-redes:
```
ping -c 4 <IP_de_um_serviço_em_outra_sub-rede>
```

Explicação: Use um container de uma rede (como o cliente DHCP) para pingar outro em uma rede diferente (como Web ou Samba).

### 6. Samba
Este teste verifica o compartilhamento de arquivos via protocolo SMB (Samba).
Obter o IP do container Samba:
```
SAMBA_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_samba_1)
echo $SAMBA_IP
```

Montar o compartilhamento no host:
```
sudo mkdir /mnt/samba_test
sudo mount -t cifs //$SAMBA_IP/public /mnt/samba_test -o guest,vers=2.0
ls /mnt/samba_test
```

Explicação: Montar o compartilhamento público do Samba no sistema de arquivos local usando acesso como convidado.
Resultado esperado: O diretório deve ser montado com sucesso e os arquivos compartilhados devem ser listados.

Testar escrita e leitura:
```
sudo touch /mnt/samba_test/exemplo.txt
ls /mnt/samba_test
cat /mnt/samba_test/exemplo.txt
```

### 7. Web
Este teste verifica se o servidor web está acessível e servindo páginas HTTP.
Obter o IP do container Web:
```
WEB_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' projetoredes_web_1)
echo $WEB_IP
```

Fazer requisições HTTP:
```
curl -I http://$WEB_IP     # Mostra apenas os cabeçalhos
curl http://$WEB_IP        # Mostra o conteúdo da página
```
