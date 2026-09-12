#!/usr/bin/env python3

import json
import subprocess
import sys
from pathlib import Path
from ipaddress import ip_address

repo_root = Path(__file__).resolve().parents[2]

result = subprocess.run(
    ["tofu", "output", "-json", "rke2_nodes"],
    cwd=repo_root,
    text=True,
    capture_output=True,
)

if result.returncode != 0:
    print(result.stderr, file=sys.stderr)
    sys.exit(result.returncode)

nodes = json.loads(result.stdout)

servers = []
agents = []

for name, data in sorted(nodes.items()):
    addresses = []

    for interface_addresses in data.get("ipv4_addresses", []):
        for address in interface_addresses:
            try:
                parsed = ip_address(address)
            except ValueError:
                continue

            if parsed.version == 4 and not parsed.is_loopback:
                addresses.append(address)

    if len(addresses) != 1:
        raise RuntimeError(
            f"{name}: expected exactly one non-loopback IPv4 address, "
            f"found {addresses}"
        )

    host = f"{name} ansible_host={addresses[0]} ansible_user=automation"

    if name.startswith("rke2-cp"):
        servers.append(host)
    elif name.startswith("rke2-worker"):
        agents.append(host)
    else:
        raise RuntimeError(f"{name}: unable to determine RKE2 node role")

print("[rke2_servers]")
print("\n".join(servers))

print("\n[rke2_agents]")
print("\n".join(agents))

print("\n[rke2_cluster:children]")
print("rke2_servers")
print("rke2_agents")

print("\n[rke2_cluster:vars]")
print("ansible_python_interpreter=/usr/bin/python3")
