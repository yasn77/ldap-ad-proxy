FROM ubuntu:18.04

ENV DEBUG_LEVEL 32768
ENV LDAP_URI "ldap://127.0.0.1:389"
ENV LDAP_SUFFIX "dc=ldap,dc=com"
ENV LDAP_ROOTDN "cn=admin,dc=ldap,dc=com"

VOLUME /var/lib/ldap

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y jq tmpl slapd ldap-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY ./templates /templates
COPY ./entrypoint.sh /entrypoint.sh
CMD []
ENTRYPOINT ["/entrypoint.sh"]
