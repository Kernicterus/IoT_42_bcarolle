#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

echo -e "${LPURP}Creation of gitlab chart ...${NC}"

echo -e "${LPURP}   Part 1: cert-manager setup ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/cert-manager.yaml" > /dev/null
kubectl wait --for=condition=Ready pod --all -n cert-manager --timeout=600s

echo -e "${LPURP}   Part 2: gitlab operator setup ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-operator.yaml" > /dev/null
kubectl wait --for=condition=Ready pod --all -n gitlab --timeout=600s

echo -e "${LPURP}   Part 3: gitlab setup ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab.yaml"

echo -e "${LPURP}Waiting for gitlab to be ready ...${NC}"
while ! kubectl get pods -n gitlab 2>/dev/null | grep gitlab-webservice-default > /dev/null; do
  sleep 10
done
kubectl wait --for=condition=Ready pod -l app=webservice -n gitlab --timeout=600s

echo -e "${GREEN}Gitlab ready ! ${NC}"

bash $DIR/scripts/repos.sh
