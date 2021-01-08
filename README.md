# Footloose-k3s

## Quickly setup a local kubernetes cluster running k3s on top of docker

### Dependencies:

- Docker
- [Footloose](https://github.com/weaveworks/footloose)
- kubectl

### Setup:

Build a docker container from provided Dockerfile

```docker build -t footloose-ubuntu-1804:latest .```

Bring up the footloose cluster

```footloose create```

Install k3s with provided script

```./k3s-setup.sh```

After setup is completed cluster can be accessed by providing ```--kubeconfig ~/.kube/config-local-k3s``` to kubectl tool, for example 

```kubectl --kubeconfig ~/.kube/config-local-k3s get pods -n kube-system```

this project was inspired by Jeff Poole's [**k8s-net-labs**](https://github.com/korvus81/k8s-net-labs) repo
