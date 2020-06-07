#! /bin/bash
# exit script when any command ran here returns with non-zero exit code
set -e

# since the only way for envsubst to work on files is using input/output redirection,
#  it's not possible to do in-place substitution, so we need to save the output to another file
#  and overwrite the original with that one.

echo "$K8S_EUROPE_CERTIFICATE" | base64 --decode > cert.crt

./kubectl \
  --kubeconfig=/dev/null \
  --server=$K8S_EUROPE_SERVER \
  --certificate-authority=cert.crt \
  --token=$K8S_EUROPE_TOKEN \
  apply -f ./common/ \
  -f ./common/api/ \
  -f ./common/app/ \
  -f ./common/cdn/ \
  -f ./europe/api/ \
  -f ./europe/app/ \
  -f ./europe/cdn/
