set -e

# Install Psykube
export PSYKUBE_RELEASES_URL=https://api.github.com/repos/commercialtribe/psykube/releases/latest
export PSYKUBE_DOWNLOAD_URL=`curl -sSL $PSYKUBE_RELEASES_URL | jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'`
curl -sSL $PSYKUBE_DOWNLOAD_URL | sudo tar -xzC /usr/local/bin

# Install Kubectl
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/kubectl.sh | bash

# Authorize Gcloud
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/gcloud.sh | bash
