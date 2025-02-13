#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

echo -e "${LPURP}Waiting for gitlab webservices to be ready ... ${NC}"
# kubectl delete hpa gitlab-webservice-default -n gitlab

kubectl rollout status deployment/gitlab-webservice-default -n gitlab --timeout=900s

# boucle pour etre sur que les requetes curl ne renvoie pas empty server
bash $DIR/scripts/check_curl.sh

# recupere le pass root gitlab
pass=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

# recupere le token
TOKEN=$(curl --request POST "http://localhost:30305/oauth/token" \
     --header "Content-Type: application/x-www-form-urlencoded" \
     --data "grant_type=password&username=root&password=${pass}" | jq -r ".access_token")
GITLAB_URL="http://localhost:30305/api/v4/projects"
REPO_NAME="my-local-repo"

# Création du dépôt
curl --request POST "$GITLAB_URL" \
     --header "Authorization: Bearer $TOKEN" \
     --form "name=$REPO_NAME" \
     --form "visibility=public" > /dev/null

# ajout ssh key
if [ ! -e  ~/.ssh/id_rsa.pub ]; then
     echo "ssh creation :"
     ssh-keygen -t rsa -b 4096 -C "mymail@google.com"
fi

# push ssh
KEY_CONTENT=$(cat ~/.ssh/id_rsa.pub)

curl --request POST "http://localhost:30305/api/v4/user/keys" \
  --header "Authorization: Bearer $TOKEN" \
  --data-urlencode "title=MyKeyWSL" \
  --data-urlencode "key=$KEY_CONTENT" > /dev/null

# ajout du host aux known hosts
ssh-keyscan -p 30605 localhost >> /home/$USER/.ssh/known_hosts

# push le repo

cd "${DIR}/confs/manifests-app42"
git init > /dev/null
git remote add origin ssh://git@localhost:30605/root/$REPO_NAME.git > /dev/null
git add . > /dev/null
git commit -m "manifests-app42:wilplayground" > /dev/null

git push  -u origin master > /dev/null

cd ${DIR}/scripts
bash $DIR/scripts/argocd.sh $pass
