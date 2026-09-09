data "proxmox_virtual_environment_nodes" "all" {}

output "proxmox_nodes" {
  value = data.proxmox_virtual_environment_nodes.all.names
}
