#!/usr/bin/env bash
#k3d cluster delete gamesmith-dev
k3d registry create szippy-registry.localhost -p 12345

k3d cluster create --config \
$PWD/dev-env/setup/dev-config.yaml --volume $PWD:/szippy

kubectl create namespace szippy
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

