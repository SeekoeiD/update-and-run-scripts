## btc-rpc-explorer

- https://github.com/janoside/btc-rpc-explorer
- `~/.config/btc-rpc-explorer.env`

## Get Ubuntu ready

- start with Ubuntu 22.04

```bash
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
```

## Create run script

In /home:

- `nano run.sh`

```
#!/bin/sh
cd /home/electrumx

export ALLOW_ROOT=non_empty
export COIN=Bitcoin
export DAEMON_URL=http://user:pass@localhost:8332
export NET=mainnet
export DB_DIRECTORY=/home/db

#export SSL_CERTFILE=/home/username/electrumx/server.crt
#export SSL_KEYFILE=/home/username/electrumx/server.key
#export BANNER_FILE=/home/username/electrumx/banner-test
#export DONATION_ADDRESS=your-donation-address
#export SERVICES=rpc://,SSL://,TCP://

#export SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://
export SERVICES=tcp://:50001,rpc://

export MAX_SEND=2000000

python3 ./electrumx_server
```

- `chmod +x run.sh`

## Running

I use screen

- `apt install screen`
- `crontab -e`
  - `@reboot screen -dmS electrum /home/run.sh`
