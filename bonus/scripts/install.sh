#!/bin/bash

# ----- INSTALLATION OF DOCKER -----
if ! command -v docker >/dev/null 2>&1; then
  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

  sudo usermod -aG docker $(whoami)

  # if [ ! -e docker-desktop-amd64.deb ]; then
  #     wget -O "docker-desktop-amd64.deb" "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64&_gl=1*1pagoyf*_ga*MzQxNDI4ODkxLjE3Mzg0MTQ0NzU.*_ga_XJWPQMJYHQ*MTczODUwMzA1My4zLjEuMTczODUwMzE4MC42MC4wLjA."
  # fi
  # sudo apt install ./docker-desktop-amd64.deb
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
  helm repo add argo-cd https://argoproj.github.io/argo-helm
  helm repo update
else
  echo "helm already installed"
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bash $DIR/startk3d.sh

