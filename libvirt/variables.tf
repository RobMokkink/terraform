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
