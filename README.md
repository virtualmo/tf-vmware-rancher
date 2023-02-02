# Terraform config to launch nodes for an RKE1 or RKE2 cluster in VMware Environment

## Summary

This Terraform setup will:

- Provision Virtual Machines to vSphere Environment and install software prerequisites for RKE1 or RKE2
- For RKE1, it create a cluster.yml configuration file containing those Virtual Machines details to enable provisioning a Kubernetes clusters with [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/)