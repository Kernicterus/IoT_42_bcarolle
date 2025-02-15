#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

# echo -e "${LPURP}Creation of PV and PVC ...${NC}"
# kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pv.yaml"
# kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pvc.yaml"


# echo -e "${LPURP}Adding helm repo gitlab ...${NC}"
# helm repo add gitlab https://charts.gitlab.io/
# helm repo update
# helm upgrade --install gitlab gitlab/gitlab \
#   --namespace gitlab --create-namespace \
#   -f "${DIR}/confs/manifests-gitlab/gitlab-values.yaml" > /dev/null

echo -e "${LPURP}Creation of gitlab chart ...${NC}"
echo -e "${LPURP}   Part 1: cert-manager setup ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/cert-manager.yaml"
kubectl wait --for=condition=Ready pod --all -n cert-manager --timeout=600s

echo -e "${LPURP}   Part 2: gitlab operator setup ...${NC}"
kubectl wait --for=condition=Ready pod --all -n gitlab --timeout=600s
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-operator.yaml"

echo -e "${LPURP}   Part 3: gitlab setup ...${NC}"
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab.yaml"

echo -e "${LPURP}Waiting for gitlab to be ready ...${NC}"
while ! kubectl get jobs -n gitlab 2>/dev/null | grep gitlab-migrations > /dev/null; do
  sleep 5
done
sleep 5
kubectl wait --for=condition=complete job -n gitlab --selector=app.kubernetes.io/component=migrations --timeout=600s

echo -e "${GREEN}Gitlab ready ! ${NC}"

bash $DIR/scripts/repos.sh
