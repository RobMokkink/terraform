provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "rocky" {
  name = "${var.rocky_nodes[count.index].name}.qcow2"
  count = length(var.rocky_nodes)
  base_volume_pool = var.libvirt_pool
  base_volume_name = var.rocky_img
}

resource "libvirt_volume" "rocky2" {
  name = "${var.rocky_nodes[count.index].name}2.qcow2"
  count = length(var.rocky_nodes)
  pool = var.libvirt_pool
  size = var.extra_disk
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = length(var.rocky_nodes)
  name = "${var.rocky_nodes[count.index].name}-commoninit.iso"
  pool = var.libvirt_pool
  user_data = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
}

data "template_file" "user_data" {
  count = length(var.rocky_nodes)
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.rocky_nodes[count.index].name
    fqdn = "${var.rocky_nodes[count.index].name}.${var.dnsdomain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
  count = length(var.rocky_nodes)
  vars = {
    domain = var.dnsdomain
    ip = var.rocky_nodes[count.index].ip
    netmask = var.netmask
    gateway = var.gateway
    nameserver = var.nameserver
  }
}

resource "libvirt_domain" "rocky_nodes" {
  count = length(var.rocky_nodes)
  name = var.rocky_nodes[count.index].name
  vcpu = var.vcpu
  memory = var.memory
  disk {
    volume_id = libvirt_volume.rocky[count.index].id
  }
  disk {
    volume_id = libvirt_volume.rocky2[count.index].id
  }
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  network_interface {
    network_name = var.libvirt_net
  }
}
