#!/bin/bash

cat /etc/resolv.conf | sed -e 's/\(nameserver 8.8.8.8\)/nameserver 156.147.135.180\nnameserver 156.147.1.1\n\1/' > resolv.conf

sudo cp resolv.conf /etc/resolv.conf

rm -rf resolv.conf

mkdir -p ~/.ssh

ssh-keyscan 10.178.97.151 >> ~/.ssh/known_hosts

sudo apt update
sudo apt install -y sshpass

sshpass -p 'namjin0904!' scp 10.178.97.151:~/.ssh/* ~/.ssh/

git config --global user.name $USER
git config --global user.email $USER@lge.com

sudo chown -R $USER:$USER .ccache
sudo chown $USER:$USER ./.*


