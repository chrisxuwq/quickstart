# install eru core on docker 
# env var: ETCD_ADDR
#ETCD_ADDR=$1

mkdir -p /etc/eru

cat << EOF > /etc/eru/core.yaml 
log_level: INFO
bind: ":5001"
global_timeout: 300s
lock_timeout: 30s
 
etcd:
    machines:
        - http://$ETCD_ADDR
    prefix: "/eru-core"
    lock_prefix: "core/_lock"
 
docker:
    log:
      type: "json-file"
      config:
        "max-size": "10m"
    network_mode: "bridge"
    cert_path: ""
    hub: "hub.docker.com"
    namespace: "projecteru2"
    build_pod: "eru"
    local_dns: true
 
scheduler:
    maxshare: -1
    sharebase: 100
EOF

docker run -d --name eru-core --net host --restart always -v /etc/eru:/etc/eru projecteru2/core /usr/bin/eru-core
