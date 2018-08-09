set -e

echo "Installing latest docker and gcloud"
# Create environment variable for correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Update the package list and install the Cloud SDK
sudo apt-get update
sudo apt-get install docker-ce google-cloud-sdk

# Install latest docker-compose
DOCKER_COMPOSE_VERSION=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | jq -r .tag_name)
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Print version information
echo "docker version"
docker version
echo "docker-compose version"
docker-compose version
echo "gcloud version"
gcloud version

# Authenticate with Google Cloud
echo "Decoding creds"
echo ${GCLOUD_ENCODED_CREDS} | base64 -d > /tmp/gcloud.json
echo "Activating service account"
gcloud auth activate-service-account --key-file=/tmp/gcloud.json

# Setup credentials for Google Cloud staging and production
echo "Fetching cluster config"
gcloud container clusters get-credentials staging --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials production --zone=us-east1-c --project=commercial-tribe

# Authorize Docker
gcloud auth configure-docker
docker login -u _json_key --password-stdin https://gcr.io < /tmp/gcloud.json
