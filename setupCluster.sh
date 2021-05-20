#!/bin/sh

# Derived from https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#storage-setup-for-a-classic-ibm-cloud-kubernetes-cluster
# Retrieved May 3 2021 

ibmcloud ks cluster config --cluster $1

# Set the File Storage with Group ID support as the default storage class.
export NEW_STORAGE_CLASS=ibmc-file-gold-gid
export OLD_STORAGE_CLASS=$(kubectl get sc -o jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io\/is-default-class=="true")].metadata.name}')
kubectl patch storageclass ${NEW_STORAGE_CLASS} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Remove other default storage classes
kubectl patch storageclass ${OLD_STORAGE_CLASS} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

# List all the (default) storage classes
echo "You should see only ibmc-file-gold-gid (default) listed below:"
kubectl get storageclass | grep "(default)"
