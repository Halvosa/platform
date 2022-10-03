terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://halvor@192.168.140.1/system?keyfile=/root/.ssh/id_ed25519"
  #uri = "qemu:///system"
}

resource "libvirt_domain" "terraform_test" {
  name   = "terraform_test"
  vcpu   = 1
  memory = 1024

  running   = true
  autostart = true

  disk {
    file = "/home/halvor/dev/cluster/large_files/Fedora-Server-dvd-x86_64-36-1.5.iso"
  }

  network_interface {
    network_name = "cluster"
    hostname     = "master-1.cluster.halvorsaether.com"
    addresses    = ["192.168.140.10"]
  }
}

output node_ip {
  value = libvirt_domain.terraform_test.network_interface[0].addresses[0]
}