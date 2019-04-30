#!/usr/bin/env bash

kubectl delete -f ingress/echo_ingress.yaml

kubectl delete -f deployments/echo1.yaml
kubectl delete -f deployments/echo2.yaml

gcloud container clusters delete kube-cluster
