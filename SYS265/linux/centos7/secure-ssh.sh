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
NEW_KEYS="$NEW_SSH"/authorized_keys

useradd -m -d "$NEW_HOME" -s /bin/bash "$NEW_USER"
mkdir "$NEW_SSH"

cp "$(find / -path "*/tech-journal/SYS265/linux/public-keys/id_rsa.pub")" "$NEW_KEYS"
# this isn't good, but we don't know where this is other than where it is in comparison to this script
# finding where this script is is a more complicated problem
# see: https://stackoverflow.com/q/59895

chmod 700 "$NEW_SSH"
chmod 600 "$NEW_KEYS"
chown -R "$NEW_USER":"$NEW_USER" "$NEW_SSH"

# https://stackoverflow.com/a/46260620
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
service sshd restart
