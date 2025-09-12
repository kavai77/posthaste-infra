# Install minikube: https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Farm64%2Fstable%2Fbinary+download
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64

# Install Docker: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
sudo apt-get update
sudo apt-get -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# add user to docker group
sudo usermod -aG docker $USER && newgrp docker

# configure minikube, and kubectl
minikube config set cpus 8
minikube config set memory 14g
minikube config set driver docker
minikube start --static-ip 192.168.200.200
minikube kubectl -- get po -A

# install and start nginx
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo apt-get -y install jq

echo alias kubectl=\"minikube kubectl --\" >> .bash_aliases
source .bash_aliases
kubectl apply -f posthaste-infra/services.yaml

sudo rm -rf /var/www/html
sudo ln -s posthaste-infra/html /var/www/

sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s posthaste-infra/nginx-site /etc/nginx/sites-enabled
sudo systemctl reload nginx

