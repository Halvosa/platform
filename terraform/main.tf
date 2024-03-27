terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_conn_uri
}

locals {
  sds_nodes = { for name, settings in var.machines : name => settings if settings.is_sds_node == true }
}


#-----------------------#
#	DISK		#
#-----------------------#

resource "libvirt_volume" "base" {
  name           = "base.qcow2"
  source	= var.base_image_path
}

resource "libvirt_volume" "overlay" {
  for_each = var.machines
  name           = "${each.key}.qcow2"
  base_volume_id = libvirt_volume.base.id
}

resource "libvirt_volume" "storage" {
  for_each = local.sds_nodes
  name           = "${each.key}-storage.qcow2"
  size 		 = var.sds_disk_size
}



#-----------------------#
#	NETWORK		#
#-----------------------#

resource "libvirt_network" "kube_network" {
  name = "kube"

  # mode can be: "nat" (default), "none", "route", "open", "bridge"
  mode = var.network_mode

  addresses = [var.kube_subnet]

  autostart = true

  domain = var.domain
  dns {
    enabled = var.dns_enabled
    local_only = var.dns_local_only

    dynamic "hosts" {
      for_each = var.machines
      content {
        hostname     = hosts.key
        ip      = hosts.value["ip"]
      }
    }

    dynamic "hosts" {
      for_each = var.dns_records
      content {
        hostname  = hosts.key
        ip        = hosts.value
      }
    }

  }
}


#-----------------------#
#	CLOUD INIT	#
#-----------------------#

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.machines
  name      = "cloudinit-${each.key}.iso"
  user_data = templatefile("${path.module}/cloud-init/user-data.tftpl", { name = each.key, settings = each.value })
  meta_data = templatefile("${path.module}/cloud-init/meta-data.tftpl", { name = each.key, settings = each.value })
  network_config = templatefile("${path.module}/cloud-init/network-config.tftpl", { name = each.key, settings = each.value })
}

#-----------------------#
#	MACHINES	#
#-----------------------#

resource "libvirt_domain" "node" {
  for_each = var.machines
  name     = each.key
  vcpu   = each.value["vcpu"]
  memory = each.value["memory"]


  kernel = var.kernel == null ? libvirt_volume.overlay[each.key].id : var.kernel
  #kernel = libvirt_volume.base.id
  firmware = var.ovmf_path
  cmdline = [{console = "tty1", console = "ttyS0"}]

  running   = each.value["running"]
  autostart = true

  network_interface {
    network_id     = libvirt_network.kube_network.id
    #addresses      = [each.value["ip"]]
  }
  
  disk {
    volume_id = libvirt_volume.overlay[each.key].id
  }

  dynamic "disk" {
    for_each = each.value.extra_disks
    content {
      volume_id = libvirt_volume.extra_disks[each.key]
    }
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
    source_path = "/dev/pts/0"
  }
}
