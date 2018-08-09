set -e

echo "################################"
echo "# Installing latest:           #"
echo "#  - docker-ce (docker)        #"
echo "#  - kubectl                   #"
echo "#  - google-cloud-sdk (gcloud) #"
echo "################################"

# Setup docker-ce repo
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Setup google-cloud-sdk repo
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Setup kubectl repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Update the package list and install the Cloud SDK
sudo apt-get update
sudo apt-get install docker-ce google-cloud-sdk kubectl

# Install latest docker-compose
# DOCKER_COMPOSE_RELEASE_URL=https://api.github.com/repos/docker/compose/releases/latest
# DOCKER_COMPOSE_VERSION=`curl -sSL -H "Authorization: token ${GITHUB_API_TOKEN}" ${DOCKER_COMPOSE_RELEASE_URL} | jq -r .tag_name`
# sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

# Print version information
echo ""
echo "##########"
echo "# docker #"
echo "##########"
docker version
echo "##################"
echo "# docker-compose #"
echo "##################"
docker-compose version
echo "###########"
echo "# kubectl #"
echo "###########"
kubectl version
echo "##########"
echo "# gcloud #"
echo "##########"
gcloud version
echo ""
echo "#################################"
echo "# Authorizing with Google Cloud #"
echo "#################################"
echo ""

echo ${GCLOUD_ENCODED_CREDS} | base64 -d > /tmp/gcloud.json
gcloud auth activate-service-account --key-file=/tmp/gcloud.json

# Setup credentials for Google Cloud staging and production
gcloud container clusters get-credentials staging --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials production --zone=us-east1-c --project=commercial-tribe

# Authorize Docker
gcloud auth configure-docker
docker login -u _json_key --password-stdin https://gcr.io < /tmp/gcloud.json
