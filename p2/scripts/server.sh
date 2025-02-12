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
sudo chmod 755 ../confs
sudo chown vagrant:vagrant ../confs

kubectl apply -f ../confs/pvolume.yaml
sleep 2
kubectl apply -f ../confs/pvc-vol-httpd.yaml

kubectl apply -f ../confs/depl-portainer.yaml
kubectl apply -f ../confs/depl-graf.yaml
kubectl apply -f ../confs/depl-httpd.yaml

kubectl apply -f ../confs/app1-service.yaml
kubectl apply -f ../confs/app2-service.yaml
kubectl apply -f ../confs/app3-service.yaml

kubectl apply -f ../confs/ingress.yaml

# kubectl apply -f /confs/nodePort-httpd.yaml
