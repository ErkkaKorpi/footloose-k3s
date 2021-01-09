#! /bin/bash

set -eu

# k3s_url="https://k3s-master:6443"
k3s_url="https://k3s-cluster-node0.k3s-cluster:6443"

for i in {0..2}; do 
#     footloose ssh root@node${i} -- "cat <<EOF >> /etc/hosts
# 172.17.0.2  k3s-master
# 172.17.0.3  k3s-worker1
# 172.17.0.4  k3s-worker2
# EOF"

    # if master node (node 0)
    if [[ "$i" == 0 ]]; then
        echo "Setup master node"
        footloose ssh root@node${i} --  "curl -sfL https://get.k3s.io | sh -"
        k3s_token=$(footloose ssh root@node${i} -- "cat /var/lib/rancher/k3s/server/node-token")
        footloose ssh root@node0 --  "cat /etc/rancher/k3s/k3s.yaml" > $HOME/.kube/config-local-k3s
    # if worker node (node 1 and 2)
    else 
        echo "Setup worker node ${i}"
        footloose ssh root@node${i} --  "curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh - "
    fi

done
