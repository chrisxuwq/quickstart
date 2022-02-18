# install etcd within docker as it's simple 
# Need env var ETCD_VERSION ETCD_LISTEN_IP


docker run -d --net host --name etcd quay.io/coreos/etcd:$ETCD_VERSION /usr/local/bin/etcd --name node1 --advertise-client-urls http://$ETCD_LISTEN_IP:2379  --listen-peer-urls http://0.0.0.0:2380 --listen-client-urls http://0.0.0.0:2379 --auto-compaction-mode=periodic --auto-compaction-retention=1h 
