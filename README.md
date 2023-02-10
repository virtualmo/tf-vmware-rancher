# Terraform config to launch nodes for an RKE1 or RKE2 cluster in VMware Environment

## Summary

This Terraform setup will:

- Provision Virtual Machines to vSphere Environment and install software prerequisites for RKE1 or RKE2
- For RKE1, it create a cluster.yml configuration file containing those Virtual Machines details to enable provisioning a Kubernetes clusters with [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/)
- After terraform provisioning complete, you need to deploy [RKE1](https://rancher.com/docs/rke/latest/en/installation/) or [RKE2](https://docs.rke2.io/install/quickstart)

## Usage

1. Clone the repo:
```
$ git clone https://github.com/virtualmo/tf-vmware-rancher.git
```

2. Change directory
```
$ cd tf-vmware-rancher
```


3. copy the example terraform variable file to terraform.tfvars
```
cp terraform.tfvars.example terraform.tfvars
```

4. Update the variable file terraform.tfvars

5. Run the Terraform module:
```
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

- To destroy the environemtn run:
```
$ terraform destroy --auto-approve
```

## RKE1 quick deploy

1. Download and install the required RKE package as per [RKE Installation guide](https://rancher.com/docs/rke/latest/en/installation/)

2. Add you ssh key to ssh-agent
```
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
```

3. run rke up
```
rke up --config cluster.yml
```

- To install rancher check Rancher installation section below.

## RKE2 quick deploy

1. ssh to the controller machine

2. quick install RKE2
```
wget https://raw.githubusercontent.com/virtualmo/rke2-install/main/rke2-master.sh
chmod +x rke2-master.sh
sudo ./rke2-master.sh
```

3. copy kubconfig and kubectl
```
sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/
mkdir ~/.kube
sudo cp /etc/rancher/rke2/rke2.yaml .kube/config
sudo chown $USER .kube/config
chmod 600 .kube/config
```

- To install rancher check Rancher installation section below.


## Rancher Installation

Option 1: use [axeal](https://github.com/axeal/tf-do-rke.git) rancher-install script (*make sure you have helm and kubeconfig*)
```
sudo cp /etc/rancher/rke2/rke2.yaml kube_config_cluster.yml
wget https://raw.githubusercontent.com/axeal/tf-do-rke/master/rancher-install.sh
chmod +x rancher-install.sh
sudo ./rancher-install.sh -H <HOSTNAME> -v <VERSION>
```

Option 2: As per [Rancher guide](https://ranchermanager.docs.rancher.com/v2.6/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster).


### Helm Install on Debian based distributions
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```