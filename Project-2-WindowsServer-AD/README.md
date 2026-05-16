# FaiziIT Project 2 — Windows Server 2022 Automated Deployment

Complete unattended PowerShell deployment for Windows Server 2022 with Active Directory, DNS, DHCP, File/Print services, and Group Policy.

## Network Configuration

| Setting | Value |
|---------|-------|
| Domain | `corp.faizi.ovh` |
| NetBIOS | `CORP` |
| Server IP | `192.168.10.2` |
| Gateway | `192.168.10.1` |
| Subnet | `/24` |
| DNS | Points to itself after DC promotion |


## Repository Structure

```
faiziit-project2/
├── README.md
├── master-deploy.ps1          # Orchestrator script
├── Phase1-PreDC/              # Run before DC promotion
│   ├── 01-Set-Network.ps1
│   ├── 02-Install-Roles.ps1
│   └── 03-Promote-DC.ps1
├── Phase2-PostDC/             # Run after DC promotion & reboot
│   ├── 04-Configure-DNS.ps1
│   ├── 05-Configure-DHCP.ps1
│   ├── 06-Create-ADObjects.ps1
│   ├── 07-Configure-GPOs.ps1
│   └── 08-Create-Shares.ps1
└── data/
    └── users.csv              # User bulk import data
```

## Requirements

- Windows Server 2022 Standard/Datacenter (Evaluation OK)
- Static IP configured or DHCP from OPNsense
- Internet access for downloading scripts
- Minimum 4GB RAM, 2 vCPU, 60GB disk

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Execution policy blocks scripts | `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force` |
| Network download fails | Check DNS/gateway connectivity to GitHub |
| DC promotion fails | Verify DNS is installed first, check logs at `C:\Windows\Logs\DISM\dism.log` |

## Author

Ahmad Sajad Faizi — IT Portfolio Project 2026
