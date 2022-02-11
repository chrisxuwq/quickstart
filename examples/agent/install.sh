# install eru-agent as a systemd service 

# need env var: $AGENT_DOWNLOAD_ADDR, $CORE_ADDR, $ETCD_ADDR
#AGENT_DOWNLOAD_ADDR=$1
#CORE_ADDR=$2
#ETCD_ADDR=$3

wget AGENT_DOWNLOAD_ADDR -O /tmp/eru_agent_download_package.tar.gz 
cd /tmp/
tar zxf eru_agent_download_package.tar.gz 
mv eru-agent /usr/local/bin/

cat << EOF > /etc/systemd/system/eru-agent.service
[Unit]
Description=Eru Core
After=network.target
 
[Service]
Type=simple
Environment=GOTRACEBACK=crash
ExecStart=/usr/local/bin/eru-agent --config /etc/eru/agent.yaml
LimitNOFILE=10485760
LimitNPROC=10485760
LimitCORE=infinity
MountFlags=slave
TimeoutSec=1200
 
[Install]
WantedBy=multi-user.target
EOF

mkdir -p /etc/eru/
cat << EOF > /etc/eru/agent.yaml 
pid: /var/run/eru-agent.pid
core: $CORE_ADDR
heartbeat_interval: 30
 
docker:
  endpoint: unix:///var/run/docker.sock
metrics:
  step: 15
api:
  addr: 0.0.0.0:9193
log:
  forwards:
    - journal://
  stdout: False
healthcheck:
  interval: 30
  timeout: 10
  cache_ttl: 300
  enable_selfmon: false
etcd:
  machines:
    - $ETCD_ADDR
  prefix: /agent-selfmon
EOF

systemctl enable eru-agent
systemctl start eru-agent