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

## Red privada del laboratorio

El host Proxmox mantiene dos bridges separados:

- `vmbr0`: red de gestión y salida externa.
  - Proxmox: `192.168.137.2/24`
  - Gateway: `192.168.137.1`
  - El gateway corresponde a Windows ICS y proporciona acceso a Internet.
- `vmbr1`: red privada del laboratorio.
  - Proxmox: `10.20.0.1/24`
  - Sin interfaz física asociada.
  - Destinada a cargas con direccionamiento estático, como el clúster RKE2.

### Routing

El forwarding IPv4 está habilitado de forma persistente mediante `/etc/sysctl.d/99-proxmox-lab-routing.conf`:

    net.ipv4.ip_forward=1

### NAT

La red privada `10.20.0.0/24` sale a Internet mediante NAT sobre `vmbr0`.

La regla persistente es gestionada por `/etc/systemd/system/proxmox-lab-nat.service` y aplica:

    10.20.0.0/24 -> MASQUERADE -> vmbr0

El servicio está habilitado para arrancar automáticamente con el host.

La persistencia completa de `vmbr1`, IPv4 forwarding, NAT y conectividad de las VMs fue validada mediante un reinicio completo del host Proxmox.

## Cloud-init DNS

El módulo `modules/proxmox-vm` permite configurar DNS explícitamente por VM mediante:

- `dns_servers`
- `dns_domain`

Esto permite usar direccionamiento IPv4 estático en la red privada sin depender del DHCP o DNS proporcionado por Windows ICS.
