#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in singapore..."
envsubst <./.k8s/manifest-singapore.yml >./.k8s/manifest-singapore.yml.out
mv ./.k8s/manifest-singapore.yml.out ./.k8s/manifest-singapore.yml

echo "$K8S_SINGAPORE_CA" | base64 --decode > cert-singapore.crt
ls -la
./kubectl apply -f ./.k8s/manifest-singapore.yml --kubeconfig=/dev/null --server=$K8S_SINGAPORE_URL --certificate-authority=cert-singapore.crt --token=$K8S_SINGAPORE_TOKEN


