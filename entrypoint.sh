#!/bin/bash

if [ ! -f /etc/ldap/slapd.conf ]
then
  mkdir -p /etc/ldap/
  cd /templates

  jq -r -n --arg ldap_uri "$LDAP_URI" \
           --arg ldap_suffix "$LDAP_SUFFIX" \
           --arg ldap_rootdn "$LDAP_ROOTDN" \
           '{"ldap_uri":$ldap_uri, "ldap_suffix":$ldap_suffix, "ldap_rootdn":$ldap_rootdn}' > data.json

  tmpl -data @data.json  slapd.conf.tmpl
  mv slapd.conf /etc/ldap/
fi

echo "*** Testing slapd.conf ***"
if ! slaptest -u -f /etc/ldap/slapd.conf
then
  echo "*** Error in config file ***"
  exit 1
fi

chown -R openldap:openldap /etc/ldap/slapd.d/ /var/lib/ldap/ /var/run/slapd/

if [ $# -eq 0 ]
then
  slapd -h 'ldap:/// ldapi:///' -d ${DEBUG_LEVEL} -u openldap -g openldap
else
  exec "$@"
fi
