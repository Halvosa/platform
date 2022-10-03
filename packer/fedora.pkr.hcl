packer {
    required_plugins {
        qemu = {
            version = '>= 1.0.6'
            source = "github.com/hashicorp/qemu"
        }
    }
}

source "qemu" "fedora36" {
  iso_url           = "https://download.fedoraproject.org/pub/fedora/linux/releases/36/Server/x86_64/iso/Fedora-Server-netinst-x86_64-36-1.5.iso"
  iso_checksum      = "sha256:5edaf708a52687b09f9810c2b6d2a3432edac1b18f4d8c908c0da6bde0379148"

  output_directory  = "output/"
  http_directory    = "http/"

  ssh_host          = "192.168.140.1"
  ssh_username      = "halvor"
  ssh_private_key_file = "~/.ssh/id_ed25519"
  #ssh_password      = ""
  ssh_pty           = true
  ssh_timeout       = "20m"

  #vm_name           = "packer-fedora36-builder"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  disk_size         = "5000M"
  format            = "qcow2"
  accelerator       = "kvm"
  firmware          = "OVMF.fd"

  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
}


# build {
#     name = "fedora36-gui"

#     source "source.qemu.fedora36" {
#         disable_vnc = false
#         headless    = false
#     }

#     provisioner "shell" {
#         scripts = fileset(".", "scripts/{install,secure}.sh")
#     }

#     post-processor "shell-local" {
#         inline = ["echo Hello World from ${source.type}.${source.name}"]
#     }
# }

build {
    name = "fedora36"

    source "source.qemu.fedora36" {
        disable_vnc = true
        headless    = true

        qemuargs = [
            [ "-append", "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/fedora36-ks.cfg" ]
        ]

    }

    # provisioner "shell" {
    #     scripts = fileset(".", "scripts/{install,secure}.sh")
    # }

    # post-processor "shell-local" {
    #     inline = ["echo Hello World from ${source.type}.${source.name}"]
    # }
}