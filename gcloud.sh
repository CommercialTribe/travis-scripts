set -e

GOOGLE_CLOUD_SDK_VERSION=216.0.0-0

echo "################################"
echo "# Installing latest:           #"
echo "#  - docker-ce (docker)        #"
echo "#  - kubectl                   #"
# echo "#  - google-cloud-sdk (gcloud) #"
echo "#  - google-cloud-sdk (gcloud) ${GOOGLE_CLOUD_SDK_VERSION} #"
echo "################################"

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
sudo apt-get install docker-ce google-cloud-sdk=${GOOGLE_CLOUD_SDK_VERSION} kubectl

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

export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcloud.json
echo ${GCLOUD_ENCODED_CREDS} | base64 -d > ${GOOGLE_APPLICATION_CREDENTIALS}
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

# Setup credentials for Google Cloud staging and production
gcloud container clusters get-credentials staging --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials production --zone=us-east1-c --project=commercial-tribe

echo "###########"
echo "# kubectl #"
echo "###########"
kubectl version

# Authorize Docker
gcloud auth configure-docker
docker login -u _json_key --password-stdin https://gcr.io < ${GOOGLE_APPLICATION_CREDENTIALS}
