#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

COMMIT_TAG=$CIRCLE_TAG

# We must export it so it's available for envsubst
export COMMIT_TAG=$COMMIT_TAG

echo $CIRCLE_TAG

echo $COMMIT_TAG
# since the only way for envsubst to work on files is using input/output redirection,
#  it's not possible to do in-place substitution, so we need to save the output to another file
#  and overwrite the original with that one.
envsubst <./.kube/manifest.yml >./.kube/manifest.yml.out
mv ./.kube/manifest.yml.out ./.kube/manifest.yml

echo "$K8S_CLUSTER_CERTIFICATE" | base64 --decode > cert.crt

./kubectl \
  --kubeconfig=/dev/null \
  --server=$K8S_SERVER \
  --certificate-authority=cert.crt \
  --token=$K8S_TOKEN \
  --namespace=islamic-network \
  apply -f ./.kube/
