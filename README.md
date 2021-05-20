# Distributed Training with and without Kubeflow

## Prerequisite
```
virtual-box
vagrant
```

## Distributed Training on K8s cluster

1. Start the vagrant machine:
    ```sh
    cd <project-root-dir>
    vagrant up
    vagrant ssh
    ```

2. Config `kubectl` with the K8s cluster of your choice. (The vagrant machine has `gcloud` CLI and `ibmcloud` CLI installed.)

3. (Optional) Build and update the training container:
   3.1 Build the Docker image:
    ```sh
    cd /vagrant/dist_training_keras_k8s
    docker build -t dist_training:latest .
    ```

   3.2 (Optional) Test the container:
    ```sh
    # create a network
    docker network create \
    --subnet=172.18.0.0/16 \
    --gateway=172.18.0.1 \
    test-net

    # run worker0 container
    docker run --rm \
    --name worker0 \
    -p 12345:12345 \
    --network=test-net \
    dist_training:latest

    # run worker1 container
    docker run --rm \
    --name worker1 \
    -p 23456:23456 \
    --network=test-net \
    -e "TF_CONFIG={\"cluster\":{\"worker\":[\"172.18.0.1:12345\",\"172.18.0.1:23456\"]},\"task\":{\"type\":\"worker\",\"index\":1}}" \
    dist_training:latest
    ```

    3.3 Push the image to a registry and replace the image location in the K8s yaml files.
    ```sh
    # using Docker hub as example:    
    # first, create a repository on Docker hub. Then run the following:
    docker logout
    docker login
    docker tag dist_training:latest <user_name>/<repo_name>:latest
    docker push <user_name>/<repo_name>:latest

    # replace spec.template.spec.containers.image in both yaml files.
    ```

4. Deploy to K8s cluster:
    ```sh
    kubectl apply -f worker0.yaml
    kubectl apply -f worker1.yaml

    # NOTE: lacking resources could cause the K8s job to fail
    # The jobs will restart automatically on failure.
    # Run this to check the termination message.
    # See https://kubernetes.io/docs/tasks/debug-application-cluster/determine-reason-pod-failure/ for more information.
    kubectl get pods
    kubectl get pod <pod-name> --output=yaml
    ```

5. Get the log. You should be able to see both workers finish one epoch. NOTE: You can config the number of epochs in the yaml file, but the number should be the same in the two yaml files.
   ```sh
   kubectl logs <pod-name>
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
- https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras
- https://github.com/tensorflow/ecosystem/tree/master/distribution_strategy
- https://www.kubeflow.org/docs/distributions/ibm/iks-e2e/#run-the-mnist-tutorial-on-iks
