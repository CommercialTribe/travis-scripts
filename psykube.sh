set -e

# Install other docker, k8s deps and authorize on GCP
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/gcloud.sh | bash

PSYKUBE_VERSION=${PSYKUBE_VERSION:-v1.9.3.0}

echo "#########################################"
echo "# Installing psykube ${PSYKUBE_VERSION} #"
echo "#########################################"

# Install Psykube
PSYKUBE_RELEASES_URL=https://api.github.com/repos/psykube/psykube/releases/tags/${PSYKUBE_VERSION}
PSYKUBE_RELEASE_RESULTS=`curl -sSL -H "Authorization: token ${GITHUB_API_TOKEN}" ${PSYKUBE_RELEASES_URL}`
PSYKUBE_DOWNLOAD_URL=`echo ${PSYKUBE_RELEASE_RESULTS} | jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'`
curl -sSL ${PSYKUBE_DOWNLOAD_URL} | sudo tar -xzC /usr/local/bin
