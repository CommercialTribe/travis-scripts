set -e

# Re-install Gcloud from Scratch
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; fi
curl -o google-cloud-sdk-187.0.0-linux-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-187.0.0-linux-x86_64.tar.gz
tar -czvf google-cloud-sdk-187.0.0-linux-x86_64.tar.gz $HOME/google-cloud-sdk
$HOME/google-cloud-sdk/install.sh
$HOME/google-cloud-sdk/google-cloud-sdk/bin/gcloud init
gcloud version

# Authenticate with Google Cloud
echo $GCLOUD_ENCODED_CREDS | base64 -d > /tmp/gcloud.json
gcloud auth activate-service-account --key-file=/tmp/gcloud.json

# Setup credentials for Google Cloud staging and production
gcloud container clusters get-credentials staging --zone=us-central1-a --project=commercial-tribe-staging
gcloud container clusters get-credentials production --zone=us-east1-c --project=commercial-tribe

# Authorize Docker
gcloud docker --authorize-only
