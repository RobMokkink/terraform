provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu" {
  name = "${var.k8s_nodes[count.index].name}.qcow2"
  count = length(var.k8s_nodes)
  base_volume_pool = var.libvirt_pool
  base_volume_name = var.ubuntu_img
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = length(var.k8s_nodes)
  name = "${var.k8s_nodes[count.index].name}-commoninit.iso"
  pool = var.libvirt_pool
  user_data = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
}

data "template_file" "user_data" {
  count = length(var.k8s_nodes)
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.k8s_nodes[count.index].name
    fqdn = "${var.k8s_nodes[count.index].name}.${var.dnsdomain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
  count = length(var.k8s_nodes)
  vars = {
    domain = var.dnsdomain
    ip = var.k8s_nodes[count.index].ip
    netmask = var.netmask
    gateway = var.gateway
    nameserver = var.nameserver
  }
}

resource "libvirt_domain" "k8s_nodes" {
  count = length(var.k8s_nodes)
  name = var.k8s_nodes[count.index].name
  vcpu = (var.k8s_nodes[count.index].master == true ? var.master_cpu : var.worker_cpu)
  memory = (var.k8s_nodes[count.index].master == true ? var.master_memory : var.worker_memory)
  disk {
    volume_id = libvirt_volume.ubuntu[count.index].id
  }
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  network_interface {
    network_name = var.libvirt_net
  }

}
