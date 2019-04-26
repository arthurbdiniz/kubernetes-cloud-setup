#!/usr/bin/env bash

kubectl create -f ../echo1.yaml
kubectl create -f ../echo2.yaml

kubectl create -f ../echo_ingress_no_tls.yaml