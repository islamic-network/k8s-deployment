#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$REF_NAME

# We must export it so it's available for envsubst
export COMMIT_TAG=$REF_NAME

echo $COMMIT_TAG

echo "Deploying to the cluster..."
envsubst <./.k8s/manifest.yml >./.k8s/manifest.yml.out
mv ./.k8s/manifest.yml.out ./.k8s/manifest.yml

echo "$K8S_CA" | base64 --decode > cert.crt

./kubectl apply -f ./.k8s/manifest.yml --kubeconfig=/dev/null --server=$K8S_URL --certificate-authority=cert.crt --token=$K8S_TOKEN


