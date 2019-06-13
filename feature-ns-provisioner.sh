set -e

# Install Psykube
curl -sSL https://raw.githubusercontent.com/CommercialTribe/travis-scripts/master/psykube.sh | bash

NAMESPACE_PROVISIONER_VERSION=${NAMESPACE_PROVISIONER_VERSION:-v4.0.0}

echo "#####################################################################"
echo "# Installing namespace provisioner ${NAMESPACE_PROVISIONER_VERSION} #"
echo "#####################################################################"

# Install the provisioning script
AUTHORIZATION_HEADER="Authorization: token ${GITHUB_API_TOKEN}"
ACCEPT_HEADER="Accept: application/octet-stream"

NAMESPACE_PROVISIONER_RELEASE_URL=https://api.github.com/repos/commercialtribe/kubes-namespace-provisioner/releases/tags/${NAMESPACE_PROVISIONER_VERSION}
NAMESPACE_PROVISIONER_DOWNLOAD_URL=`curl -sSL -H "${AUTHORIZATION_HEADER}" ${NAMESPACE_PROVISIONER_RELEASE_URL} | jq -r '.assets[] | select(.name | contains("linux")).url'`

curl -L -H "${ACCEPT_HEADER}" -o kubes-namespace-provisioner ${NAMESPACE_PROVISIONER_DOWNLOAD_URL}?access_token=${GITHUB_API_TOKEN}
chmod +x ./kubes-namespace-provisioner
sudo mv ./kubes-namespace-provisioner /usr/local/bin/kubes-namespace-provisioner
