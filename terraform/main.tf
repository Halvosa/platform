terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  #uri = "qemu+ssh://root@192.168.140.1/system"
  uri = "qemu:///system"
}

resource "libvirt_domain" "terraform_test" {
  name = "terraform_test"
  vcpu = 1
  memory = 1024

  running = true
  autostart = true

  disk {
    file = "../large_files/fedora-coreos-36.20220716.3.1-live.x86_64.iso"
  }

  network_interface {
    network_name   = "cluster"
    hostname       = "master-1.cluster.halvorsaether.com"
    addresses      = ["192.168.140.10"]
  }
}