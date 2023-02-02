provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_mgmt_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "source_template" {
  name          = var.guest_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# see https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs
data "cloudinit_config" "all-nodes" {
  count         = var.count_all_nodes
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config.yml.tmpl", {
      rke_version    = "${var.rke_version}"
      guest_hostname = "${var.guest_name_prefix}-all-nodes-${count.index + 1}"
      guest_user     = "${var.guest_user}"
      guest_ssh_key  = "${var.guest_ssh_key}"
      docker_version = "${var.docker_version}"
    })
  }
}

resource "vsphere_virtual_machine" "all-nodes" {
  count            = var.count_all_nodes
  name             = "${var.guest_name_prefix}-all-nodes-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.guest_all_vcpu
  memory   = var.guest_all_memory
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  scsi_type = data.vsphere_virtual_machine.source_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.source_template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.source_template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
  }

  extra_config = {
    "guestinfo.userdata"          = data.cloudinit_config.all-nodes[count.index].rendered
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}

# see https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs
data "cloudinit_config" "etcd-nodes" {
  count         = var.count_etcd_nodes
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config.yml.tmpl", {
      rke_version    = "${var.rke_version}"
      guest_hostname = "${var.guest_name_prefix}-etcd-node-${count.index + 1}"
      guest_user     = "${var.guest_user}"
      guest_ssh_key  = "${var.guest_ssh_key}"
      docker_version = "${var.docker_version}"
    })
  }
}

resource "vsphere_virtual_machine" "etcd-nodes" {
  count            = var.count_etcd_nodes
  name             = "${var.guest_name_prefix}-etcd-node-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.guest_etcd_vcpu
  memory   = var.guest_etcd_memory
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  scsi_type = data.vsphere_virtual_machine.source_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.source_template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.source_template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
  }

  extra_config = {
    "guestinfo.userdata"          = data.cloudinit_config.etcd-nodes[count.index].rendered
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}

# see https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs
data "cloudinit_config" "controlplane-nodes" {
  count         = var.count_controlplane_nodes
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config.yml.tmpl", {
      rke_version    = "${var.rke_version}"
      guest_hostname = "${var.guest_name_prefix}-controlplane-node-${count.index + 1}"
      guest_user     = "${var.guest_user}"
      guest_ssh_key  = "${var.guest_ssh_key}"
      docker_version = "${var.docker_version}"
    })
  }
}

resource "vsphere_virtual_machine" "controlplane-nodes" {
  count            = var.count_controlplane_nodes
  name             = "${var.guest_name_prefix}-controlplane-node-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.guest_controlplane_vcpu
  memory   = var.guest_controlplane_memory
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  scsi_type = data.vsphere_virtual_machine.source_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.source_template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.source_template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
  }

  extra_config = {
    "guestinfo.userdata"          = data.cloudinit_config.controlplane-nodes[count.index].rendered
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}

# see https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs
data "cloudinit_config" "worker-nodes" {
  count         = var.count_worker_nodes
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config.yml.tmpl", {
      rke_version    = "${var.rke_version}"
      guest_hostname = "${var.guest_name_prefix}-worker-node-${count.index + 1}"
      guest_user     = "${var.guest_user}"
      guest_ssh_key  = "${var.guest_ssh_key}"
      docker_version = "${var.docker_version}"
    })
  }
}

resource "vsphere_virtual_machine" "worker-nodes" {
  count            = var.count_worker_nodes
  name             = "${var.guest_name_prefix}-worker-node-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder

  num_cpus = var.guest_worker_vcpu
  memory   = var.guest_worker_memory
  guest_id = data.vsphere_virtual_machine.source_template.guest_id

  scsi_type = data.vsphere_virtual_machine.source_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.source_template.network_interface_types[0]
  }
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.source_template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.source_template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.source_template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.source_template.id
  }

  extra_config = {
    "guestinfo.userdata"          = data.cloudinit_config.worker-nodes[count.index].rendered
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  lifecycle {
    ignore_changes = [annotation]
  }
}

locals {
  all_nodes = [
    for n in range(var.count_all_nodes) : templatefile("${path.module}/files/node.yml.tmpl", {
      public_ip = vsphere_virtual_machine.all-nodes[n].default_ip_address
      roles     = "[controlplane,worker,etcd]"
    })
  ]
}

locals {
  etcd_nodes = [
    for n in range(var.count_etcd_nodes) : templatefile("${path.module}/files/node.yml.tmpl", {
      public_ip = vsphere_virtual_machine.etcd-nodes[n].default_ip_address
      roles     = "[etcd]"
    })
  ]
}

locals {
  controlplane_nodes = [
    for n in range(var.count_controlplane_nodes) : templatefile("${path.module}/files/node.yml.tmpl", {
      public_ip = vsphere_virtual_machine.controlplane-nodes[n].default_ip_address
      roles     = "[controlplane]"
    })
  ]
}

locals {
  worker_nodes = [
    for n in range(var.count_worker_nodes) : templatefile("${path.module}/files/node.yml.tmpl", {
      public_ip = vsphere_virtual_machine.worker-nodes[n].default_ip_address
      roles     = "[worker]"
    })
  ]
}

resource "local_file" "rke-config" {

  content = templatefile("${path.module}/files/nodes.yml.tmpl", {
    nodes = chomp(
      join("", [
        join("", local.all_nodes),
        join("", local.etcd_nodes),
        join("", local.controlplane_nodes),
        join("", local.worker_nodes),
    ]))
  })
  filename = "${path.module}/cluster.yml"
}

output "all-nodes-nodes" {
  value = [for node in vsphere_virtual_machine.all-nodes : { name = node.name, ip = node.default_ip_address, user = var.guest_user }]
}

output "rke-etcd-nodes" {
  value = [for node in vsphere_virtual_machine.etcd-nodes : { name = node.name, ip = node.default_ip_address, user = var.guest_user }]
}

output "rke-controlplane-nodes" {
  value = [for node in vsphere_virtual_machine.controlplane-nodes : { name = node.name, ip = node.default_ip_address, user = var.guest_user }]
}

output "rke-worker-nodes" {
  value = [for node in vsphere_virtual_machine.worker-nodes : { name = node.name, ip = node.default_ip_address, user = var.guest_user }]
}