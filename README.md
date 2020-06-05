# FluxCD

## Testing on local Kubernetes cluster
The easiest way to run a local Kubernetes 'cluster' is to install [k3d](https://github.com/rancher/k3d). This is a wrapper around k3s and runs everything in Docker.

### Install k3d
On MacOS:
```
brew install k3d
```

### Create cluster
Create the cluster with `k3d create` and set the `KUBECONFIG` environment variable as shown.

### Install Flux
```
./flux-init.sh
```

## Cleanup
Just delete the local cluster
```
k3d delete
```
