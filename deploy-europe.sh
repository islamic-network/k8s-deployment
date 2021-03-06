#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo "Deploying to the cluster in Europe..."
envsubst <./.k8s/manifest-europe.yml >./.k8s/manifest-europe.yml.out
mv ./.k8s/manifest-europe.yml.out ./.k8s/manifest-europe.yml

echo "$K8S_EUROPE_CERTIFICATE" | base64 --decode > cert-eur.crt
ls -la
./kubectl apply -f ./.k8s/manifest-europe.yml --kubeconfig=/dev/null --server=$K8S_EUROPE_SERVER --certificate-authority=cert-eur.crt --token=$K8S_EUROPE_TOKEN


