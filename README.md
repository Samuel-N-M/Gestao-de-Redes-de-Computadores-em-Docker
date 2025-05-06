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
