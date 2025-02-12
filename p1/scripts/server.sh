#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR='vagrant'

apt-get update &&  apt upgrade -y
apt install curl apt-transport-https -y
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644" sh -s -
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --write-kubeconfig-mode 0644 --token $TOKEN" sh -s -
sleep 5
sudo k3s kubectl get node
sleep 5

TOKEN_FILE="/var/lib/rancher/k3s/server/node-token"
while [ ! -f "$TOKEN_FILE" ]; do
    echo "node-token creation..."
    sleep 2
done
echo -e "${LPURP}K3s server installed${NC}"
echo $(cat ${TOKEN_FILE}) > "/${DIR}/k3s_token.txt"
if [ -e /${DIR}/k3s_token.txt ]; then
    echo -e "${LPURP}SUCCESS K3s token copied to /${DIR}/k3s_token.txt${NC}"
else
    echo -e "${RED}FAIL to copy K3s token to /${DIR}/k3s_token.txt${NC}"
fi
