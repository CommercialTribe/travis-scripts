set -e

# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Authorize Gcloud
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/gcloud.sh | bash
