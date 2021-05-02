#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in Europe..."
envsubst <./.k8s/manifest-europe.yml >./.k8s/manifest-europe.yml.out
mv ./.k8s/manifest-europe.yml.out ./.k8s/manifest-europe.yml

./kubectl --kubeconfig=/dev/null --server=$K8S_EUROPE_SERVER --certificate-authority=cert.crt --token=$K8S_EUROPE_TOKEN apply -f ./.k8s/manifest-europe.yml

echo "Deploying to the cluster in Asia..."
envsubst <./.k8s/manifest-asia.yml >./.k8s/manifest-asia.yml.out
mv ./.k8s/manifest-asia.yml.out ./.k8s/manifest-asia.yml

./kubectl --kubeconfig=/dev/null --server=$K8S_ASIA_SERVER --certificate-authority=cert.crt --token=$K8S_ASIA_TOKEN apply -f ./.k8s/manifest-asia.yml

