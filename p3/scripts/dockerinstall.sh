#!/bin/bash

if command -v lsb_release &>/dev/null; then
    DISTRO=$(lsb_release -is)
elif [[ -f /etc/os-release ]]; then
    DISTRO=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
else
    echo "Impossible to detect distribution"
    exit 1
fi

case "$DISTRO" in
    Debian|debian)
        if ! command -v docker >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update

            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            
            sudo usermod -aG docker $(whoami)

        else
            echo "docker already installed on this debian"
        fi
        ;;
    Ubuntu|ubuntu)
        if ! command -v docker >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            sudo apt-get update

            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

            sudo usermod -aG docker $(whoami)

        else
            echo "docker already installed on this ubuntu"
        fi
        ;;
    *)
        echo "Ce n'est ni Debian ni Ubuntu (Distribution détectée : $DISTRO)."
        exit 1
        ;;
esac
exit 0