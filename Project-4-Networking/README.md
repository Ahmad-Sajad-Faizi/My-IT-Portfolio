# Project 4 — Networking Fundamentals

**Duration:** unknown | **Status:**  Planned | **Cost:** €0

> Design, build, and secure a full company network using VLANs, pfSense/OPNsense, firewall rules, VPN, and traffic analysis with Wireshark — all virtualised in Proxmox.

---

## Objective

Design a robust network for "Faizi-IT BV" that combines VLANs, routing, DHCP, DNS, and security. Covers both conceptual understanding and practical implementation.

---

## Network Architecture

```
Internet
    │
  pfSense/OPNsense (Router + Firewall)
    │
    ├── VLAN 100 — Servers      192.168.10.0/24
    ├── VLAN 200 — Clients      192.168.20.0/24
    ├── VLAN 300 — Management   192.168.30.0/24
    ├── VLAN 400 — Guest        192.168.40.0/24
    └── VLAN 500 — IoT          192.168.50.0/24
```

---

## Technologies

![pfSense](https://img.shields.io/badge/pfSense-212121?style=flat&logo=pfsense&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=flat&logo=proxmox&logoColor=white)
![Wireshark](https://img.shields.io/badge/Wireshark-1679A7?style=flat&logo=wireshark&logoColor=white)
![OpenVPN](https://img.shields.io/badge/OpenVPN-EA7E20?style=flat&logo=openvpn&logoColor=white)

---

## Requirements Checklist

### A. Network Design
- [ ] IP schema with VLSM subnetting
- [ ] 5 VLANs designed and documented

### B. Proxmox Network Configuration
- [ ] Linux bridges per VLAN
- [ ] pfSense/OPNsense VM as router/firewall

### C. pfSense/OPNsense
- [ ] Interfaces configured per VLAN
- [ ] DHCP server per VLAN
- [ ] Firewall rules (Clients→Internet ALLOW, Guest→LAN DENY, IoT isolated)
- [ ] NAT port forwarding
- [ ] VPN server (OpenVPN or WireGuard)

### D. Monitoring & Analysis
- [ ] Wireshark: DHCP DORA, DNS query, TCP 3-way handshake, ARP
- [ ] Network scan with nmap
- [ ] Bandwidth test with iperf3

---

## Firewall Rule Matrix

| Source | Destination | Action | Ports |
|--------|-------------|--------|-------|
| Clients | Internet | ALLOW | Any |
| Clients | Servers | ALLOW | 80, 443, 3389 |
| Clients | Management | DENY | Any |
| Guest | Internet | ALLOW | Any |
| Guest | LAN | DENY | Any |
| IoT | Internet | ALLOW | Any |
| IoT | LAN | DENY | Any |

---

## Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | Network diagram L2+L3 | In progress |
| 2 | Full IP schema table | In progress |
| 3 | Firewall rule matrix | In progress |
| 4 | Troubleshooting cheat sheet | In progress |
| 5 | Wireshark analysis (3 captures) | In progress |

---

*Part of the [IT Portfolio 2026](../README.md) — Ahmad Sajad Faizi*
