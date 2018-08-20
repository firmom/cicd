mkdir -p /dockerdata/firmom/cicd/ssh
ssh-keygen -b 4096 -t rsa -f /dockerdata/firmom/cicd/ssh/id_rsa -q -N ""
cat "/dockerdata/firmom/cicd/ssh/id_rsa.pub" >> ~/.ssh/authorized_keys
