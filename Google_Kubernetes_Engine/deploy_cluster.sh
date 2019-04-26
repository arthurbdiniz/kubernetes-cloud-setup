#!/usr/bin/env bash

# Create a Kubernetes Engine cluster using Cloud Shell
gcloud config set compute/zone us-central1-f
gcloud container clusters create kube-cluster --num-nodes=2

