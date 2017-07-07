set -e

curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/gcloud.sh | sh

# Install Psykube
export PSYKUBE_RELEASES_URL=https://api.github.com/repos/commercialtribe/psykube/releases/latest
export PSYKUBE_DOWNLOAD_URL=`curl -sSL $PSYKUBE_RELEASES_URL | jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'`
curl -sSL $PSYKUBE_DOWNLOAD_URL | sudo tar -xzC /usr/local/bin

# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
