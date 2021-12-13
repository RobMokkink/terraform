variable "rocky_nodes" {

  description="Create rocky nodes"
  type=list(object({
    name = string
    ip = string
  }))
  default = []
}

variable "rocky_img" {
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

variable "vcpu" {
  description = "virtual cpu's"
  type = number
  default = 2
}

variable "memory" {
  description = "amount of memory"
  type = number
  default = 2048
}

variable "extra_disk" {
  description = "size of extra disk(s)"
  type = number
  default = 53687091200
}
