provider "libvirt" {
    uri = "qemu:///system"
}


resource "random_shuffle" "master" {
  input = ["locA", "locB"]
  result_count = length(var.k8s_masters)
}

resource "random_shuffle" "worker" {
  input = ["locA", "locB"]
  result_count = length(var.k8s_workers)
}

resource "libvirt_volume" "master_ubuntu18" {
  name = "${var.k8s_masters[count.index].name}.qcow2"
  count = length(var.k8s_masters)
  base_volume_pool = "default"
  base_volume_name = "ubuntu18.04-template"
}

resource "libvirt_volume" "worker_ubuntu18" {
  name = "${var.k8s_workers[count.index].name}.qcow2"
  count = length(var.k8s_workers)
  base_volume_pool = "default"
  base_volume_name = "ubuntu18.04-template"
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
    volume_id = libvirt_volume.master_ubuntu18[count.index].id
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
  description = random_shuffle.worker.result[count.index]
  disk {
    volume_id = libvirt_volume.worker_ubuntu18[count.index].id
  }
}
