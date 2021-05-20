# Distributed Training with and without Kubeflow

## Prerequisite
```
virtual-box
vagrant
```


## Distributed Training with Kubeflow

1. Lanch a K8s cluster: 
   On IBM Cloud, create a `classic` K8s cluster with default settings. This is not included in free tier or provided class resources, but TFJob requires that cluster is set up for RWX (read-write multiple nodes) type of storages. See [this page](https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks) for more information.

2. Config the classic cluster following [this instruction](https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#storage-setup-for-a-classic-ibm-cloud-kubernetes-cluster). The commands are also included as shell script in this repo. 
   ```sh
   cd /vagrant 
   ibmcloud login
   sh setupCluster.sh <cluster_name>
   # NOTE: don't run the script more than once 
   ```

3. Install `kfctl`:
   Download `kfctl_v1.2.0-0-gbc038f9_linux.tar.gz` from https://github.com/kubeflow/kfctl/releases, unzip, and put it under either `/vagrant` or `/home/vagrant`.

4. Following [this instruction](https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#using-kfctl) to install Kubeflow to the cluster. The commands are also included as scripts in this repository:
   ```sh
   cd /vagrant
   sh installKF.sh
   ```

5. Expose the Kubeflow Dashboard following [this instruction](https://www.kubeflow.org/docs/distributions/ibm/deploy/install-kubeflow-on-iks/#expose-the-kubeflow-endpoint-as-a-loadbalancer). The commands are also included in this repository as a shell script.
    ```sh
    cd /vagrant
    sh exposeLB.sh

    # You will see the IP to access your Kubeflow dashboard in the EXTERNAL_IP column.
    # Login to the dashboard with the following credentials:
    username=user@example.com
    password=12341234
    ```

6. Launch a Jupyter notebook server.

7. Launch a terminal in Jupyter and clone the Kubeflow examples repo.
    ```sh
    git clone https://github.com/kubeflow/examples.git git_kubeflow-examples
    ```

8. Open the notebook `mnist/mnist_ibm.ipynb`. And follow the notebook to train and deploy TFJob for MNIST on Kubeflow.

   8.1. When running `reload(notebook_setup)`, you may encounter error with `git checkout`. Make the following modification to `mnist/notebook_setup.py`:
    ```py
    clone_dir = os.path.join(home, "git_tf-operator")
    if not os.path.exists(clone_dir):
        logging.info("Cloning the tf-operator repo")
        subprocess.check_call(["git", "clone", 
                            "https://github.com/kubeflow/tf-operator.git",
                            clone_dir])
    logging.info(f"Checkout kubeflow/tf-operator @{TF_OPERATOR_COMMIT}")

    # Add this line:
    subprocess.check_call(["cd", clone_dir])

    subprocess.check_call(["git", "checkout", TF_OPERATOR_COMMIT], cwd=clone_dir)
    ``` 

    8.2 When running into error: `ImportError: No module named 'msrestazure'`, the quick workaround is to install it with `pip3 install msrestazure`

    8.3 You should be able to successfully create the TFJob now. NOTE: the further steps in the notebook is not tested in our project.

## Acknowledgement
This project is derived from the following works:
- https://www.kubeflow.org/docs/distributions/ibm/iks-e2e/#run-the-mnist-tutorial-on-iks
