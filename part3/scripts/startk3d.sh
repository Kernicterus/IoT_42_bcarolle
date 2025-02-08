#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
CLUSTER_NAME=clusterNledent

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
FILE="${DIR}/confs/cluster.yaml"


echo -e "${LPURP}k3d cluster creation ... ${NC}"
k3d cluster create $CLUSTER_NAME --timeout 300s --image rancher/k3s:v1.32.1-k3s1 --config $DIR/confs/cluster.yaml
echo -e "${GREEN}k3d cluster creation completed ! ${NC}"
export KUBECONFIG=~/.kube/config

bash $DIR/scripts/config.sh $CLUSTER_NAME