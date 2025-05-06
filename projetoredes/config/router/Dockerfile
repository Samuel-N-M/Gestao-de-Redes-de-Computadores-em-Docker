FROM alpine:3.18

RUN apk add --no-cache iptables iproute2

# Copia e já converte EOL para LF
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
