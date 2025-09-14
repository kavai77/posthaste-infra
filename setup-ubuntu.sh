sudo apt-get update
sudo apt-get -y install snapd

# Install MicroK8s
sudo snap install microk8s --classic --channel=1.33
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube

echo alias kubectl=\"microk8s kubectl\" >> .bash_aliases
echo alias k=\"microk8s kubectl\" >> .bash_aliases
source .bash_aliases

kubectl apply -f posthaste-infra/services.yaml

# install and start nginx
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

sudo apt-get -y install jq

sudo chmod o+rx ~
sudo rm -rf /var/www/html
sudo ln -s ~/posthaste-infra/html /var/www/

sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -s ~/posthaste-infra/nginx-site /etc/nginx/sites-enabled
sudo systemctl reload nginx

