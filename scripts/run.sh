#!/bin/bash
((PORT_NUM=$(netstat -ntl | awk '{print $4}' | grep -E -o '222[0-9]+' | tail -1)+1))
if [ "$PORT_NUM" = "1" ];then
    PORT_NUM=2221
fi

echo ">>>> Port Num is $PORT_NUM <<<<"

USER_NAME=android$PORT_NUM

mkdir -p ~/user/${USER_NAME}

DNS_KEY=($(cat /etc/resolv.conf | grep nameserver | cut -d ' ' -f 2))

docker run -d -t \
    --hostname=ANDROIDBIULD \
    --dns=$DNS_KEY[0] \
    $(if [ "${DNS_KEY[1]}" != "" ];then --dns=${DNS_KEY[1]};fi) \
    -e LOCAL_USER_ID=`id -u $USER` \
    -e LOCAL_USER_NAME=$USER_NAME \
    -p $PORT_NUM:22 \
    -v $HOME/user/$USER_NAME:/home/$USER_NAME/source \
    helios30/android-build
