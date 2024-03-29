#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in mumbai..."
envsubst <./.k8s/manifest-mumbai.yml >./.k8s/manifest-mumbai.yml.out
mv ./.k8s/manifest-mumbai.yml.out ./.k8s/manifest-mumbai.yml

echo "$K8S_MUMBAI_CA" | base64 --decode > cert-mumbai.crt
ls -la
./kubectl apply -f ./.k8s/manifest-mumbai.yml --kubeconfig=/dev/null --server=$K8S_MUMBAI_URL --certificate-authority=cert-mumbai.crt --token=$K8S_MUMBAI_TOKEN


