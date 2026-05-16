#requires -RunAsAdministrator
<#
.SYNOPSIS
    Create file shares with NTFS permissions and configure print server
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$SharesRoot = "C:\Shares"
$DomainName = "corp.faizi.ovh"

Write-Host "Creating file shares and configuring permissions..." -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "[WHATIF] Would create shares and set NTFS permissions" -ForegroundColor Magenta
} else {
    if (-not (Test-Path $SharesRoot)) {
        New-Item -Path $SharesRoot -ItemType Directory -Force | Out-Null
    }

    # ============================================
    # SHARE DEFINITIONS
    # ============================================
    $Shares = @(
        @{
            Name        = "Finance"
            Path        = "$SharesRoot\Finance"
            Group       = "GG_Finance"
            Description = "Finance Department Files"
        },
        @{
            Name        = "HR"
            Path        = "$SharesRoot\HR"
            Group       = "GG_HR"
            Description = "HR Department Files"
        },
        @{
            Name        = "IT"
            Path        = "$SharesRoot\IT"
            Group       = "GG_IT"
            Description = "IT Department Files"
        },
        @{
            Name        = "Marketing"
            Path        = "$SharesRoot\Marketing"
            Group       = "GG_Marketing"
            Description = "Marketing Department Files"
        },
        @{
            Name        = "Public"
            Path        = "$SharesRoot\Public"
            Group       = "Domain Users"
            Description = "Public shared files"
        }
    )

    foreach ($share in $Shares) {
        # Create folder
        if (-not (Test-Path $share.Path)) {
            New-Item -Path $share.Path -ItemType Directory -Force | Out-Null
            Write-Host "  Created folder: $($share.Path)" -ForegroundColor Green
        }

        # Set NTFS permissions
        $acl = Get-Acl $share.Path
        $acl.SetAccessRuleProtection($true, $false)
        Set-Acl $share.Path $acl

        # Re-get ACL after protection change
        $acl = Get-Acl $share.Path
        $acl.SetAccessRuleProtection($true, $false)

        # Clear existing rules
        $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) | Out-Null }

        # Add Administrators - Full Control
        $adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )
        $acl.AddAccessRule($adminRule)

        # Add Domain Admins - Full Control
        $domainAdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            "Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
        )
        $acl.AddAccessRule($domainAdminRule)

        # Add department group or Domain Users
        if ($share.Name -ne "Public") {
            $groupRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                $share.Group, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
            )
            $acl.AddAccessRule($groupRule)
        } else {
            $publicRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "Domain Users", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow"
            )
            $acl.AddAccessRule($publicRule)
        }

        Set-Acl $share.Path $acl
        Write-Host "  NTFS permissions set for: $($share.Name)" -ForegroundColor Green

        # Create SMB share
        $existingShare = Get-SmbShare -Name $share.Name -ErrorAction SilentlyContinue
        if (-not $existingShare) {
            New-SmbShare `
                -Name $share.Name `
                -Path $share.Path `
                -Description $share.Description `
                -FullAccess "Administrators","Domain Admins" `
                -ChangeAccess $share.Group
            Write-Host "  SMB share created: \\$env:COMPUTERNAME\$($share.Name)" -ForegroundColor Green
        } else {
            Write-Host "  SMB share exists: $($share.Name)" -ForegroundColor Yellow
        }
    }

    # ============================================
    # PRINT SERVER SETUP
    # ============================================
    Write-Host "`nConfiguring Print Server..." -ForegroundColor Cyan

    $printerName = "SharedPrinter"
    $existingPrinter = Get-Printer -Name $printerName -ErrorAction SilentlyContinue
    if (-not $existingPrinter) {
        Add-PrinterPort -Name "LPT2:" -ErrorAction SilentlyContinue
        Add-Printer `
            -Name $printerName `
            -DriverName "Microsoft IPP Class Driver" `
            -PortName "LPT2:" `
            -Shared:$true `
            -ShareName $printerName `
            -Published:$true
        Write-Host "  Printer created: $printerName" -ForegroundColor Green
    } else {
        Write-Host "  Printer exists: $printerName" -ForegroundColor Yellow
    }

    Set-PrintConfiguration -PrinterName $printerName -Shared $true

    Write-Host "`nShares Configuration Summary:" -ForegroundColor Cyan
    Get-SmbShare | Where-Object { $_.Name -in @("Finance","HR","IT","Marketing","Public") } |
        Select-Object Name, Path, Description | Format-Table

    Write-Host "File and Print services configuration complete." -ForegroundColor Green
}
