#!/bin/bash

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

# ----- INSTALLATION OF HELM -----
if ! command -v helm >/dev/null 2>&1; then
  sudo apt-get update &&  apt upgrade -y
  sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

else
  echo "helm already installed"
fi

# ----- INSTALLATION OF JQ -----
if ! command -v jq >/dev/null 2>&1; then
  sudo apt-get update &&  apt upgrade -y
  sudo apt install jq -y
else
  echo "jq already installed"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash $DIR/startk3d.sh

