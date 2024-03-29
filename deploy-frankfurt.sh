#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in frankfurt..."
envsubst <./.k8s/manifest-frankfurt.yml >./.k8s/manifest-frankfurt.yml.out
mv ./.k8s/manifest-frankfurt.yml.out ./.k8s/manifest-frankfurt.yml

echo "$K8S_FRANKFURT_CA" | base64 --decode > cert-frankfurt.crt
ls -la
./kubectl apply -f ./.k8s/manifest-frankfurt.yml --kubeconfig=/dev/null --server=$K8S_FRANKFURT_URL --certificate-authority=cert-frankfurt.crt --token=$K8S_FRANKFURT_TOKEN


