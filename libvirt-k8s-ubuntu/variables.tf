variable "k8s_nodes" {

  description="Create k8s nodes"
  type=list(object({
    name = string
    ip = string
    master = bool
  }))
  default = []
}

variable "ubuntu_img" {
  description="Disk image to use"
  type=string
}

variable "libvirt_net" {
  description = "libvirt network"
  type = string
}

variable "libvirt_pool" {
  description = "libvirt storage pool"
  type = string
}

variable "netmask" {
  description = "subnetmask"
  type = number
}

variable "dnsdomain" {
  description = "DNS domain"
  type = string
}

variable "gateway" {
  description = "gateway address"
  type = string
}

variable "nameserver" {
  description = "nameserver address"
  type = string
}

variable "master_cpu" {
  description = "master cpu count"
  type = number
}

variable "master_memory" {
  description = "master memory"
  type = number
}

variable "worker_cpu" {
  description = "worker cpu count"
  type = number
}

variable "worker_memory" {
  description = "worker memory"
  type = number
}

