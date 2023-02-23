#!/bin/sh
cd /home

apt update && apt autoremove -y && apt upgrade -y && apt dist-upgrade -y

echo "deb http://archive.ubuntu.com/ubuntu kinetic main restricted universe multiverse" | sudo tee -a /etc/apt/sources.list

apt update
apt install python3-aiorpcx

sudo sed -i '/archive\.ubuntu\.com\/ubuntu.*kinetic/d' /etc/apt/sources.list

apt update
apt install python3-aiohttp -y
apt install python3-setuptools -y
apt install git -y
apt install screen -y

cd /home
git clone https://github.com/spesmilo/electrumx.git
cd electrumx
python3 setup.py build
python3 setup.py install

mkdir /home/db

cd /home
wget https://github.com/SeekoeiD/update-and-run-scripts/raw/main/electrumx-run.sh
chmod +x electrumx-run.sh

(crontab -u $(whoami) -l; echo "@reboot screen -dmS electrumx /home/electrumx-run.sh" ) | crontab -u $(whoami) -
