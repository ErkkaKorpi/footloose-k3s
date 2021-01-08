FROM quay.io/footloose/ubuntu18.04:latest

RUN bash -c 'set -euo pipefail; \
    apt-get update; \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common vim; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - ;\
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"; \
    apt-get update; \
    apt-get install -y docker-ce; \
    rm -r /var/lib/apt/lists/*;'