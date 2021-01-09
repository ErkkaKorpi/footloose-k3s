#! /bin/bash

set -eu

function instructions () {
  echo -e "\033[35mFootloose-k3s:
  
  Cluster can be created with providing argument 'create'
  Cluster can be deleted with providing argument 'delete'
  \033[0m"
}

function install-k3s () {
    k3s_url="https://k3s-cluster-node0.k3s-cluster:6443"

    for i in {0..2}; do 
        # if master node (node 0)
        if [[ "$i" == 0 ]]; then
            echo -e "\033[32mSetup master node\033[0m"
            footloose ssh root@node${i} --  "curl -sfL https://get.k3s.io | sh -"
            k3s_token=$(footloose ssh root@node${i} -- "cat /var/lib/rancher/k3s/server/node-token")
            footloose ssh root@node0 --  "cat /etc/rancher/k3s/k3s.yaml" > $HOME/.kube/config-local-k3s
        # if worker node (node 1 and 2)
        else 
            echo -e "\033[32mSetup worker node ${i}\033[0m"
            footloose ssh root@node${i} --  "curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh - "
        fi

    done
}

function create-cluster () {
    # Build docker container:
    docker build -t footloose-ubuntu-1804:latest .
    # Create docker network:
    docker network create k3s-cluster
    # Create footloose cluster
    footloose create --config footloose.yaml
    # Install k3s
    install-k3s
    
    echo -e "\033[32mCluster ready\033[0m"
}

function delete-cluster () {
    # Delete footloose cluster
    footloose delete --config footloose.yaml
    # Delete docker network
    docker network rm k3s-cluster

    echo -e "\033[32mCluster deleted\033[0m"
}

if [[ "$1" == "create" ]]; then
    create-cluster
elif [[ "$1" == "delete" ]]; then
    delete-cluster
elif [[ "$1" == "help" || -z "$1" ]]; then
    instructions
else 
    echo -e "\033[31mInvalid argument provided, supported arguments are 'create', 'delete' or 'help'\033[0m"
fi