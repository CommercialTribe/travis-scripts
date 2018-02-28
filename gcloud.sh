set -e

# Re-install Gcloud from Scratch
echo "Installing gcloud"
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; fi
curl -o $HOME/google-cloud-sdk-187.0.0-linux-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-187.0.0-linux-x86_64.tar.gz
tar -xzf $HOME/google-cloud-sdk-187.0.0-linux-x86_64.tar.gz
$HOME/google-cloud-sdk/install.sh -q
gcloud version

# Authenticate with Google Cloud
echo "Decoding creds"
echo $GCLOUD_ENCODED_CREDS | base64 -d > /tmp/gcloud.json
echo "Activating service account"
gcloud auth activate-service-account --key-file=/tmp/gcloud.json

# Setup credentials for Google Cloud staging and production
echo "Fetching cluster config"
gcloud container clusters get-credentials staging --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials production --zone=us-east1-c --project=commercial-tribe

# Authorize Docker
gcloud docker --authorize-only
