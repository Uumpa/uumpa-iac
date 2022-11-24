#!/usr/bin/env bash

if [ -z "$KEYVAULT_UUMPA_ROOT_DOMAIN" ]; then exit 1; fi
if [ -z "$KEYVAULT_ADMIN_EMAIL" ]; then exit 1; fi

az keyvault secret set --name "uumpa-root-domain" --vault-name "${1}" --value "${KEYVAULT_UUMPA_ROOT_DOMAIN}" &&\
az keyvault secret set --name "admin-email" --vault-name "${1}" --value "${KEYVAULT_ADMIN_EMAIL}"
