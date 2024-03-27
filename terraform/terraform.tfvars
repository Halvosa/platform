#libvirt_conn_uri = "qemu+ssh://halvor@192.168.140.1/system?keyfile=/root/.ssh/id_ed25519"
base_image_path = "/data/qcow2/golden-image-v0.3.qcow2"
kube_subnet = "192.168.140.0/24"
network_mode = "nat"
domain = "execnop.com"
dns_enabled = true
dns_local_only = false
#kernel = "/data/iso/fedora39.iso-extract/vmlinuz"

machines = {
  "km-1.execnop.com" = {
    running = true
    vcpu = 2
    memory = 4096
    ip = "192.168.140.10"  
  },
#  "km-2.execnop.com" = {
#    running = true
#    vcpu = 2
#    memory = 4096
#    ip = "192.168.140.11"  
#  },
  "kw-1.execnop.com" = {
    running = true
    vcpu = 2
    memory = 4096
    ip = "192.168.140.20"  
  }
  "kw-2.execnop.com" = {
    running = true
    vcpu = 2
    memory = 4096
    ip = "192.168.140.21"  
  },
  "kw-3.execnop.com" = {
    running = true
    vcpu = 2
    memory = 4096
    ip = "192.168.140.22"  
  }
}

dns_records = {
  "api.execnop.com" = "192.168.140.10"
}
