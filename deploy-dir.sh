#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

echo "$K8S_EUROPE_CERTIFICATE" | base64 --decode > cert.crt

./kubectl \
  --kubeconfig=/dev/null \
  --server=$K8S_EUROPE_SERVER \
  --certificate-authority=cert.crt \
  --token=$K8S_EUROPE_TOKEN \
  apply -f .
