# config docker to expose host port to public 

#ETCD_ADDR=$1

# Need env var ETCD_ADDR

cat << EOF > /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"],
  "cluster-store": "etcd://$ETCD_ADDR",
  "live-restore": true
}
EOF

chmod 0644 /etc/docker/daemon.json

# remove any cmd argument on listen address for docker
sed -i '\|^ExecStart|s|-H fd://||g' /lib/systemd/system/docker.service  

systemctl daemon reload 
systemctl restart docker 