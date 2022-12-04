packer {
    required_plugins {
        libvirt = {
            version = " >= 0.3.4 "
            source = "github.com/thomasklein94/libvirt"
        }
    }
}

 # firmware          = "OVMF.fd"

source "libvirt" "cd" {

    libvirt_uri = "qemu+ssh://halvor@192.168.140.1/system?keyfile=/root/.ssh/id_ed25519"

    domain_type = "kvm"

    memory = 4096
    vcpu    = 2

    network_interface {
        type    = "managed"
        network = "default"
        model = "virtio"
    }

    volume {
        alias = "artifact"

        pool = "default"
        name = "fedora36-base"

        capacity   = "20G"

        source {
            type   = "external"
            checksum = "sha256:5edaf708a52687b09f9810c2b6d2a3432edac1b18f4d8c908c0da6bde0379148"
            urls = ["https://download.fedoraproject.org/pub/fedora/linux/releases/36/Server/x86_64/iso/Fedora-Server-netinst-x86_64-36-1.5.iso"]
        }

        bus        = "virtio"
        target_dev = "vda"
        format      = "qcow2"
    }

    boot_devices = ["hd"]
}


build {
    name = "fedora36"

    source "source.libvirt.fedora36" {


    }

    # provisioner "shell" {
    #     scripts = fileset(".", "scripts/{install,secure}.sh")
    # }

    # post-processor "shell-local" {
    #     inline = ["echo Hello World from ${source.type}.${source.name}"]
    # }
}