#!/bin/bash

USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER_NAME:-builder}

echo ">> Starting with UID($USER_NAME) : $USER_ID <<"

useradd -c "" -o -u $USER_ID -s /bin/bash -m $USER_NAME
adduser $USER_NAME sudo

cp -r /etc/skel/. /home/$USER_NAME

echo "$USER_NAME:$USER_NAME" | chpasswd

chown $USER_NAME:$USER_NAME /home/$USER_NAME

#sed -i -e 's/^.*Port 22$/Port 22/g' /etc/ssh/sshd_config
service ssh start

export HOME=/home/$USER_NAME
exec /usr/sbin/gosu $USER_NAME /bin/bash
