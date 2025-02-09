#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
passGitlab=$1

kubectl config use-context k3d-$CLUSTER_NAME > /dev/null
kubectl config current-context > /dev/null

echo -e "${GREEN}Clustername ${NC}"
echo -e "$CLUSTER_NAME"

echo -e "${LPURP}config name spaces ... ${NC}"
kubectl apply -f "${DIR}/confs/nspaces.yaml" > /dev/null
echo -e "${GREEN}namespaces added ! ${NC}"

echo -e "${LPURP}helm app argocd creation ... ${NC}"
helm install argocd argo-cd/argo-cd --namespace argocd \
  --set server.service.type=ClusterIP \
  --set redis.enabled=true > /dev/null
echo -e "${GREEN}helm app argocd creation completed ! ${NC}"

kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-svc.yaml" > /dev/null

echo -e "${LPURP}Waiting deployment of ArgoCD ${NC}"
kubectl wait --for=condition=available deployment -n argocd --all --timeout=240s 2>&1 | grep -v "condition met"

echo -e "${LPURP}Waiting pods of ArgoCD ${NC}"

kubectl wait --for=condition=ready pod -n argocd --all --timeout=240s --field-selector=status.phase!=Succeeded | grep -v "condition met"
kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-app-git.yaml" > /dev/null

passArgocd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

# print credentials
echo -e "${RED}  ArgoCD:${NC}"
echo "URL ArgoCD:    http://127.0.0.1:30105 "
echo "login argocd : admin"
echo "pass argocd :  ${passArgocd}"
echo "URL App:       http://127.0.0.1:30205 "

echo -e "${RED}  Gitlab:${NC}"
echo "URL :          http://localhost:30405"
echo "SSH :          ssh -T git@localhost -p 30605 "
echo "login :        root"
echo "pass :         ${passGitlab}"
