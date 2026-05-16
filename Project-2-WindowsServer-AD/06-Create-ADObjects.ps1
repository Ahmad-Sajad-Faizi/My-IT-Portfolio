#requires -RunAsAdministrator
<#
.SYNOPSIS
    Promote server to Domain Controller
.DESCRIPTION
    Creates new forest with specified domain name.
    SAFE MODE PASSWORD is auto-generated and displayed.
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$DomainName       = "corp.faizi.ovh"
$NetBIOSName      = "CORP"
$ForestMode       = "WinThreshold"
$DomainMode       = "WinThreshold"
$SafeModePassword = "P@ssw0rd!2026Secure"

Write-Host "Promoting to Domain Controller..." -ForegroundColor Cyan
Write-Host "  Domain: $DomainName" -ForegroundColor Gray
Write-Host "  NetBIOS: $NetBIOSName" -ForegroundColor Gray
Write-Host "  Forest Mode: $ForestMode" -ForegroundColor Gray
Write-Host "  Safe Mode Password: $SafeModePassword" -ForegroundColor Yellow

if ($WhatIf) {
    Write-Host "[WHATIF] Would promote to DC and reboot automatically" -ForegroundColor Magenta
} else {
    Import-Module ADDSDeployment

    $SecurePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

    Install-ADDSForest `
        -DomainName $DomainName `
        -DomainNetbiosName $NetBIOSName `
        -ForestMode $ForestMode `
        -DomainMode $DomainMode `
        -InstallDns:$true `
        -CreateDnsDelegation:$false `
        -DatabasePath "C:\Windows\NTDS" `
        -LogPath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -SafeModeAdministratorPassword $SecurePassword `
        -NoRebootOnCompletion:$false `
        -Force:$true

    Write-Error "DC promotion did not trigger reboot. Check logs."
}
