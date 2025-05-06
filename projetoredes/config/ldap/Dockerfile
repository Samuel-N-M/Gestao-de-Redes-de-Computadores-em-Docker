FROM osixia/openldap:1.5.0

ENV LDAP_ORGANISATION="Redes"
ENV LDAP_DOMAIN="redes.local"
ENV LDAP_ADMIN_PASSWORD="admin123"

COPY entrypoint.sh /container/service/slapd/startup.sh
RUN chmod +x /container/service/slapd/startup.sh
