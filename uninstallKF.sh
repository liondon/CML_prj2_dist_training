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

# Go to your Kubeflow deployment directory
cd ${KF_DIR}

# Remove Kubeflow
kfctl delete -f ${CONFIG_FILE}
# rm -rf kustomize .cache
