module "test_vm01" {
  source = "./modules/proxmox-vm"

  name           = "test-vm01"
  node_name      = "proxmox-lab"
  vm_id          = 101
  clone_vm_id    = 9000
  cpu_cores      = 2
  memory_mb      = 2048
  disk_size_gb   = 20
  datastore_id   = "local-lvm"
  bridge         = "vmbr0"
  username       = "automation"
  ssh_public_key = trimspace(file("/root/.ssh/id_rsa.pub"))

  started = true
}

moved {
  from = proxmox_virtual_environment_vm.test_vm01
  to   = module.test_vm01.proxmox_virtual_environment_vm.this
}
