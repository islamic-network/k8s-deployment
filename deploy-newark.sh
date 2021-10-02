#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in Newark..."
envsubst <./.k8s/manifest-newark.yml >./.k8s/manifest-newark.yml.out
mv ./.k8s/manifest-newark.yml.out ./.k8s/manifest-newark.yml

echo "$K8S_NEWARK_CA" | base64 --decode > cert-newark.crt
ls -la
./kubectl apply -f ./.k8s/manifest-newark.yml --kubeconfig=/dev/null --server=$K8S_NEWARK_URL --certificate-authority=cert-newark.crt --token=$K8S_NEWARK_TOKEN


