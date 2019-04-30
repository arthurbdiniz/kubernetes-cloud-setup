#!/usr/bin/env bash

kubectl apply -f 01_permissions.yml
kubectl apply -f 02_cluster-role.yml
kubectl apply -f 03_config.yml
kubectl apply -f 04_deployment.yml
kubectl apply -f 05_service.yml