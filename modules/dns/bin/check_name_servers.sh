#!/usr/bin/env bash

DIG="$(dig +short $1 NS)"
for NS in "${@:2}"; do
  if ! echo "${DIG}" | grep -q "${NS}"; then
    echo "ERROR: ${NS} not found in ${DIG}"
    exit 1
  fi
done
echo "OK: ${DIG}"
exit 0
