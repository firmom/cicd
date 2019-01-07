#!/bin/sh
set -e

DOMAIN="$1"
SERVER="https://acme-v02.api.letsencrypt.org/directory"

if [ ! -d "/etc/letsencrypt/live/$DOMAIN"]; then
  # You must create certificate manualy to verificate your ownership of domain
  # Use comamnd
  # docker run -it --rm --name certbot \
  #   -v "/etc/letsencrypt:/etc/letsencrypt" \
  #   -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  #   -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
  #   certbot/certbot \
  #   certonly --manual --preferred-challenges dns --agree-tos --cert-name "$DOMAIN" -d "$DOMAIN" -d "*.$DOMAIN" --email "$CERT_EMAIL" --server "$SERVER"
  #
  # Verificate record by
  # nslookup -q=TXT _acme-challenge.$DOMAIN
  echo "You must create certificate manualy to verificate your ownership of domain."
  exit 2
else
  # You must create certificate manualy to verificate your ownership of domain
  # Use comamnd
  docker run -it --rm --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
    certbot/certbot \
    certonly --manual --preferred-challenges dns --agree-tos --cert-name "$DOMAIN" -d "$DOMAIN" -d "*.$DOMAIN" --email "$CERT_EMAIL" --server "$SERVER"
  echo "renew certificate manually"
  # docker run -it --rm --name certbot \
  #   -v "/etc/letsencrypt:/etc/letsencrypt" \
  #   -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  #   -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
  #   certbot/certbot \
  #   renew --cert-name "$DOMAIN" --email "$CERT_EMAIL" --noninteractive --agree-tos \
  #   ||:
fi

./letsencrypt-auto renew --force-renewal --standalone --preferred-challenges http
