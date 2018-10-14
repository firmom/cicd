# CICD (Continuous Integration / Continuous Deployment)
It is firmom CICD configuration

## SSH keys
You should prepare a ssh key on your deployment remote machine
```
mkdir -p /dockerdata/firmom/cicd/ssh
ssh-keygen -b 4096 -t rsa -f /dockerdata/firmom/cicd/ssh/id_rsa -q -N ""
cat "/dockerdata/firmom/cicd/ssh/id_rsa.pub" >> ~/.ssh/authorized_keys
```
[install-ssh-keys-host.sh](doc/install-ssh-keys-host)
Next add result to your REMOTE_DEPLOYMENT_MACHINE_SSH environment variable via [docker-compose.yaml](doc/docker-compose-example.yaml)

## Let's encrypt
Domain verification code (letsencrypt with docker):
```bash:
DOMAIN=YOUR_DOMAIN_TO_CERTIFICATE
CERT_EMAIL=YOUR_PUBLIC_EMAIL
SERVER="https://acme-v02.api.letsencrypt.org/directory"
docker run -it --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/logs/letsencrypt:/var/logs/letsencrypt" \
  certbot/certbot \
  certonly --manual --preferred-challenges dns-01 --agree-tos --cert-name "$DOMAIN" -d "$DOMAIN" -d "*.$DOMAIN" --email "$CERT_EMAIL" --server "$SERVER"
```
You can verification DNS record deployment by:
```
nslookup -q=txt _acme-challenge.gamein.pl
```
