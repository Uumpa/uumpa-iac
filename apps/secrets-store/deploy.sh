#!/usr/bin/env bash

helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts &&\
helm repo update &&\
helm dependency build apps/secrets-store/ &&\
helm template secrets-store apps/secrets-store/ --namespace kube-system | kubectl apply -f -
