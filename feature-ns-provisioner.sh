set -e

# Install Psykube
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/travis-test/psykube.sh | bash

# Install the provisioning script
export FEATURE_NAMESPACES_RELEASES_URL=https://api.github.com/repos/commercialtribe/kubes-namespace-provisioner/releases/latest?access_token=$GITHUB_API_TOKEN
export FEATURE_NAMESPACES_DOWNLOAD_URL=`curl -sSL $FEATURE_NAMESPACES_RELEASES_URL | jq -r '.assets[] | select(.name | contains("linux")).url'`
export ACCEPTED_HEADER=Accept:application/octet-stream
curl -L -H $ACCEPTED_HEADER -o kubes-namespace-provisioner $FEATURE_NAMESPACES_DOWNLOAD_URL?access_token=$GITHUB_API_TOKEN
chmod +x ./kubes-namespace-provisioner
sudo mv ./kubes-namespace-provisioner /usr/local/bin/kubes-namespace-provisioner
