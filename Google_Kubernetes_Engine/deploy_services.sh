#!/usr/bin/env bash

kubectl apply -f deployments/echo1.yaml
kubectl apply -f deployments/echo2.yaml

kubectl apply -f ingress/echo_ingress.yaml