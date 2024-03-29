#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in dallas..."
envsubst <./.k8s/manifest-dallas.yml >./.k8s/manifest-dallas.yml.out
mv ./.k8s/manifest-dallas.yml.out ./.k8s/manifest-dallas.yml

echo "$K8S_DALLAS_CA" | base64 --decode > cert-dallas.crt
ls -la
./kubectl apply -f ./.k8s/manifest-dallas.yml --kubeconfig=/dev/null --server=$K8S_DALLAS_URL --certificate-authority=cert-dallas.crt --token=$K8S_DALLAS_TOKEN


