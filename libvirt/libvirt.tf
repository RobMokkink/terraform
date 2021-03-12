provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "master_ubuntu" {
  name = "${var.k8s_masters[count.index].name}.qcow2"
  count = length(var.k8s_masters)
  base_volume_pool = var.libvirt_pool
  base_volume_name = var.ubuntu_img
}

resource "libvirt_volume" "worker_ubuntu" {
  name = "${var.k8s_workers[count.index].name}.qcow2"
  count = length(var.k8s_workers)
  base_volume_pool = var.libvirt_pool 
  base_volume_name = var.ubuntu_img
}

resource "libvirt_cloudinit_disk" "master_commoninit" {
  count = length(var.k8s_masters)
  name = "${var.k8s_masters[count.index].name}-commoninit.iso"
  pool = "default"
  user_data = data.template_file.master_user_data[count.index].rendered
  network_config = data.template_file.master_network_config[count.index].rendered
}

data "template_file" "master_user_data" {
  count = length(var.k8s_masters)
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.k8s_masters[count.index].name
    fqdn = "${var.k8s_masters[count.index].name}.${var.dnsdomain}"
  }
}

data "template_file" "master_network_config" {
  template = file("${path.module}/network_config.cfg")
  count = length(var.k8s_masters)
  vars = {
    domain = var.dnsdomain
    ip = var.k8s_masters[count.index].ip
    netmask = var.netmask
    gateway = var.gateway
    nameserver = var.nameserver
  }
}

resource "libvirt_cloudinit_disk" "worker_commoninit" {
  count = length(var.k8s_masters)
  name = "${var.k8s_workers[count.index].name}-commoninit.iso"
  pool = "default"
  user_data = data.template_file.worker_user_data[count.index].rendered
  network_config = data.template_file.worker_network_config[count.index].rendered
}

data "template_file" "worker_user_data" {
  count = length(var.k8s_masters)
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.k8s_workers[count.index].name
    fqdn = "${var.k8s_workers[count.index].name}.${var.dnsdomain}"
  }
}

data "template_file" "worker_network_config" {
  template = file("${path.module}/network_config.cfg")
  count = length(var.k8s_workers)
  vars = {
    domain = var.dnsdomain
    ip = var.k8s_workers[count.index].ip
    netmask = var.netmask
    gateway = var.gateway
    nameserver = var.nameserver
  }
}

resource "libvirt_domain" "k8s_master_vms" {
  count = length(var.k8s_masters)
  name = var.k8s_masters[count.index].name
  memory = "2048"
  vcpu = 2
  disk {
    volume_id = libvirt_volume.master_ubuntu[count.index].id
  }
  cloudinit = libvirt_cloudinit_disk.master_commoninit[count.index].id
  network_interface {
    network_name = var.libvirt_net
  }
}

resource "libvirt_domain" "k8s_worker_vms" {
  count = length(var.k8s_workers)
  name = var.k8s_workers[count.index].name
  memory = "4096"
  vcpu = 2
  disk {
    volume_id = libvirt_volume.worker_ubuntu[count.index].id
  }
  cloudinit = libvirt_cloudinit_disk.worker_commoninit[count.index].id
  network_interface {
    network_name = var.libvirt_net
  }
}
