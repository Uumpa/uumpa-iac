#!/usr/bin/env bash

SECRET_NAME="${1}"
KEYVAULT_NAME="${2}"
EXPECTED_VALUE="${3}"
INSTRUCTIONS="${4}"

if ! VALUE="$(az keyvault secret show --name $SECRET_NAME --vault-name $KEYVAULT_NAME --query value -o tsv)"; then
  echo "${INSTRUCTIONS}"
  exit 1
elif [ "${EXPECTED_VALUE}" != "" ] && [ "${VALUE}" == "${EXPECTED_VALUE}" ]; then
  echo OK
  exit 0
elif [ "${EXPECTED_VALUE}" == "" ] && [ "${VALUE}" != "" ]; then
  echo OK
  exit 0
else
  echo "${INSTRUCTIONS}"
  exit 1
fi
