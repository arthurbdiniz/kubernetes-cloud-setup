#!/usr/bin/env bash

kubectl delete -f ../echo_ingress_no_tls.yaml

kubectl delete -f ../echo1.yaml
kubectl delete -f ../echo2.yaml

helm del --purge nginx-ingress

gcloud container clusters delete kube-cluster
