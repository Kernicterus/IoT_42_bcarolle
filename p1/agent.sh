#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
DIR='vagrant'

apt-get update &&  apt upgrade -y
apt install curl apt-transport-https -y
export TOKEN=$(cat /${DIR}/k3s_token.txt)
curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="${TOKEN}" INSTALL_K3S_EXEC="agent --node-ip 192.168.56.111" sh -
echo -e "${GREEN}K3s agent installed and connected to the server${NC}"
