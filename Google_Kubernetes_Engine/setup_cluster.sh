#!/usr/bin/env bash

# Installing Tiller with RBAC enabled
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller


kubectl get deployments -n kube-system

# Deploy NGINX Ingress Controller with RBAC disabled
helm install --name nginx-ingress stable/nginx-ingress