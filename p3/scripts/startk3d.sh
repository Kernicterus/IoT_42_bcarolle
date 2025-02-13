#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
FILE="${DIR}/confs/cluster.yaml"

echo -e "${LPURP}k3d cluster creation ... ${NC}"
if k3d cluster list | grep -wq $CLUSTER_NAME; then
  echo -e "${RED}Cluster $CLUSTER_NAME already exists. Exiting...${NC}"
  exit 1
fi
k3d cluster create $CLUSTER_NAME --timeout 300s --image rancher/k3s:v1.32.1-k3s1 --config $FILE > /dev/null
echo -e "${GREEN}k3d cluster creation completed ! ${NC}"

sleep 3

echo -e "${LPURP}config name spaces ... ${NC}"
kubectl apply -f "${DIR}/confs/nspaces.yaml" > /dev/null
echo -e "${GREEN}namespaces added ! ${NC}"

bash $DIR/scripts/dockerSecret.sh argocd

for ns in $(kubectl get namespaces --no-headers | awk '{print $1}'); do
  kubectl patch serviceaccount default \
    -p '{"imagePullSecrets": [{"name": "dockerhub-secret"}]}' \
    --namespace $ns
done

# kubectl patch serviceaccount default \
#   -p '{"imagePullSecrets": [{"name": "dockerhub-secret"}]}' \
#   --namespace argocd
