CALICO_VERSION=$1
ETCD_ADDR=$2

wget https://github.com/projectcalico/calicoctl/releases/download/$CALICO_VERSION/calicoctl-linux-amd64

chmod +x calicoctl-linux-amd64 
mv calicoctl-linux-amd64 /usr/local/bin/calicoctl


cat << EOF > /etc/calico/calicoctl.cfg 
apiVersion: projectcalico.org/v3
 
kind: CalicoAPIConfig
metadata:
spec:
  datastoreType: "etcdv3"
  etcdEndpoints: http://$ETCD_ADDR
EOF

calicoctl node run