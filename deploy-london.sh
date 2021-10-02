#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in london..."
envsubst <./.k8s/manifest-london.yml >./.k8s/manifest-london.yml.out
mv ./.k8s/manifest-london.yml.out ./.k8s/manifest-london.yml

echo "$K8S_LONDON_CA" | base64 --decode > cert-london.crt
ls -la
./kubectl apply -f ./.k8s/manifest-london.yml --kubeconfig=/dev/null --server=$K8S_LONDON_URL --certificate-authority=cert-london.crt --token=$K8S_LONDON_TOKEN


