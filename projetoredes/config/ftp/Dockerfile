FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y vsftpd && \
    useradd -m ftpuser && \
    echo "ftpuser:ftp123" | chpasswd && \
    mkdir -p /home/ftpuser/ftp && \
    chmod 755 /home/ftpuser/ftp && \
    chown ftpuser:ftpuser /home/ftpuser/ftp && \
    rm -rf /var/lib/apt/lists/*

COPY vsftpd.conf /etc/vsftpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
