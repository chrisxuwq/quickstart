# install etcd within docker as it's simple 
ETCD_VERSION=$1

docker run -d --net host --name etcd quay.io/coreos/etcd:$ETCD_VERSION /usr/local/bin/etcd --name etcd-1 --initial-advertise-peer-urls http://127.0.0.1:2380 --advertise-client-urls http://0.0.0.0:2379 --listen-client-urls http://0.0.0.0:2379 --initial-cluster etcd-1=http://127.0.0.1:2380
