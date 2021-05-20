#!/bin/sh
# Derived from https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#expose-the-kubeflow-endpoint-as-a-loadbalancer
# Retrieved May 3 2021 

kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc istio-ingressgateway -n istio-system
