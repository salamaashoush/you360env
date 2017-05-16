#!/usr/bin/env bash

if [ -f /home/vagrant/.node ]
then
    echo "Node already installed."
    exit 0
fi


touch /home/vagrant/.node

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

sudo apt-get install -y build-essential
sudo apt-get install -y nodejs

sudo ufw allow 3000

