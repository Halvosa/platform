packer {
    required_plugins {
        qemu = {
            version = " >= 1.0.6 "
            source = "github.com/hashicorp/qemu"
        }
    }
}

variable "iso_file" {
    type = string
    default = "Fedora-Server-dvd-x86_64-37-1.7.iso"
}

source "qemu" "fedora37" {
  iso_url           = "file:/data/packer/${var.iso_file}"
  iso_checksum      = "sha256:0a4de5157af47b41a07a53726cd62ffabd04d5c1a4afece5ee7c7a84c1213e4f"

  output_directory  = "/data/packer/output/"

  ssh_username      = "packer"
  ssh_password      = "test123!"
  #ssh_pty           = true
  ssh_timeout       = "20m"

  cpus              = 1
  memory            = 2048
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  disk_size         = "10G"
  format            = "qcow2"
  accelerator       = "kvm"
  firmware          = "OVMF.fd"

  floppy_files      = ["/data/packer/build/kickstart/fedora36-ks.cfg"]

  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  headless          = true

}

build {
    name = "fedora37"

    source "source.qemu.fedora37" {
        #disable_vnc = true

        qemuargs = [
            [ "-kernel", "/data/packer/${var.iso_file}-extract/vmlinuz" ],
            [ "-initrd", "/data/packer/${var.iso_file}-extract/initrd.img" ],
            #[ "-append", "inst.ks=floppy:/fedora36-ks.cfg console=ttyS0" ],
            [ "-append", "console=ttyS0 rd.debug" ],
            [ "-serial", "file:/data/packer/install.log" ],
            [ "-nographic" ]
        ]

    }

    # provisioner "shell" {
    #     scripts = fileset(".", "scripts/{install,secure}.sh")
    # }

    # post-processor "shell-local" {
    #     inline = ["echo Hello World from ${source.type}.${source.name}"]
    # }
}