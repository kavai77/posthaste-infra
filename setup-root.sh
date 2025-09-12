sudo adduser --gecos "" posthaste
sudo usermod -aG sudo posthaste
su posthaste
cd
git clone git@github.com:kavai77/posthaste-infra.git
./posthaste-infra/setup-ubuntu.sh
