#!/bin/sh
set -e

DOMAIN="$1"
SERVER="https://acme-v02.api.letsencrypt.org/directory"

if [ ! -d "/etc/letsencrypt/live/$DOMAIN"]; then
  docker run -it --rm --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
    certbot/certbot \
    certonly --manual --preferred-challenges dns --noninteractive --agree-tos --cert-name "$DOMAIN" -d "$DOMAIN" -d "*.$DOMAIN" --email "$CERT_EMAIL" --server "$SERVER"
else
  docker run -it --rm --name certbot \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
    certbot/certbot \
    renew --cert-name "$DOMAIN" --email "$CERT_EMAIL" --noninteractive --agree-tos
fi
