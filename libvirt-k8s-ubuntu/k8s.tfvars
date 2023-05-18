ubuntu_img = "ubuntu-20.04-server-cloudimg-amd64.img"
netmask = 16
dnsdomain = "lab.local"
gateway = "10.0.0.1"
nameserver = "10.0.0.1"
libvirt_net = "lab"
libvirt_pool = "default"
master_cpu = 2
master_memory = 2048
worker_cpu = 2
worker_memory = 4096

k8s_nodes = [
    {
      name = "master1"
      ip = "10.0.0.20"
      master = true
    },
    {
      name = "master2"
      ip = "10.0.0.21"
      master = true
    },
    {
      name = "master3"
      ip = "10.0.0.22"
      master = true
    },
    {
      name = "worker1"
      ip = "10.0.0.30"
      master = false
    },
    {
      name = "worker2"
      ip = "10.0.0.31"
      master = false
    },
    {
      name = "worker3"
      ip = "10.0.0.32"
      master = false
    }
  ]
