# Terraform config to launch nodes for an RKE1 or RKE2 cluster in VMware Environment

## Summary

This Terraform setup will:

- Provision Virtual Machines to vSphere Environment and install software prerequisites for RKE1 or RKE2
- For RKE1, it create a cluster.yml configuration file containing those Virtual Machines details to enable provisioning a Kubernetes clusters with [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/)


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