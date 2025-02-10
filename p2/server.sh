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
sudo chmod 755 /config
sudo chown vagrant:vagrant /config

kubectl apply -f /config/pvolume.yaml
sleep 2
kubectl apply -f /config/pvc-vol-httpd.yaml

kubectl apply -f /config/depl-portainer.yaml
kubectl apply -f /config/depl-graf.yaml
kubectl apply -f /config/depl-httpd.yaml

kubectl apply -f /config/app1-service.yaml
kubectl apply -f /config/app2-service.yaml
kubectl apply -f /config/app3-service.yaml

kubectl apply -f /config/ingress.yaml

# kubectl apply -f /config/nodePort-httpd.yaml
