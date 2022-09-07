#!/usr/bin/env bash

apt update
apt-get install curl git git-core screen -y

git clone http://github.com/isaacs/nave.git
sudo ./nave/nave.sh usemain stable

npm install gun
cd ./node_modules/gun || exit 5
npm install .

screen -S relay
sudo npm start 80 # change `80` to `443` for https or `8765` for development purposes.