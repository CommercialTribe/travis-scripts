set -e

echo "################################"
echo "# Installing latest:           #"
echo "#  - docker-ce (docker)        #"
echo "#  - kubectl                   #"
echo "#  - google-cloud-sdk (gcloud) #"
echo "################################"

# Setup google-cloud-sdk repo
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt ${CLOUD_SDK_REPO} main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# Setup kubectl repo
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Update the package list and install the Cloud SDK
sudo apt-get update
# Upgrade dpkg to >= 1.17.5ubuntu5.8, which fixes https://bugs.launchpad.net/ubuntu/+source/dpkg/+bug/1730627
sudo apt-get install -qq -y dpkg
sudo apt-get install docker-ce google-cloud-sdk kubectl

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
echo "##########"
echo "# gcloud #"
echo "##########"
gcloud version
echo ""
echo "#################################"
echo "# Authorizing with Google Cloud #"
echo "#################################"
echo ""

GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcloud.json
echo ${GCLOUD_ENCODED_CREDS} | base64 -d > ${GOOGLE_APPLICATION_CREDENTIALS}
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

# Setup credentials for Google Cloud staging and production
K8S_CLUSTER_STAGING=${K8S_CLUSTER_STAGING:-staging}
K8S_CLUSTER_PRODUCTION=${K8S_CLUSTER_PRODUCTION:-production}

gcloud container clusters get-credentials ${K8S_CLUSTER_STAGING} --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials ${K8S_CLUSTER_PRODUCTION} --zone=us-east1-c --project=commercial-tribe

echo "###########"
echo "# kubectl #"
echo "###########"
kubectl version

# Authorize Docker Hub
if [ -n "${DOCKER_HUB_USERNAME}" ] && [ -n "${DOCKER_HUB_ACCESS_TOKEN}" ]; then
  echo "${DOCKER_HUB_ACCESS_TOKEN}" | docker login --username ${DOCKER_HUB_USERNAME} --password-stdin
else
  echo "Missing DOCKER_HUB_USERNAME or DOCKER_HUB_ACCESS_TOKEN, skipping authentication with Docker Hub"
fi

# Authorize GCP Docker
gcloud auth configure-docker
docker login -u _json_key --password-stdin https://gcr.io < ${GOOGLE_APPLICATION_CREDENTIALS}
