# Project 5 — PowerShell & Bash Scripting

**Duration:** unknown | **Status:** Planned | **Cost:** €0

> Build a library of automation scripts for common IT administration tasks — user creation, system monitoring, log analysis, backups, and reporting.

---

## Objective

Automate repetitive IT tasks to save time and reduce human error. This project produces reusable, documented scripts for both Windows (PowerShell) and Linux (Bash) environments.

---

## Technologies

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat&logo=powershell&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)
![Microsoft Graph](https://img.shields.io/badge/Microsoft_Graph-0078D4?style=flat&logo=microsoft&logoColor=white)

---

## Scripts

### PowerShell (Windows)

| Script | Description | Status |
|--------|-------------|--------|
| `New-BulkADUsers.ps1` | Create AD users from CSV (auto OU, password, home folder, groups) | In progress |
| `Get-ADHealthReport.ps1` | Check replication, disk space, services — export HTML | In progress |
| `Get-M365LicenseReport.ps1` | Connect Graph API, export users + licenses, find unused | In progress |
| `Backup-AllGPOs.ps1` | Backup all GPOs with timestamp, keep last 10 | In progress |

### Bash (Linux)

| Script | Description | Status |
|--------|-------------|--------|
| `server-health.sh` | CPU/RAM/Disk check, alert >80%, log to file | In progress |
| `log-analyzer.sh` | Parse auth.log, top 10 failed login IPs, export CSV | In progress |
| `backup.sh` | Rsync /home and /etc, compress, keep 7 days, cron daily | In progress |

### Cross-Platform

| Script | Description | Status |
|--------|-------------|--------|
| `inventory.ps1/sh` | Detect OS, collect hostname/IP/MAC/software, export JSON | In progress |
| `network-scan.sh` | Ping sweep + port scan (22,80,443,3389), export HTML | In progress |

---

## Requirements Checklist

- [ ] All scripts tested and working
- [ ] Every function commented
- [ ] Error handling implemented
- [ ] README with usage instructions per script
- [ ] Example output screenshots
- [ ] Cron job configured for backup script

---

## Folder Structure

```
Project-5-Scripting/
├── README.md
├── powershell/
│   ├── New-BulkADUsers.ps1
│   ├── Get-ADHealthReport.ps1
│   ├── Get-M365LicenseReport.ps1
│   └── Backup-AllGPOs.ps1
├── bash/
│   ├── server-health.sh
│   ├── log-analyzer.sh
│   └── backup.sh
├── cross-platform/
│   ├── inventory.ps1
│   ├── inventory.sh
│   └── network-scan.sh
└── examples/
    └── (screenshot outputs)
```

---

## Usage Example

```powershell
# Create users from CSV
.\New-BulkADUsers.ps1 -CsvPath ".\users.csv" -LogPath ".\import.log"
```

```bash
# Run server health check
chmod +x server-health.sh
./server-health.sh

# Schedule daily backup at 2am
echo "0 2 * * * /opt/scripts/backup.sh" | crontab -
```

---

*Part of the [IT Portfolio 2026](../README.md) — Ahmad Sajad Faizi*
