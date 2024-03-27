variable "libvirt_conn_uri" {
	type = string
	default = "qemu:///system"
}

variable "base_image_path" {
	type = string
}

variable "network_mode" {
	type = string
        default = "route"
}

variable "kube_subnet" {
	type = string
}

variable "domain" {
	type = string
}

variable "dns_enabled" {
	type = bool
}

variable "dns_local_only" {
	type = bool
	default = true
}

variable "dns_records" {
  type = map(string)
  default = {}
}

variable "ovmf_path" {
	type = string
	default = "/usr/share/OVMF/OVMF_CODE.fd"
}

variable "kernel" {
	type = string
	default = null
}

variable "machines" {
  type = map(object({
	vcpu = optional(number, 1)
	memory = optional(number, 2048)
	ip = string
	running = bool
 }))
}
