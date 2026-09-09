resource "proxmox_virtual_environment_vm" "test_vm01" {
  name      = "test-vm01"
  node_name = "proxmox-lab"
  vm_id     = 101

  clone {
    vm_id = 9000
    full  = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "automation"
      keys = [
        trimspace(file("/root/.ssh/id_rsa.pub"))
      ]
    }
  }

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  serial_device {
    device = "socket"
  }

  operating_system {
    type = "l26"
  }

  started = true
}
