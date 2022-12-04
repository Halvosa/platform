packer {
    required_plugins {
        qemu = {
            version = " >= 1.0.6 "
            source = "github.com/hashicorp/qemu"
        }
    }
}

source "qemu" "fedora36" {
  iso_url           = "file:/data/packer/Fedora-Server-dvd-x86_64-36-1.5.iso"
  iso_checksum      = "sha256:5edaf708a52687b09f9810c2b6d2a3432edac1b18f4d8c908c0da6bde0379148"

  output_directory  = "/data/packer/output/"
  #http_directory    = "http/"

  ssh_host          = "192.168.140.5"
  ssh_username      = "root"
  ssh_private_key_file = "/root/.ssh/id_ed25519"
  #ssh_password      = ""
  #ssh_pty           = true
  ssh_timeout       = "20m"

  #vm_name           = "packer-fedora36-builder"
  cpus              = 1
  memory            = 1024
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  disk_size         = "10G"
  format            = "qcow2"
  accelerator       = "kvm"
  #firmware          = "OVMF.fd"

  floppy_files      = ["../packer/kickstart/fedora36-ks.cfg"]

  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  headless          = true

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
        #disable_vnc = true

        qemuargs = [
            [ "-kernel", "/data/packer/Fedora-Server-dvd-x86_64-36-1.5.iso-extract/vmlinuz" ],
            [ "-initrd", "/data/packer/Fedora-Server-dvd-x86_64-36-1.5.iso-extract/initrd.img" ],
            [ "-append", "ks=floppy:/fedora36-ks.cfg" ],
            [ "-nographics" ]
        ]

    }

    # provisioner "shell" {
    #     scripts = fileset(".", "scripts/{install,secure}.sh")
    # }

    # post-processor "shell-local" {
    #     inline = ["echo Hello World from ${source.type}.${source.name}"]
    # }
}