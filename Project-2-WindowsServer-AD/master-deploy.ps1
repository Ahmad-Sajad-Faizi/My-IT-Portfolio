#requires -RunAsAdministrator
<#
.SYNOPSIS
    Create and link Group Policy Objects
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$DomainName = "corp.faizi.ovh"
$DomainDN   = "DC=corp,DC=faizi,DC=ovh"

Write-Host "Configuring Group Policy Objects..." -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "[WHATIF] Would create and configure GPOs" -ForegroundColor Magenta
} else {
    Import-Module GroupPolicy

    # ============================================
    # 1. SECURITY BASELINE (Default Domain Policy)
    # ============================================
    Write-Host "`n  Configuring Security Baseline..." -ForegroundColor Yellow

    Set-ADDefaultDomainPasswordPolicy `
        -Identity $DomainName `
        -MinPasswordLength 12 `
        -ComplexityEnabled $true `
        -MaxPasswordAge (New-TimeSpan -Days 42) `
        -MinPasswordAge (New-TimeSpan -Days 1) `
        -PasswordHistoryCount 24

    # Account lockout via net accounts
    net accounts /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30

    Write-Host "    Password & lockout policy configured" -ForegroundColor Green

    # ============================================
    # 2. DESKTOP WALLPAPER GPO
    # ============================================
    $gpoName = "Desktop Wallpaper"
    $gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
    if (-not $gpo) {
        $gpo = New-GPO -Name $gpoName -Comment "Corporate desktop wallpaper"
        Write-Host "  Created GPO: $gpoName" -ForegroundColor Green
    } else {
        Write-Host "  GPO exists: $gpoName" -ForegroundColor Yellow
    }

    # Create wallpaper directory in SYSVOL
    $localWallpaperDir = "C:\Windows\SYSVOL\sysvol\$DomainName\wallpaper"
    if (-not (Test-Path $localWallpaperDir)) {
        New-Item -Path $localWallpaperDir -ItemType Directory -Force | Out-Null
    }

    $wallpaperUNC = "\\$DomainName\SYSVOL\$DomainName\wallpaper\corporate.jpg"

    Write-Host "    [NOTE] Place wallpaper image at: $localWallpaperDir\corporate.jpg" -ForegroundColor Yellow

    Set-GPRegistryValue `
        -Name $gpoName `
        -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
        -ValueName "Wallpaper" `
        -Type String `
        -Value $wallpaperUNC

    Set-GPRegistryValue `
        -Name $gpoName `
        -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
        -ValueName "WallpaperStyle" `
        -Type DWord `
        -Value 2

    New-GPLink -Name $gpoName -Target $DomainDN -ErrorAction SilentlyContinue | Out-Null
    Write-Host "    Linked to domain" -ForegroundColor Green

    # ============================================
    # 3. MAPPED DRIVES GPO (Logon Script via GPP)
    # ============================================
    $gpoName = "Mapped Drives"
    $gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
    if (-not $gpo) {
        $gpo = New-GPO -Name $gpoName -Comment "Network drive mappings"
        Write-Host "  Created GPO: $gpoName" -ForegroundColor Green
    } else {
        Write-Host "  GPO exists: $gpoName" -ForegroundColor Yellow
    }

    # Create logon script in NETLOGON
    $netlogonPath = "C:\Windows\SYSVOL\sysvol\$DomainName\scripts"
    if (-not (Test-Path $netlogonPath)) {
        New-Item -Path $netlogonPath -ItemType Directory -Force | Out-Null
    }

    $scriptContent = @'
@echo off
net use S: \SVR01-AD.corp.faizi.ovh\Finance /persistent:yes 2>nul
net use T: \SVR01-AD.corp.faizi.ovh\HR /persistent:yes 2>nul
net use U: \SVR01-AD.corp.faizi.ovh\IT /persistent:yes 2>nul
'@

    $scriptPath = "$netlogonPath\map-drives.bat"
    Set-Content -Path $scriptPath -Value $scriptContent -Encoding ASCII

    # Set logon script via registry in GPO
    Set-GPRegistryValue `
        -Name $gpoName `
        -Key "HKCU\Software\Policies\Microsoft\Windows\System\Scripts\Logon" `
        -ValueName "Script" `
        -Type String `
        -Value "\\$DomainName\NETLOGON\scripts\map-drives.bat"

    New-GPLink -Name $gpoName -Target $DomainDN -ErrorAction SilentlyContinue | Out-Null
    Write-Host "    Linked to domain" -ForegroundColor Green

    # ============================================
    # 4. AUDIT POLICY GPO
    # ============================================
    $gpoName = "Audit Policy"
    $gpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue
    if (-not $gpo) {
        $gpo = New-GPO -Name $gpoName -Comment "Security audit settings"
        Write-Host "  Created GPO: $gpoName" -ForegroundColor Green
    } else {
        Write-Host "  GPO exists: $gpoName" -ForegroundColor Yellow
    }

    Set-GPRegistryValue `
        -Name $gpoName `
        -Key "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Audit\AuditLogonEvents" `
        -ValueName "AuditLogonEvents" `
        -Type DWord `
        -Value 3

    New-GPLink -Name $gpoName -Target $DomainDN -ErrorAction SilentlyContinue | Out-Null
    Write-Host "    Linked to domain" -ForegroundColor Green

    # ============================================
    # 5. FORCE GPO UPDATE
    # ============================================
    Write-Host "`nForcing Group Policy update..." -ForegroundColor Yellow
    gpupdate /force

    Write-Host "`nGPO Configuration Summary:" -ForegroundColor Cyan
    Get-GPO -All | Where-Object { $_.DisplayName -in @("Desktop Wallpaper","Mapped Drives","Audit Policy") } | 
        Select-Object DisplayName, GpoStatus, CreationTime | Format-Table

    Write-Host "Group Policy configuration complete." -ForegroundColor Green
}
