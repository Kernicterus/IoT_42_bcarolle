#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'

while true ; do
    kubectl patch svc gitlab-webservice-default -n gitlab  -p '{"spec": {"type": "NodePort", "ports": [{"name": "http-webservice", "nodePort": 30305, "port": 8080}, {"name": "http-workhorse", "nodePort": 30405, "port": 8181}, {"name": "http-metrics-ws", "nodePort": 30505, "port": 8083}]}}' > /dev/null
    kubectl patch svc gitlab-gitlab-shell -n gitlab  -p '{"spec": {"type": "NodePort", "ports": [{"name": "ssh", "nodePort": 30605, "port": 22}]}}' > /dev/null

    status_code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:30305/oauth/token")
    response=$?
    if [ $response -eq 52 ]; then
        echo -e "${RED}Waiting for the server to be ready... (empty reply)${NC}"
        sleep 30
    else
        echo -e "${GREEN}Response from curl: ${response}"
        echo -e "Response from server: status ${status_code}${NC}"
        break
    fi
done
