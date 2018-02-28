set -e

# Uncomment and use if specific gcloud version is needed.
# GCLOUD_SDK_VERSION=187.0.0
# export CLOUDSDK_CORE_DISABLE_PROMPTS=1;
# curl -o ${HOME}/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz
# tar -xzf ${HOME}/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz
# ${HOME}/google-cloud-sdk/install.sh -q

# Re-install Gcloud from Scratch
echo "Installing gcloud"
if [ ! -d "${HOME}/google-cloud-sdk/bin" ]; then rm -rf ${HOME}/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi
source /home/travis/google-cloud-sdk/path.bash.inc
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
gcloud docker --authorize-only
