#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo -e "${RED}sleep 45${NC}"
sleep 2
kubectl config use-context k3d-mycluster 
kubectl config current-context


echo -e "${LPURP}config name spaces ... ${NC}"
kubectl apply -f "${DIR}/../confs/nspaces.yaml"
echo -e "${GREEN}namespaces added ! ${NC}"

# echo -e "${LPURP}helm app argocd creation ... ${NC}"
# helm install argocd argo-cd/argo-cd --namespace argocd \
#   --set server.service.type=ClusterIP \
#   --set redis.enabled=true
# echo -e "${GREEN}helm app argocd creation completed ! ${NC}"

echo -e "${LPURP}Argocd configuration ... ${NC}"
kubectl apply -f "${DIR}/../confs/argocd-depl.yaml"
kubectl apply -f "${DIR}/../confs/argocd-svc.yaml"
kubectl apply -f "${DIR}/../confs/argocd-ingress.yaml"
echo -e "${LPURP}Argocd configuration completed ! ${NC}"

# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
