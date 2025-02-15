#!/bin/bash
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

print() {
  local text=$1
  local flag=$2

  if [ "$flag" -eq 0 ]; then
    echo -e "${BLUE}$text successfully cleaned${NC}"
  else
    echo -e "${RED}Error: $text NOT successfully cleaned${NC}"
  fi
}

if [ -z "$1" ]; then
  echo "Missing argument. Usage: $0 <clusterName>"
  exit 1
else
    ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R "[localhost]:30605" > /dev/null 2>&1
    print "Ssh known hosts" $?
    
    rm -rf ${DIR}/confs/manifests-app42/.git > /dev/null
    print "Directory .git from manifests-app42" $?
    
    k3d cluster delete $1 > /dev/null
    clusterName=$1
    print "Cluster k3d ${clusterName}" $?
fi