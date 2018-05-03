#!/bin/bash
if [ "$2" != "" ];then
    PORT_NUM=$2
else
    ((PORT_NUM=$(netstat -ntl | awk '{print $4}' | grep -E -o '222[0-9]+' | tail -1)+1))
    if [ "$PORT_NUM" = "1" ];then
        PORT_NUM=2221
    fi
fi

echo ">>>> Port Num is $PORT_NUM <<<<"

USER_DIR=~/user/${1}_${PORT_NUM}

mkdir -p ${USER_DIR}

sudo docker run -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$1 -p $PORT_NUM:22 -v ${USER_DIR}:/home/$1/source -v $HOME/.ccache:/home/$1/.ccache -v $HOME/docker:/home/$1/docker -v /home/mirror:/home/mirror -d -t helios30/android-build

