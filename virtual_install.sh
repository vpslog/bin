#!/bin/sh

set -x

password="$1"

echo "Detected Debian. Installing OpenSSH..."
echo -e "${password}\n${password}" | passwd root \
    && apt-get update \
    && apt-get install -y openssh-server \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && service ssh restart \
    && echo "OpenSSH installed successfully."
