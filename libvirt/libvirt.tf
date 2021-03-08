provider "libvirt" {
    uri = "qemu:///system"
}


resource "random_shuffle" "master" {
  input = ["locA", "locB"]
  result_count = length(var.k8s_masters)
}

resource "random_shuffle" "workers" {
  input = ["locA", "locB"]
  result_count = length(var.k8s_workers)
}

resource "libvirt_volume" "ubuntu18" {
  name = "${var.k8s_masters[count.index].name}.qcow2"
  count = length(var.k8s_masters)
  source = "file:///var/lib/libvirt/images/ubuntu18.04-template"
  pool = "default"
  format = "qcow2"
}

resource "libvirt_domain" "k8s_master_vms" {
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
  count = length(var.k8s_masters)
  name = var.k8s_masters[count.index].name
  memory = "2048"
  vcpu = 2
  description = random_shuffle.master.result[count.index]
  disk {
    volume_id = libvirt_volume.ubuntu18[count.index].id
  }
}

resource "libvirt_domain" "k8s_worker_vms" {
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
  count = length(var.k8s_workers)
  name = var.k8s_workers[count.index].name
  memory = "4096"
  vcpu = 2
  description = random_shuffle.workers.result[count.index]
  disk {
    volume_id = libvirt_volume.ubuntu18[count.index].id
  }
}
