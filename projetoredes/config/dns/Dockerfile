FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y bind9 && \
    mkdir -p /etc/bind/zones

COPY named.conf /etc/bind/named.conf
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY db.redes.local /etc/bind/zones/db.redes.local

CMD ["named", "-f", "-g"]
