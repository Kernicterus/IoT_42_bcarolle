#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

apt-get update &&  apt upgrade -y
apt install curl apt-transport-https -y
export TOKEN="token12345"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644 --token $TOKEN" sh -s -
sleep 3
chmod 777 /etc/rancher/k3s/k3s.yaml
chmod 777 /var/lib/rancher/k3s/server/node-token
chmod 777 /vagrant

echo -e "${GREEN}K3s server installed${NC}"
echo -e "${GREEN}K3s server token: $(cat /var/lib/rancher/k3s/server/node-token)${NC}"

sudo chown vagrant:vagrant /var/lib/rancher/k3s/server/node-token
sudo chown vagrant:vagrant /vagrant

echo $TOKEN > /vagrant/k3s_token.txt
echo $TOKEN > /vagrant/sdfsdfsdfk3s_token.txt
echo $TOKEN
cat -e /vagrant/k3s_token.txt

sleep 2
if [ -e /vagrant/k3s_token.txt ]; then
    echo -e "${GREEN}SUCCESS K3s token copied to /vagrant/k3s_token.txt${NC}"
else
    echo -e "${RED}FAIL to copy K3s token to /vagrant/k3s_token.txt${NC}"
fi
echo "Permissions of /vagrant: $(ls -l /vagrant)"
echo "Permissions of /vagrant/k3s_token.txt: $(ls -l /vagrant/k3s_token.txt)"