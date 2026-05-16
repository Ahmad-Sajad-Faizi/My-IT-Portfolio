#requires -RunAsAdministrator
<#
.SYNOPSIS
    Configure static IP, DNS, and network settings
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$InterfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1).Name
$IPAddress      = "192.168.10.2"
$PrefixLength   = 24
$DefaultGateway = "192.168.10.1"
$DNSServer      = "192.168.10.2"

Write-Host "Configuring network on interface: $InterfaceAlias" -ForegroundColor Cyan
Write-Host "  IP: $IPAddress/$PrefixLength" -ForegroundColor Gray
Write-Host "  Gateway: $DefaultGateway" -ForegroundColor Gray
Write-Host "  DNS: $DNSServer" -ForegroundColor Gray

if ($WhatIf) {
    Write-Host "[WHATIF] Would configure static IP settings" -ForegroundColor Magenta
} else {
    $existingIP = Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue
    if ($existingIP) {
        Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -Confirm:$false -ErrorAction SilentlyContinue
    }

    New-NetIPAddress `
        -InterfaceAlias $InterfaceAlias `
        -IPAddress $IPAddress `
        -PrefixLength $PrefixLength `
        -DefaultGateway $DefaultGateway `
        -AddressFamily IPv4

    Set-DnsClientServerAddress `
        -InterfaceAlias $InterfaceAlias `
        -ServerAddresses $DNSServer

    Disable-NetAdapterBinding -Name $InterfaceAlias -ComponentID ms_tcpip6

    Write-Host "Network configuration applied successfully." -ForegroundColor Green

    Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 | 
        Select-Object IPAddress, PrefixLength | Format-Table
}
