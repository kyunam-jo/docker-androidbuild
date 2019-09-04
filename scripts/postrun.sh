#!/bin/bash

ssh-keygen -t rsa -N ""
sudo apt update
sudo apt upgrade -y
sudo apt install -y sshpass

git config --global user.name $USER
git config --global user.email $USER@localhost

sudo chown -R $USER:$USER .ccache
sudo chown $USER:$USER ./.*

OPENSSL_VER=$(openssl version)

if [ "$(echo ${OPENSSL_VER} | cut -d ' ' -f 2 | grep '1\.0\.')" = "" ];then
    echo "openssl version is ${OPENSSL_VER}. we need 1.0.x. Start change version"
    mkdir openssl-src
    cd openssl-src
    wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz
    tar xvzf openssl-1.0.2o.tar.gz
    cd openssl-1.0.2o
    sudo ./config
    sudo make
    sudo make install
    OPENSSL_PATH=$(which openssl)
    sudo mv ${OPENSSL_PATH} ${OPENSSL_PATH}-new
    sudo ln -sf /usr/local/ssl/bin/openssl ${OPENSSL_PATH}
    cd
    sudo rm -rf openssl-src
fi
