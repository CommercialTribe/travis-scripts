set -e

# Install latest Docker
sudo apt-get update
sudo apt-get install docker-ce

# Install latest docker-compose
# TODO Get latest release.
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose