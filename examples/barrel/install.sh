# barrel version and etcd address needed 
# Env var: ETCD_ADDR, BARREL_DOWNLOAD_ADDR
#BARREL_DOWNLOAD_ADDR=$1
#ETCD_ADDR=$2

wget $BARREL_DOWNLOAD_ADDR -O /tmp/eru_barrel_download_package.tar.gz 
cd /tmp/
tar zxf eru_barrel_download_package.tar.gz 
mv eru-barrel /usr/local/bin/
chmod a+x /usr/local/bin/eru-barrel
rm /tmp/eru_barrel_download_package.tar.gz 

mkdir -p /etc/eru

cat << EOF > /etc/eru/barrel.conf 
# part of barrel.conf
# your etcd endpoints on which calico meta is saved
ETCD_ENDPOINTS=http://$ETCD_ADDR
# docker daemon unix socket path, by default it is the value below
BARREL_DOCKERD_PATH=unix:///var/run/docker.sock
# barrel host, working as docker endpoints, you may use schema starts with unix/http/https
BARREL_HOSTS=unix:///var/run/barrel.sock,http://0.0.0.0:2377
EOF


cat << EOF > /etc/systemd/system/eru-barrel.service 
[Unit]
Description=Eru Docker Proxy
After=network.target 
After=network-online.target
Wants=network-online.target
Before=docker.service
 
[Service]
Type=simple
# set GOMAXPROCS to number of processors
EnvironmentFile=/etc/eru/barrel.conf
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/local/bin/eru-barrel"
Restart=on-failure
LimitNOFILE=65536
 
[Install]
WantedBy=multi-user.target
EOF

systemctl enable eru-barrel
systemctl start eru-barrel