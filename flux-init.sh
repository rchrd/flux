#!/usr/bin/env bash

# https://github.com/stefanprodan/gitops-istio/blob/master/scripts/flux-init.sh

set -e

if [[ ! -x "$(command -v kubectl)" ]]; then
    echo "kubectl not found"
    exit 1
fi

if [[ ! -x "$(command -v helm)" ]]; then
    echo "helm not found"
    exit 1
fi

helm repo add fluxcd https://charts.fluxcd.io

echo ">>> Installing Flux"
kubectl create ns flux || true
helm upgrade -i flux fluxcd/flux \
--wait \
--values flux-values.yaml \
--namespace flux

echo ">>> Installing Helm Operator"
kubectl apply -f crds.yaml
helm upgrade -i helm-operator fluxcd/helm-operator \
--wait \
--set git.ssh.secretName=flux-git-deploy \
--set helm.versions=v3 \
--namespace flux

echo ">>> GitHub deploy key"
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2

# wait until flux is able to sync with repo
echo ">>> Waiting on user to add above deploy key to Github with write access"
until kubectl logs -n flux deployment/flux | grep event=refreshed
do
  sleep 5
done
echo ">>> Github deploy key is ready"

echo ">>> Cluster bootstrap done!"