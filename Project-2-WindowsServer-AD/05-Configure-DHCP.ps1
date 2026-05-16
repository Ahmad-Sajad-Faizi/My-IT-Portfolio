#requires -RunAsAdministrator
<#
.SYNOPSIS
    Install required Windows Server roles and features
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$Roles = @(
    "DNS",
    "AD-Domain-Services",
    "DHCP",
    "FS-FileServer",
    "Print-Services"
)

Write-Host "Installing required server roles..." -ForegroundColor Cyan

foreach ($role in $Roles) {{
    Write-Host "  Installing $role..." -ForegroundColor Yellow -NoNewline

    if ($WhatIf) {{
        Write-Host " [WHATIF]" -ForegroundColor Magenta
    }} else {{
        $result = Install-WindowsFeature -Name $role -IncludeManagementTools -IncludeAllSubFeature
        if ($result.Success) {{
            Write-Host " OK" -ForegroundColor Green
        }} else {{
            Write-Host " FAILED" -ForegroundColor Red
            throw "Failed to install $role"
        }}
    }}
}}

Write-Host "`nAll roles installed. Reboot NOT required yet." -ForegroundColor Green
