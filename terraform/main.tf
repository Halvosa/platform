terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://halvor@192.168.140.1/system?keyfile=/root/.ssh/id_ed25519"
}

resource "libvirt_volume" "base" {
  name           = "base.qcow2"
  base_volume_id = libvirt_volume.opensuse_leap.id
}

resource "libvirt_domain" "terraform_test" {
  name   = "terraform_test"
  vcpu   = 1
  memory = 2048

  firmware = "/usr/share/qemu/ovmf-x86_64-code.bin"

  running   = true
  autostart = true

  disk {
    file = "/home/halvor/dev/cluster/large_files/Fedora-Server-dvd-x86_64-36-1.5.iso"
  }

  network_interface {
    network_id     = libvirt_network.infra.id
    addresses      = ["192.168.140.10"]
  }
}

output node_ip {
  value = libvirt_domain.terraform_test.network_interface[0].addresses[0]
}