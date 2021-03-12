ubuntu_img = "ubuntu-18.04-server-cloudimg-amd64.img"
netmask = 16
dnsdomain = "lab.local"
gateway = "10.0.0.1"
nameserver = "10.0.0.1"
libvirt_net = "lab"
libvirt_pool = "default"

k8s_masters = [
    {
      name = "master1"
      ip = "10.0.0.20"
    },
    {
      name = "master2"
      ip = "10.0.0.21"
    },
    {
      name = "master3"
      ip = "10.0.0.22"
    },
  ]

k8s_workers = [
    {
      name = "worker1"
      ip = "10.0.0.30"
    },
    {
      name = "worker2"
      ip = "10.0.0.31"
    },
    {
      name = "worker3"
      ip = "10.0.0.32"
    },
  ]
