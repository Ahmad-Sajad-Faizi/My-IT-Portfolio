#requires -RunAsAdministrator
<#
.SYNOPSIS
    Master deployment orchestrator for FaiziIT Project 2
.DESCRIPTION
    Downloads and executes all Phase 1 (pre-DC) or Phase 2 (post-DC) scripts
    from GitHub repository.
.PARAMETER Phase1
    Run pre-domain-controller promotion scripts
.PARAMETER Phase2
    Run post-domain-controller configuration scripts
.PARAMETER WhatIf
    Show what would be executed without making changes
.EXAMPLE
    .\master-deploy.ps1 -Phase1
    .\master-deploy.ps1 -Phase2
#>

param(
    [switch]$Phase1,
    [switch]$Phase2,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"
$BaseUrl = "https://raw.githubusercontent.com/Ahmad-Sajad-Faizi/faiziit-project2/main"

function Write-Header($text) {
    Write-Host "`n=== $text ===" -ForegroundColor Cyan
}

function Get-Script($Path) {
    $fileName = [System.IO.Path]::GetFileName($Path)
    $localDir = "C:\scripts"
    $localPath = "$localDir\$fileName"

    if (-not (Test-Path $localDir)) {
        New-Item -Path $localDir -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $localPath)) {
        Write-Host "Downloading $fileName..." -ForegroundColor Yellow
        try {
            Invoke-WebRequest -Uri "$BaseUrl/$Path" -OutFile $localPath -UseBasicParsing
            Write-Host "Downloaded successfully." -ForegroundColor Green
        } catch {
            Write-Error "Failed to download $fileName from $BaseUrl/$Path. Error: $_"
        }
    } else {
        Write-Host "$fileName already exists locally." -ForegroundColor Green
    }
    return $localPath
}

function Invoke-Script($Path, $WhatIf) {
    $localPath = Get-Script -Path $Path
    if ($WhatIf) {
        Write-Host "[WHATIF] Would execute: $localPath" -ForegroundColor Magenta
    } else {
        Write-Header "Executing $([System.IO.Path]::GetFileName($Path))"
        & $localPath
    }
}

# ============================================
# PHASE 1: Pre-Domain Controller
# ============================================
if ($Phase1) {
    Write-Header "PHASE 1: Pre-Domain Controller Configuration"

    Invoke-Script -Path "Phase1-PreDC/01-Set-Network.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase1-PreDC/02-Install-Roles.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase1-PreDC/03-Promote-DC.ps1" -WhatIf:$WhatIf

    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host "PHASE 1 COMPLETE. REBOOT REQUIRED." -ForegroundColor Green
    Write-Host "After reboot, log in as CORP\Administrator" -ForegroundColor Green
    Write-Host "Then run: C:\scripts\master-deploy.ps1 -Phase2" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Green
}

# ============================================
# PHASE 2: Post-Domain Controller
# ============================================
if ($Phase2) {
    Write-Header "PHASE 2: Post-Domain Controller Configuration"

    Invoke-Script -Path "Phase2-PostDC/04-Configure-DNS.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase2-PostDC/05-Configure-DHCP.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase2-PostDC/06-Create-ADObjects.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase2-PostDC/07-Configure-GPOs.ps1" -WhatIf:$WhatIf
    Invoke-Script -Path "Phase2-PostDC/08-Create-Shares.ps1" -WhatIf:$WhatIf

    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host "PHASE 2 COMPLETE. ALL SERVICES CONFIGURED." -ForegroundColor Green
    Write-Host "Run 'dcdiag /q' to verify domain health." -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Green
}

if (-not $Phase1 -and -not $Phase2) {
    Write-Host "Usage: .\master-deploy.ps1 -Phase1  # Before DC promotion" -ForegroundColor Yellow
    Write-Host "       .\master-deploy.ps1 -Phase2  # After DC promotion & reboot" -ForegroundColor Yellow
}
