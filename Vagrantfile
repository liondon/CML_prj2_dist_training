# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Ubuntu 18.04
  config.vm.box = "ubuntu/bionic64"

  # Keep the VM as lean as possible
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
  end

  # Copy your .gitconfig file so that your git credentials are correct
  if File.exists?(File.expand_path("~/.gitconfig"))
    config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"
  end

  # Install Docker
  config.vm.provision :docker

  config.vm.provision "shell", inline: <<-SHELL
    # Verify Docker Installation
    docker --version

    # Install tools
    apt-get update
    apt-get install -y git apt-transport-https ca-certificates gnupg

    # Install the IBM Cloud CLI and plugins & kubectl
    sudo -H -u vagrant sh -c 'curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash'
    sudo -H -u vagrant bash -c "ibmcloud plugin list"

    # Install gcloud CLI for GKE
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update && apt-get install -y google-cloud-sdk
    # gcloud init
    # gcloud container clusters get-credentials <cluster-name>
    # kubectl config current-context

    # Install kustomize
    # sudo -H -u vagrant sh -c 'curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash'
    sudo -H -u vagrant sh -c 'echo "export PATH=$PATH:/vagrant:/home/vagrant" >> ~/.profile'

  SHELL

end
