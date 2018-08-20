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
