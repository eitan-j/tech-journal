#!/bin/bash

# I copied the following from a script i use on my local machine
# I probably originally got it from somewhere online, but I don't remember
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Try using sudo."
    exit 1
fi

NEW_USER="$1"
NEW_HOME=/home/"$NEW_USER"
NEW_SSH="$NEW_HOME"/.ssh

useradd -m -d "$NEW_HOME"
mkdir "$NEW_SSH"
cp
chmod 700 "$NEW_SSH"
chmod 600 "$NEW_SSH"/authorized_keys
chown -R "$NEW_USER":"$NEW_USER" "$NEW_SSH"

# https://stackoverflow.com/a/46260620
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
service sshd restart
