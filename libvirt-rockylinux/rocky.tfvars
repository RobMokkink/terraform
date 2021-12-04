rocky_img = "Rocky-8-GenericCloud-8.4-20210620.0.x86_64.qcow2"
netmask = 16
dnsdomain = "lab.local"
gateway = "10.0.0.1"
nameserver = "10.0.0.1"
libvirt_net = "lab"
libvirt_pool = "default"
rocky_nodes = [
    {
      name = "servera"
      ip = "10.0.0.100"
    },
    {
      name = "serverb"
      ip = "10.0.0.101"
    }
  ]
