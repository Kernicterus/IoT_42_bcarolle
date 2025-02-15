#!/bin/bash

kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=$loginDocker \
  --docker-password=$passDocker \
  --docker-email=$mailinDocker \
  --namespace $1
