#!/bin/bash

if [ -z "$1" ]; then
  echo "Missing argument. Usage: $0 <clusterName>"
  exit 1
fi

export CLUSTER_NAME=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

if [ -r "${DIR}/../.env" ]; then
  source $DIR/../.env
else
  echo -e "Missing .env"
  exit 1
fi

# ----- INSTALLATION OF DOCKER -----
if ! command -v docker >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

  sudo usermod -aG docker $(whoami)

else
  echo "docker already installed"
fi

# ----- INSTALLATION OF K3D -----
if ! command -v k3d >/dev/null 2>&1; then
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.8.1 bash
else
  echo "k3d already installed"
fi

# ----- INSTALLATION OF KUBECTL -----
if ! command -v kubectl >/dev/null 2>&1; then
  sudo apt-get update &&  apt upgrade -y
  sudo apt install curl apt-transport-https -y
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
  echo "kubectl already installed"
fi

# ----- START CONFIGS -----
bash $DIR/scripts/startk3d.sh
if [ $? -ne 0 ]; then
  echo "startk3d.sh script failed"
  exit 1
fi
bash $DIR/scripts/argocd.sh

