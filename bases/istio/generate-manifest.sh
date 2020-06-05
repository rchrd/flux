#!/bin/bash

docker container run \
  --name istioctl \
  --rm \
  -v "$PWD":"$PWD" \
  -w "$PWD" \
  istio/istioctl:1.6.1 \
    manifest -f custom-config.yaml generate > ./generated-manifest.yaml
