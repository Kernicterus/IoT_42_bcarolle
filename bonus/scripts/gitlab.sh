#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

echo -e "${LPURP}Creation of PV and PVC ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pv.yaml"
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pvc.yaml"


echo -e "${LPURP}Adding helm repo gitlab ...${NC}"
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo -e "${LPURP}Creation of gitlab chart ...${NC}"
helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab --create-namespace \
  -f "${DIR}/confs/manifests-gitlab/gitlab-values.yaml" \

kubectl patch svc gitlab-webservice-default -n gitlab  -p '{"spec": {"type": "NodePort", "ports": [{"name": "http-webservice", "nodePort": 30305, "port": 8080}, {"name": "http-workhorse", "nodePort": 30405, "port": 8181}, {"name": "http-metrics-ws", "nodePort": 30505, "port": 8083}]}}'

bash $DIR/scripts/repos.sh

