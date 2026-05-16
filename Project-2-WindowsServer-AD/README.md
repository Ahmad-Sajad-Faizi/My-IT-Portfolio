# Project 2 — Windows Server & Active Directory

**Duration:** unknown | **Status:** Planned | **Cost:** €0

> On-premises domain setup with Azure AD Connect for hybrid identity. A KMO (SME) in Antwerp needs local file sharing and print services while also using Microsoft 365 in the cloud.

---

## Objective

Build a complete on-premises Windows Server infrastructure and synchronise it with Azure AD to create a hybrid identity environment — one of the most common setups in Belgian SMEs.

---

## Architecture

```
Proxmox Hypervisor (i5-7500 / 8GB RAM / 1TB HDD)
│
├── VLAN 100 — Servers (192.168.10.0/24)
│   └── Windows Server 2022 VM
│       ├── AD DS — faiziit.local
│       ├── DNS Server
│       ├── DHCP Server
│       ├── File Server (Finance, HR, IT$, Public)
│       └── Print Server
│
├── VLAN 200 — Clients (192.168.20.0/24)
│   ├── Windows 11 Client 1
│   └── Windows 11 Client 2
│
└── Azure AD Connect (Hybrid Identity)
    ├── Password Hash Sync (PHS)
    ├── Seamless SSO
    └── Hybrid Azure AD Join
```

---

## Technologies

![Windows Server](https://img.shields.io/badge/Windows_Server_2022-0078D6?style=flat&logo=windows&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active_Directory-0078D4?style=flat&logo=microsoft&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=flat&logo=proxmox&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat&logo=powershell&logoColor=white)

---

## Requirements Checklist

### A. Proxmox Infrastructure
- [ ] Windows Server 2022 Eval VM (2 vCPU, 4GB RAM, 100GB disk)
- [ ] 2x Windows 11 Client VMs
- [ ] VLANs configured (10 Servers, 20 Clients, 30 Management)
- [ ] Snapshots at each milestone

### B. Active Directory Domain Services
- [ ] Domain promoted: faizi-it.local
- [ ] OU structure created (Computers, Users, Groups)
- [ ] 15+ users created via PowerShell bulk import
- [ ] Security groups (GG_Finance, GG_HR, GG_IT, GG_Sales)

### C. Core Services
- [ ] DNS (forward/reverse lookup zones, forwarders)
- [ ] DHCP (scope 192.168.10.100-200, reservations)
- [ ] File Server (shares with NTFS + share permissions)
- [ ] Print Server (2 printers, GPO deployment)

### D. Group Policy
- [ ] Password policy (min 12 chars, complexity on)
- [ ] Desktop wallpaper + mapped drives
- [ ] Windows Update policy
- [ ] Account lockout (5 attempts, 30 min)
- [ ] Chrome deployment via MSI

### E. Azure AD Connect
- [ ] Password Hash Synchronisation configured
- [ ] Seamless SSO enabled
- [ ] Filter rules (only sync OU=Users)
- [ ] Hybrid Azure AD Join for Windows 11 clients

---

## Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | Network diagram (Proxmox topology + VLANs) | In progress |
| 2 | AD structure diagram (OU hierarchy + GPO links) | In progress |
| 3 | PowerShell scripts (user creation, GPO backup) | In progress |
| 4 | Security audit (who has access to what) | In progress |
| 5 | Troubleshooting guide (AD replication, DNS, sync) | In progress |

---

## Folder Structure

```
Project-2-WindowsServer-AD/
├── README.md
├── setup-guide.md
├── troubleshooting.md
├── scripts/
│   ├── bulk-user-creation.ps1
│   └── gpo-backup.ps1
└── diagrams/
    ├── network-diagram.png
    └── ad-structure.png
```

---

## Resources

- [Windows Server 2022 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022)
- [Azure AD Connect Download](https://www.microsoft.com/en-us/download/details.aspx?id=47594)
- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [AD DS Documentation](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)

---

*Part of the [IT Portfolio 2026](../README.md) — Ahmad Sajad Faizi*
