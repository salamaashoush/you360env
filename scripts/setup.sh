#!/usr/bin/env bash

if [ -f /home/ubuntu/.node ]
then
    echo "Node already installed."
    exit 0
fi


touch /home/ubuntu/.node

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

sudo apt-get upgrade -y
sudo apt-get install -y build-essential
sudo apt-get install -y nodejs

sudo ufw allow 3000


sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated  mongodb-org


sudo apt-get install -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev
sudo apt-get install -y libcurl4-openssl-dev pkg-config
sudo apt-get install -y libsasl2-dev



cat > /etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
[Install]
WantedBy=multi-user.target
EOL

sudo systemctl start mongodb
sudo systemctl status mongodb
sudo systemctl enable mongodb
sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

mongo admin --eval "db.createUser({user:'you360',pwd:'secret',roles:['root']})"
mongo $1 --eval "db.test.insert({name:'db creation'})"
sudo service mongod restart



#Redis

echo "Installing Redis"
sudo add-apt-repository ppa:chris-lea/redis-server -y
sudo apt-get update
sudo apt-get install redis-server

sudo systemctl start redis
sudo systemctl status redis
sudo systemctl enable redis

