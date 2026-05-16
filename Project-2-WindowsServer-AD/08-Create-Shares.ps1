#requires -RunAsAdministrator
<#
.SYNOPSIS
    Configure DHCP server with scope and options
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$ScopeName      = "Lab-Scope"
$ScopeStart     = "192.168.10.100"
$ScopeEnd       = "192.168.10.200"
$SubnetMask     = "255.255.255.0"
$Router         = "192.168.10.1"
$DNSServer      = "192.168.10.2"
$DomainName     = "corp.faizi.ovh"
$LeaseDuration  = "8.00:00:00"
$InterfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1).Name

Write-Host "Configuring DHCP Server..." -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "[WHATIF] Would configure DHCP scope and options" -ForegroundColor Magenta
} else {
    $authorized = Get-DhcpServerInDC | Where-Object { $_.IPAddress -eq '192.168.10.2' }
    if (-not $authorized) {
        Add-DhcpServerInDC -IPAddress 192.168.10.2 -DnsName "SVR01-AD.corp.faizi.ovh"
        Write-Host "  DHCP server authorized in AD" -ForegroundColor Green
    }

    $scope = Get-DhcpServerv4Scope -ScopeId 192.168.10.0 -ErrorAction SilentlyContinue
    if (-not $scope) {
        Add-DhcpServerv4Scope `
            -Name $ScopeName `
            -StartRange $ScopeStart `
            -EndRange $ScopeEnd `
            -SubnetMask $SubnetMask `
            -LeaseDuration $LeaseDuration `
            -State Active
        Write-Host "  DHCP scope created: $ScopeStart - $ScopeEnd" -ForegroundColor Green
    } else {
        Write-Host "  DHCP scope already exists" -ForegroundColor Yellow
    }

    Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -OptionId 3 -Value $Router
    Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -OptionId 6 -Value $DNSServer
    Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -OptionId 15 -Value $DomainName

    Write-Host "  DHCP options configured (Router, DNS, Domain)" -ForegroundColor Green

    $reservation = Get-DhcpServerv4Reservation -ScopeId 192.168.10.0 -IPAddress 192.168.10.2 -ErrorAction SilentlyContinue
    if (-not $reservation) {
        $mac = (Get-NetAdapter | Select-Object -First 1).MacAddress -replace '-', ''
        Add-DhcpServerv4Reservation `
            -ScopeId 192.168.10.0 `
            -IPAddress 192.168.10.2 `
            -ClientId $mac `
            -Name "SVR01-AD" `
            -Description "Domain Controller"
        Write-Host "  Reservation added for server (192.168.10.2)" -ForegroundColor Green
    }

    Start-Service DHCPServer
    Set-Service DHCPServer -StartupType Automatic

    Write-Host "`nDHCP Configuration Summary:" -ForegroundColor Cyan
    Get-DhcpServerv4Scope | Select-Object ScopeId, Name, StartRange, EndRange, State | Format-Table

    Write-Host "DHCP configuration complete." -ForegroundColor Green
}
