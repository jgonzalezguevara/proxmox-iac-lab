# Proxmox IaC Lab

Laboratorio de infraestructura reproducible sobre Proxmox VE usando OpenTofu.

## Estado validado

- Proxmox VE 9.2.11
- OpenTofu 1.12.6
- Provider `bpg/proxmox`
- Autenticación mediante API token dedicado
- Template Debian 13 cloud-init (`VMID 9000`)
- `qemu-guest-agent` integrado en la imagen
- Creación de VM mediante OpenTofu
- Cloud-init con usuario y SSH key
- DHCP sobre `vmbr0`
- Detección de IP mediante QEMU Guest Agent
- Reemplazo reproducible de VM
- Idempotencia validada con `tofu plan`

## Flujo

OpenTofu -> Proxmox API -> Template -> VM -> cloud-init -> QEMU Guest Agent

## Seguridad

Los secretos, variables sensibles y estados locales de OpenTofu no se versionan.
