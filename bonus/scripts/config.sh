#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
SLEEP=2
CLUSTER_NAME=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

kubectl config use-context k3d-$CLUSTER_NAME
kubectl config current-context


echo -e "${LPURP}config name spaces ... ${NC}"
kubectl apply -f "${DIR}/confs/nspaces.yaml"
echo -e "${GREEN}namespaces added ! ${NC}"

echo -e "${LPURP}helm app argocd creation ... ${NC}"
helm install argocd argo-cd/argo-cd --namespace argocd \
  --set server.service.type=ClusterIP \
  --set redis.enabled=true
echo -e "${GREEN}helm app argocd creation completed ! ${NC}"

kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-svc.yaml"

echo -e "${LPURP}Waiting deployment of ArgoCD ${NC}"
kubectl wait --for=condition=available deployment -n argocd --all --timeout=240s 2>&1 | grep -v "condition met"

echo -e "${LPURP}Waiting pods of ArgoCD ${NC}"

kubectl wait --for=condition=ready pod -n argocd --all --timeout=240s --field-selector=status.phase!=Succeeded | grep -v "condition met"
kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-app-git.yaml"

echo "Argocd secret:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
echo ""
echo "Argocd access: http://127.0.0.1:30105 "
echo "App access: http://127.0.0.1:30205 "

bash $DIR/scripts/gitlab.sh
