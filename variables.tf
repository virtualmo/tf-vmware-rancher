##### Provider
# - Arguments to configure the VMware vSphere Provider

variable "vsphere_server" {
  description = "vCenter server FQDN or IP - Example: vcsa01-z67.sddc.lab"
}

variable "vsphere_user" {
  description = "vSphere username to use to connect to the environment - Default: administrator@vsphere.local"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "vSphere password"
}

##### Infrastructure
# - Defines the vCenter / vSphere environment

variable "vsphere_datacenter" {
  description = "vSphere datacenter in which the virtual machine will be deployed."
}

variable "vsphere_cluster" {
  description = "vSphere cluster in which the virtual machine will be deployed."
}

variable "vsphere_datastore" {
  description = "Datastore in which the virtual machine will be deployed."
}

variable "vsphere_folder" {
  description = "The path to the folder to put this virtual machine in, relative to the datacenter that the resource pool is in."
}

variable "vsphere_mgmt_network" {
  description = "Porgroup to which the virtual machine will be connected."
}

##### Guest
# - Describes virtual machine / guest options

variable "guest_name_prefix" {
  description = "VM hostname prefix"
}

variable "guest_template" {
  description = "The source virtual machine or template to clone from."
  default     = "ubuntu-20.04-cloud-init"
}

variable "guest_all_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine. Default: 4."
  default     = "4"
}

variable "guest_all_memory" {
  description = "The size of the virtual machine's memory, in MB. Default: 8192 (8 GB)."
  default     = "8192"
}

variable "guest_all_disk" {
  description = "The size of the virtual machine's disk, in GB. Default: 40 GB."
  default     = "40"
}


variable "guest_etcd_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine. Default: 4."
  default     = "4"
}

variable "guest_etcd_memory" {
  description = "The size of the virtual machine's memory, in MB. Default: 8192 (8 GB)."
  default     = "8192"
}

variable "guest_etcd_disk" {
  description = "The size of the virtual machine's disk, in GB. Default: 40 GB."
  default     = "40"
}

variable "guest_controlplane_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine. Default: 4."
  default     = "4"
}

variable "guest_controlplane_memory" {
  description = "The size of the virtual machine's memory, in MB. Default: 8192 (8 GB)."
  default     = "8192"
}

variable "guest_controlplane_disk" {
  description = "The size of the virtual machine's disk, in GB. Default: 40 GB."
  default     = "40"
}

variable "guest_worker_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine. Default: 4."
  default     = "4"
}

variable "guest_worker_memory" {
  description = "The size of the virtual machine's memory, in MB. Default: 8192 (8 GB)."
  default     = "8192"
}

variable "guest_worker_disk" {
  description = "The size of the virtual machine's disk, in GB. Default: 40 GB."
  default     = "40"
}

variable "guest_ssh_key" {
  description = "SSH public key (e.g., id_rsa.pub)."
}

variable "guest_user" {
  description = "Guest VM user"
  default     = "rancher"
}

variable "count_all_nodes" {
  description = "number of all nodes"
}

variable "count_etcd_nodes" {
  description = "number of etcd nodes"
}

variable "count_controlplane_nodes" {
  description = "number of control plane nodes"
}

variable "count_worker_nodes" {
  description = "number of worker nodes"
}

variable "docker_version" {
  description = "docker version for RKE1"
}

variable "rke_version" {
  description = "rke version (RKE1 or RKE2)"
}

variable "do_token" {
  description = "Digital ocean token to create DNS record."
}
variable "digitalocean_domain" {
  description = "Digital ocean domain to add A record for first all role node"
}