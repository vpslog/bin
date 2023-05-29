#!/bin/bash

password="$1"

if [[ -z "$password" ]]; then
    echo "Please specify a password as an argument."
    exit 1
fi

if [[ "$(cat /etc/os-release | grep ID)" == *"debian"* ]]; then
    echo "Detected Debian. Installing OpenSSH..."
    echo -e "${password}\n${password}" | passwd root \
        && apt-get update \
        && apt-get install -y openssh-server \
        && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
        && service ssh restart \
        && echo "OpenSSH installed successfully."
elif [[ "$(cat /etc/os-release | grep ID)" == *"alpine"* ]]; then
    echo "Detected Alpine. Installing OpenSSH..."
    echo -e "${password}\n${password}" | passwd root \
        && apk update \
        && apk add --no-cache openssh \
        && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
        && ssh-keygen -A \
        && /usr/sbin/sshd \
        && echo "OpenSSH installed successfully."
else
    echo "Unsupported operating system."
fi
