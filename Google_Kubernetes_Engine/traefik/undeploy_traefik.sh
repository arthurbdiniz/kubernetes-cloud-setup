#!/usr/bin/env bash

kubectl delete -f 01_permissions.yml
kubectl delete -f 02_cluster-role.yml
kubectl delete -f 03_config.yml
kubectl delete -f 04_deployment.yml
kubectl delete -f 05_service.yml