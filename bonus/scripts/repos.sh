#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

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
     --form "visibility=public"

# push le repo
git init
git remote add origin "http://localhost:30305/root/$REPO_NAME.git"
git add "${DIR}/confs/manifests-app42/"
git commit -m "manifests-app42:wilplayground"
git push -u origin master

# print credientials
echo -e "${RED}   Gitlab:${NC}"
echo "URL : http://localhost:30405"
echo "login : http://localhost:30405"
echo "pass : ${pass}"
