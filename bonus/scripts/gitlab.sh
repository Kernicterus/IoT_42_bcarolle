#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pv.yaml"
sleep 5
kubectl apply -f "${DIR}/confs/manifests-gitlab/gitlab-pvc.yaml"

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab --create-namespace \
  -f "${DIR}/confs/manifests-gitlab/gitlab-values.yaml" \
  --set global.hosts.domain=example.com \
  --set certmanager-issuer.email=your-email@example.com



