#!/usr/bin/env bash

./write_tfvars.py &&\
terraform apply "$@" &&\
./set_kubernetes_context.py &&\
./save_terraform_outputs.py
