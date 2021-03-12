variable "k8s_masters" {

  description="Create master k8s nodes"
  type=list(object({
    name = string
    ip = string
  }))
  default = []
}

variable "k8s_workers" {

  description="Create worker k8s nodes"
  type=list(object({
    name = string
    ip = string
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
