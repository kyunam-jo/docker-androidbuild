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

OPENSSL_VER=$(openssl version)

if [ "$(echo ${OPENSSL_VER} | cut -d ' ' -f 2 | grep '1\.0\.')" = "" ];then
    echo "openssl version is ${OPENSSL_VER}. we need 1.0.x. Start change version"
    mkdir openssl-src
    cd openssl-src
    wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz
    tar xvzf openssl-1.0.2o.tar.gz
    cd openssl-1.0.2o
    ./config
    make
    make install
    OPENSSL_PATH=$(which openssl)
    mv ${OPENSSL_PATH} ${OPENSSL_PATH}-new
    ln -sf /usr/local/ssl/bin/openssl ${OPENSSL_PATH}
    cd
    rm -rf openssl-src
fi

export HOME=/home/$USER_NAME
exec /usr/sbin/gosu $USER_NAME /bin/bash
