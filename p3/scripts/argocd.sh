#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
SLEEP=2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

kubectl config use-context k3d-$CLUSTER_NAME > /dev/null
kubectl config current-context > /dev/null

# ---- HELM argocd
# echo -e "${LPURP}helm app argocd creation ... ${NC}"
# helm repo add argo-cd https://argoproj.github.io/argo-helm
# helm repo update
# helm install argocd argo-cd/argo-cd --namespace argocd \
#   --set server.service.type=ClusterIP \
#   --set redis.enabled=true > /dev/null
# echo -e "${GREEN}helm app argocd creation completed ! ${NC}"

echo -e "${LPURP}depl argocd ... ${NC}"
kubectl apply -f "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml" -n argocd #> /dev/null
kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-svc.yaml" -n argocd #> /dev/null
echo -e "${GREEN}argocd depl completed ! ${NC}"

echo -e "${LPURP}Waiting deployment of ArgoCD ...${NC}"
kubectl wait --for=condition=available deployment -n argocd --all --timeout=240s 2>&1 | grep -v "condition met"

echo -e "${LPURP}Waiting pods of ArgoCD ...${NC}"

kubectl wait --for=condition=ready pod -n argocd --all --timeout=240s --field-selector=status.phase!=Succeeded | grep -v "condition met"
kubectl apply -f "${DIR}/confs/manifests-argocd/argocd-app-git.yaml" > /dev/null
echo -e "${GREEN}ArgoCD deployed !${NC}"

passArgocd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)

# print credentials
echo -e "${RED}  ArgoCD:${NC}"
echo "URL ArgoCD:    http://127.0.0.1:30105 "
echo "login argocd : admin"
echo "pass argocd :  ${passArgocd}"
echo "URL App:       http://127.0.0.1:30205 "
# kubectl port-forward svc/argocd-server -n argocd 8080:80
# netsh interface portproxy add v4tov4 listenport=30105 listenaddress=0.0.0.0 connectport=30105 connectaddress=172.23.233.8
# netsh interface portproxy add v4tov4 listenport=30205 listenaddress=0.0.0.0 connectport=30205 connectaddress=172.23.233.8
# netsh interface portproxy show all
# netsh interface portproxy delete v4tov4 listenport=30105 listenaddress=0.0.0.0

