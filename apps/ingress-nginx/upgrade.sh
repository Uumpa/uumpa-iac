#!/usr/bin/env bash

VERSION="${1}"

if [[ -z "${VERSION}" ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi &&\
echo Upgrading Nginx Ingress to "${VERSION}" &&\
URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-${VERSION}/deploy/static/provider/cloud/deploy.yaml" &&\
echo "# downloaded $(date +%Y-%m-%d) from:" > apps/ingress-nginx/install.yaml &&\
echo "#   ${URL}" >> apps/ingress-nginx/install.yaml &&\
curl "${URL}" >> apps/ingress-nginx/install.yaml &&\
echo OK
