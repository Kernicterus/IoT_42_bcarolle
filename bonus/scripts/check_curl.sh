#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
LPURP='\033[1;35m'
NC='\033[0m'

while true ; do
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
