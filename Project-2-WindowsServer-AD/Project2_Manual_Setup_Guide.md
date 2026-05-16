# Project 2: Windows Server 2022 Manual Setup Guide
## FaiziIT BV — Complete Walkthrough (No Scripts)

---

## Table of Contents
1. [Pre-Installation Checklist](#1-pre-installation-checklist)
2. [Step 1: Network Configuration](#2-step-1-network-configuration)
3. [Step 2: Install Server Roles](#3-step-2-install-server-roles)
4. [Step 3: Promote to Domain Controller](#4-step-3-promote-to-domain-controller)
5. [Step 4: Configure DNS](#5-step-4-configure-dns)
6. [Step 5: Configure DHCP](#6-step-5-configure-dhcp)
7. [Step 6: Create AD Structure](#7-step-6-create-active-directory-structure)
8. [Step 7: Configure Group Policy](#8-step-7-configure-group-policy)
9. [Step 8: File & Print Server](#9-step-8-file-and-print-server)
10. [Step 9: Client Configuration](#10-step-9-client-configuration)
11. [Verification Checklist](#11-verification-checklist)

---

## 1. Pre-Installation Checklist

### Environment Details
| Setting | Value |
|---------|-------|
| Server Name | SVR01-AD |
| Domain | corp.faizi.ovh |
| NetBIOS | CORP |
| Server IP | 192.168.10.2 |
| Gateway | 192.168.10.1 (OPNsense LAN) |
| Subnet | 255.255.255.0 |
| DNS | 192.168.10.2 (will point to itself) |

### Before You Start
- [ ] Windows Server 2022 installed and updated
- [ ] Connected to OPNsense LAN (vtnet1) — 192.168.10.0/24
- [ ] Server has internet access through OPNsense WAN
- [ ] Know the local Administrator password
- [ ] Proxmox snapshot ready (for rollback)

---

## 2. Step 1: Network Configuration

### 2.1 Rename the Server
```powershell
# Open PowerShell as Administrator
Rename-Computer -NewName "SVR01-AD" -Restart
```
**Wait for reboot, then log back in.**

### 2.2 Set Static IP Address
```powershell
# Check your network adapter name
Get-NetAdapter

# Set static IP (replace "Ethernet" with your adapter name if different)
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.10.2" -PrefixLength 24 -DefaultGateway "192.168.10.1"

# Set DNS to point to itself (loopback initially)
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "127.0.0.1"

# Disable IPv6 (optional, reduces complexity)
Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6

# Verify
ipconfig /all
```

### Expected Output
```
Ethernet adapter Ethernet:
   IPv4 Address. . . . . . . . . . . : 192.168.10.2
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . . : 192.168.10.1
   DNS Servers . . . . . . . . . . . : 127.0.0.1
```

---

## 3. Step 2: Install Server Roles

### 3.1 Install Required Roles via PowerShell
```powershell
# Install DNS Server
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Install Active Directory Domain Services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Install DHCP Server
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Install File Server
Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools

# Install Print Server
Install-WindowsFeature -Name Print-Services -IncludeManagementTools

# Verify all installed
Get-WindowsFeature | Where-Object {$_.Installed -eq $true} | Select-Object Name, DisplayName
```

### 3.2 Alternative: Using Server Manager GUI
1. Open **Server Manager** → **Manage** → **Add Roles and Features**
2. Click **Next** until you reach **Server Roles**
3. Check the following:
   - [x] Active Directory Domain Services
   - [x] DNS Server
   - [x] DHCP Server
   - [x] File and Storage Services → File Server
   - [x] Print and Document Services → Print Server
4. Click **Add Features** when prompted for dependencies
5. Click **Next** → **Next** → **Install**
6. Wait for installation to complete (do NOT reboot yet)

---

## 4. Step 3: Promote to Domain Controller

### 4.1 Using PowerShell (Recommended)
```powershell
# Import the ADDSDeployment module
Import-Module ADDSDeployment

# Define DSRM (Safe Mode) password
$DSRMPassword = ConvertTo-SecureString "P@ssw0rd!2026Secure" -AsPlainText -Force

# Promote to Domain Controller (creates new forest)
Install-ADDSForest `
    -DomainName "corp.faizi.ovh" `
    -DomainNetbiosName "CORP" `
    -ForestMode "WinThreshold" `      # Windows Server 2016
    -DomainMode "WinThreshold" `      # Windows Server 2016
    -InstallDns:$true `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $DSRMPassword `
    -NoRebootOnCompletion:$false `
    -Force:$true
```

### 4.2 Using Server Manager GUI
1. Open **Server Manager**
2. Click the **yellow notification flag** → **Promote this server to a domain controller**
3. **Deployment Configuration**:
   - Select **Add a new forest**
   - Root domain name: `corp.faizi.ovh`
   - Click **Next**
4. **Domain Controller Options**:
   - Forest functional level: **Windows Server 2016**
   - Domain functional level: **Windows Server 2016**
   - [x] Domain Name System (DNS) server
   - [x] Global Catalog (GC)
   - DSRM password: `P@ssw0rd!2026Secure`
   - Click **Next**
5. **DNS Options**: Click **Next** (ignore delegation warning)
6. **Additional Options**:
   - NetBIOS domain name: **CORP** (verify)
   - Click **Next**
7. **Paths**: Keep defaults (C:\Windows\NTDS, C:\Windows\SYSVOL)
8. **Review Options**: Click **Next**
9. **Prerequisites Check**: Wait for "All prerequisite checks passed successfully"
10. Click **Install**

**The server will reboot automatically. Wait for it.**

### 4.3 After Reboot
- Log in as `CORP\Administrator`
- Password: Your original Windows Server admin password (NOT the DSRM password)
- Verify: `whoami` should show `corp\administrator`

---

## 5. Step 4: Configure DNS

### 5.1 Open DNS Manager
```powershell
# Or press Win+R, type: dnsmgmt.msc
```

### 5.2 Configure Forwarders
1. In DNS Manager, right-click your server → **Properties**
2. Go to **Forwarders** tab
3. Click **Edit**
4. Add: `1.1.1.1` and `8.8.8.8`
5. Click **OK**

### 5.3 Verify DNS Zones
1. Expand **Forward Lookup Zones**
2. Verify `corp.faizi.ovh` exists
3. Verify `_msdcs.corp.faizi.ovh` exists
4. Expand **Reverse Lookup Zones**
5. If no reverse zone exists, create it:
   - Right-click **Reverse Lookup Zones** → **New Zone**
   - Select **Primary zone** → **Store in Active Directory**
   - Replication: **To all DNS servers in this forest**
   - Network ID: `192.168.10`
   - Dynamic updates: **Secure only**
   - Click **Next** → **Finish**

### 5.4 Verify with PowerShell
```powershell
# Check DNS zones
Get-DnsServerZone

# Test resolution
Resolve-DnsName corp.faizi.ovh
Resolve-DnsName SVR01-AD.corp.faizi.ovh
```

---

## 6. Step 5: Configure DHCP

### 6.1 Complete DHCP Post-Install
1. Open **Server Manager**
2. Click the **yellow notification flag** → **Complete DHCP configuration**
3. Click **Next** → **Commit**
4. Click **Close**

### 6.2 Create DHCP Scope
1. Open **DHCP Manager** (dhcpmgmt.msc)
2. Expand your server → **IPv4**
3. Right-click **IPv4** → **New Scope**
4. **Scope Name**: `Lab-Scope`
5. **IP Address Range**:
   - Start: `192.168.10.100`
   - End: `192.168.10.200`
   - Length: `24`
   - Subnet mask: `255.255.255.0`
6. **Exclusions**: Skip (or add .1-.99 if you want)
7. **Lease Duration**: `8 days`
8. **Configure Options**: **Yes**
9. **Router (Default Gateway)**: `192.168.10.1`
10. **Domain Name**: `corp.faizi.ovh`
11. **DNS Servers**: `192.168.10.2`
12. **WINS Servers**: Skip
13. **Activate Scope**: **Yes**
14. Click **Finish**

### 6.3 Authorize DHCP Server
1. In DHCP Manager, right-click your server → **Authorize**
2. Refresh (F5) until status shows green

### 6.4 Add Server Reservation
1. Expand **Scope [192.168.10.0]** → **Reservations**
2. Right-click → **New Reservation**
3. Name: `SVR01-AD`
4. IP: `192.168.10.2`
5. MAC Address: (Get from `Get-NetAdapter` in PowerShell)
6. Description: `Domain Controller`
7. Click **Add** → **Close**

### 6.5 Verify with PowerShell
```powershell
# Check DHCP scope
Get-DhcpServerv4Scope

# Check options
Get-DhcpServerv4OptionValue -ScopeId 192.168.10.0

# Start DHCP service
Start-Service DHCPServer
Set-Service DHCPServer -StartupType Automatic
```

---

## 7. Step 6: Create Active Directory Structure

### 7.1 Open Active Directory Users and Computers
```powershell
# Press Win+R, type: dsa.msc
```

### 7.2 Create Organizational Units (OUs)
Right-click `corp.faizi.ovh` → **New** → **Organizational Unit**

Create these OUs:
```
corp.faizi.ovh
├── Lab_Computers
│   ├── Finance
│   ├── HR
│   ├── IT
│   ├── Marketing
│   └── Computers
├── Groups
└── Service Accounts
```

**Note**: The original had a typo "Compters" — this is fixed to "Computers".

### 7.3 Create Security Groups
In **OU=Groups**, right-click → **New** → **Group**

| Group Name | Group Scope | Group Type | Description |
|------------|-------------|------------|-------------|
| GG_Finance | Global | Security | Finance Department |
| GG_HR | Global | Security | HR Department |
| GG_IT | Global | Security | IT Department |
| GG_Marketing | Global | Security | Marketing Department |
| GG_Sales | Global | Security | Sales Department |
| DL_All_Users | Global | Distribution | All Users |
| DL_IT_Team | Global | Distribution | IT Team |

### 7.4 Create User Accounts
In each department OU, right-click → **New** → **User**

| Full Name | User Logon Name | Department | Password |
|-----------|-----------------|------------|----------|
| Ahmad Faizi | AhmadFaizi | IT | IT@dmin2026! |
| John Smith | JohnSmith | Finance | Fin@nce2026! |
| Sarah Lee | SarahLee | HR | HR@dept2026! |
| Mike Brown | MikeBrown | Marketing | Mkt@2026!Pass |
| Emily Davis | EmilyDavis | Finance | Fin@nce2026! |
| David Wilson | DavidWilson | IT | IT@dmin2026! |
| Lisa Anderson | LisaAnderson | HR | HR@dept2026! |
| Robert Taylor | RobertTaylor | Marketing | Mkt@2026!Pass |
| Jennifer Martinez | JenniferMartinez | Sales | S@les2026!Pass |
| James Johnson | JamesJohnson | Sales | S@les2026!Pass |

**For each user:**
1. Fill first name, last name, full name
2. User logon name: `AhmadFaizi` (will be `AhmadFaizi@corp.faizi.ovh`)
3. Click **Next**
4. Password: (from table above)
5. Uncheck **User must change password at next logon**
6. Check **Password never expires** (for lab)
7. Click **Next** → **Finish**

### 7.5 Add Users to Groups
1. Double-click each user → **Member Of** tab → **Add**
2. Add users to their department groups:
   - AhmadFaizi → GG_IT, Domain Admins, DL_All_Users
   - JohnSmith → GG_Finance, DL_All_Users
   - SarahLee → GG_HR, DL_All_Users
   - MikeBrown → GG_Marketing, DL_All_Users
   - (etc. for all users)

### 7.6 Verify with PowerShell
```powershell
# List all users
Get-ADUser -Filter * -SearchBase "DC=corp,DC=faizi,DC=ovh" | Select-Object Name, SamAccountName, DistinguishedName

# List all groups
Get-ADGroup -Filter * -SearchBase "DC=corp,DC=faizi,DC=ovh" | Select-Object Name, GroupCategory

# List Domain Admins members
Get-ADGroupMember -Identity "Domain Admins" | Select-Object Name, SamAccountName
```

---

## 8. Step 7: Configure Group Policy

### 8.1 Open Group Policy Management
```powershell
# Press Win+R, type: gpmc.msc
```

### 8.2 Configure Default Domain Policy (Password & Account Lockout)
1. Expand **Forest: corp.faizi.ovh** → **Domains** → **corp.faizi.ovh**
2. Right-click **Default Domain Policy** → **Edit**
3. Navigate to: **Computer Configuration** → **Policies** → **Windows Settings** → **Security Settings** → **Account Policies**

**Password Policy:**
| Setting | Value |
|---------|-------|
| Enforce password history | 24 passwords remembered |
| Maximum password age | 42 days |
| Minimum password age | 1 day |
| Minimum password length | 12 characters |
| Password must meet complexity requirements | Enabled |

**Account Lockout Policy:**
| Setting | Value |
|---------|-------|
| Account lockout duration | 30 minutes |
| Account lockout threshold | 5 invalid logon attempts |
| Reset account lockout counter after | 30 minutes |

4. Close Group Policy Editor

### 8.3 Create Desktop Wallpaper GPO
1. In GPMC, right-click `corp.faizi.ovh` → **Create a GPO** → **New**
2. Name: `Desktop Wallpaper`
3. Right-click → **Edit**
4. Navigate: **User Configuration** → **Policies** → **Administrative Templates** → **Desktop** → **Desktop**
5. Double-click **Desktop Wallpaper**
6. Select **Enabled**
7. Wallpaper Name: `\\corp.faizi.ovh\SYSVOL\corp.faizi.ovh\wallpaper\corporate.jpg`
8. Wallpaper Style: **Fill**
9. Click **OK** → Close

**Note**: Create the wallpaper folder and place your image:
```powershell
New-Item -Path "C:\Windows\SYSVOL\sysvol\corp.faizi.ovh\wallpaper" -ItemType Directory -Force
# Copy your corporate.jpg to this folder
```

### 8.4 Create Mapped Drives GPO
1. Create new GPO: `Mapped Drives`
2. Right-click → **Edit**
3. Navigate: **User Configuration** → **Policies** → **Windows Settings** → **Script (Logon/Logoff)**
4. Double-click **Logon** → **Show Files**
5. Create a new file: `map-drives.bat`
6. Content:
```batch
@echo off
net use S: \\SVR01-AD.corp.faizi.ovh\Finance /persistent:yes
net use T: \\SVR01-AD.corp.faizi.ovh\HR /persistent:yes
net use U: \\SVR01-AD.corp.faizi.ovh\IT /persistent:yes
```
7. Save and close
8. In Logon properties, click **Add** → Browse → select `map-drives.bat` → **OK**
9. Close Group Policy Editor

### 8.5 Create Audit Policy GPO
1. Create new GPO: `Audit Policy`
2. Right-click → **Edit**
3. Navigate: **Computer Configuration** → **Policies** → **Windows Settings** → **Security Settings** → **Advanced Audit Policy Configuration** → **Audit Policies**
4. Configure:
   - **Logon/Logoff** → **Audit Logon**: Success, Failure
   - **Account Logon** → **Audit Account Logon**: Success, Failure
   - **Object Access** → **Audit File System**: Failure
   - **Policy Change** → **Audit Policy Change**: Success, Failure
5. Close Group Policy Editor

### 8.6 Force Group Policy Update
```powershell
gpupdate /force
```

---

## 9. Step 8: File and Print Server

### 9.1 Create Share Folders
```powershell
# Create directories
New-Item -Path "C:\Shares\Finance" -ItemType Directory -Force
New-Item -Path "C:\Shares\HR" -ItemType Directory -Force
New-Item -Path "C:\Shares\IT" -ItemType Directory -Force
New-Item -Path "C:\Shares\Marketing" -ItemType Directory -Force
New-Item -Path "C:\Shares\Public" -ItemType Directory -Force
```

### 9.2 Set NTFS Permissions (PowerShell)
```powershell
# Function to set permissions
function Set-SharePermissions($Path, $Group) {
    # Disable inheritance, remove all inherited
    $acl = Get-Acl $Path
    $acl.SetAccessRuleProtection($true, $false)
    Set-Acl $Path $acl

    # Clear existing rules
    $acl = Get-Acl $Path
    $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) | Out-Null }

    # Add Administrators - Full Control
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    # Add Domain Admins - Full Control
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    # Add Department Group - Modify
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Group, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    Set-Acl $Path $acl
}

# Apply to each share
Set-SharePermissions -Path "C:\Shares\Finance" -Group "GG_Finance"
Set-SharePermissions -Path "C:\Shares\HR" -Group "GG_HR"
Set-SharePermissions -Path "C:\Shares\IT" -Group "GG_IT"
Set-SharePermissions -Path "C:\Shares\Marketing" -Group "GG_Marketing"

# Public folder - Domain Users get Read
$acl = Get-Acl "C:\Shares\Public"
$acl.SetAccessRuleProtection($true, $false)
Set-Acl "C:\Shares\Public" $acl
$acl = Get-Acl "C:\Shares\Public"
$acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) | Out-Null }
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Users", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
Set-Acl "C:\Shares\Public" $acl
```

### 9.3 Create SMB Shares
```powershell
# Create shares
New-SmbShare -Name "Finance" -Path "C:\Shares\Finance" -Description "Finance Department Files" -FullAccess "Administrators","Domain Admins" -ChangeAccess "GG_Finance"
New-SmbShare -Name "HR" -Path "C:\Shares\HR" -Description "HR Department Files" -FullAccess "Administrators","Domain Admins" -ChangeAccess "GG_HR"
New-SmbShare -Name "IT" -Path "C:\Shares\IT" -Description "IT Department Files" -FullAccess "Administrators","Domain Admins" -ChangeAccess "GG_IT"
New-SmbShare -Name "Marketing" -Path "C:\Shares\Marketing" -Description "Marketing Department Files" -FullAccess "Administrators","Domain Admins" -ChangeAccess "GG_Marketing"
New-SmbShare -Name "Public" -Path "C:\Shares\Public" -Description "Public shared files" -FullAccess "Administrators" -ReadAccess "Domain Users"

# Verify
Get-SmbShare | Where-Object {$_.Name -in @("Finance","HR","IT","Marketing","Public")}
```

### 9.4 Configure Print Server
```powershell
# Add printer port
Add-PrinterPort -Name "LPT2:" -ErrorAction SilentlyContinue

# Add shared printer
Add-Printer -Name "SharedPrinter" -DriverName "Microsoft IPP Class Driver" -PortName "LPT2:" -Shared:$true -ShareName "SharedPrinter" -Published:$true

# Verify
Get-Printer -Name "SharedPrinter"
```

---

## 10. Step 9: Client Configuration

### 10.1 Windows 11 Client (LAB-WS-01)
1. Ensure client is on same network (192.168.10.0/24 or VLAN 20)
2. Set DNS to point to DC: `192.168.10.2`
3. Join domain:
   - Settings → System → About → Rename this PC (Advanced)
   - Click **Change** → Select **Domain**
   - Domain: `corp.faizi.ovh`
   - Credentials: `CORP\AhmadFaizi` (or any Domain Admin)
   - Restart when prompted

### 10.2 Verify Domain Join
```powershell
# On client, after reboot
whoami
# Should show: corp\username

# Verify GPO application
gpresult /r

# Verify drive mappings
net use
```

---

## 11. Verification Checklist

### Server Verification Commands
```powershell
# 1. Domain Controller status
Get-ADDomainController

# 2. Forest/Domain info
Get-ADDomain
Get-ADForest

# 3. FSMO roles
netdom query fsmo

# 4. DNS health
Get-DnsServerZone
Resolve-DnsName corp.faizi.ovh

# 5. DHCP status
Get-DhcpServerv4Scope
Get-DhcpServerv4OptionValue -ScopeId 192.168.10.0

# 6. AD replication (single DC, should show no errors)
repadmin /showrepl

# 7. SYSVOL share
Get-SmbShare | Where-Object {$_.Name -eq "SYSVOL"}

# 8. Full diagnostics
dcdiag /q
```

### Expected Results
| Check | Expected Output |
|-------|----------------|
| `Get-ADDomainController` | Shows SVR01-AD as DC |
| `netdom query fsmo` | All 5 roles on SVR01-AD |
| `dcdiag /q` | No errors or warnings |
| `Get-DnsServerZone` | corp.faizi.ovh and _msdcs zones |
| `Get-DhcpServerv4Scope` | Lab-Scope active |
| `Get-ADUser -Filter *` | 10 users listed |
| `Get-ADGroup -Filter *` | 7+ groups listed |
| `Get-SmbShare` | Finance, HR, IT, Marketing, Public |

---

## Troubleshooting Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| DNS resolution fails | DNS not installed or configured | Verify DNS service running, check forwarders |
| DC promotion fails | DNS not installed first | Install DNS role before AD DS |
| DHCP won't start | Not authorized | Right-click server in DHCP Manager → Authorize |
| GPO not applying | Wrong link or permissions | Run `gpresult /r` on client, check GPO link |
| Cannot join domain | DNS or network issue | Verify client DNS points to 192.168.10.2 |
| Shares not accessible | NTFS permissions | Verify group membership and NTFS ACLs |

---

## Next Steps (Optional)

### Azure AD Connect (Project 2 Final Step)
1. Download Azure AD Connect from Microsoft
2. Install on SVR01-AD
3. Configure Express Settings
4. Authenticate with Global Admin (M365 tenant)
5. Sync users to Azure AD

**Note**: Use a fresh M365 developer tenant to avoid the corruption issue from your previous attempt.

---

**Document Version**: 2.0  
**Date**: May 16, 2026  
**Author**: Ahmad Sajad Faizi  
**Domain**: corp.faizi.ovh  
**Server**: SVR01-AD (192.168.10.2)
