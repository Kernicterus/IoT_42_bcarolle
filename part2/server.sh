#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR='vagrant'

apt-get update &&  apt upgrade -y
apt install curl apt-transport-https -y
curl -sfL https://get.k3s.io | sh -

sleep 5

kubectl apply -f https://k8s.io/examples/application/deployment.yaml