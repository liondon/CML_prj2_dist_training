#!/bin/sh
# Derived from https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#using-kfctl
# Retrieved May 3 2021 

# Set KF_NAME to the name of your Kubeflow deployment. This also becomes the
# name of the directory containing your configuration.
# For example, your deployment name can be 'my-kubeflow' or 'kf-test'.
export KF_NAME=kf-cluster

# Set the path to the base directory where you want to store one or more 
# Kubeflow deployments. For example, /opt/.
# Then set the Kubeflow application directory for this deployment.
export BASE_DIR=/home/vagrant/opt/.
export KF_DIR=${BASE_DIR}/${KF_NAME}

# Set the configuration file to use, such as:
export CONFIG_FILE=kfctl_ibm.yaml
export CONFIG_URI="https://raw.githubusercontent.com/IBM/manifests/v1.3/distributions/kfdef/kfctl_ibm.v1.3.0.yaml"

# Generate Kubeflow:
mkdir -p ${KF_DIR}
cd ${KF_DIR}
curl -L ${CONFIG_URI} > ${CONFIG_FILE}

# Deploy Kubeflow. You can customize the CONFIG_FILE if needed.
kfctl apply -V -f ${CONFIG_FILE}
