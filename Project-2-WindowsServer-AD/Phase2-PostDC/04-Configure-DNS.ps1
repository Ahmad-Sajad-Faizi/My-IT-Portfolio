#requires -RunAsAdministrator
<#
.SYNOPSIS
    Configure DNS zones and records for Active Directory
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$DomainName = "corp.faizi.ovh"
$ServerIP   = "192.168.10.2"
$ServerName = $env:COMPUTERNAME

Write-Host "Configuring DNS Server..." -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "[WHATIF] Would configure DNS forwarders and reverse zone" -ForegroundColor Magenta
} else {
    Set-DnsServerForwarder -IPAddress @("1.1.1.1", "8.8.8.8") -UseRootHint $false
    Write-Host "  Forwarders set: 1.1.1.1, 8.8.8.8" -ForegroundColor Green

    $ReverseZone = "10.168.192.in-addr.arpa"
    $zone = Get-DnsServerZone -Name $ReverseZone -ErrorAction SilentlyContinue
    if (-not $zone) {
        Add-DnsServerPrimaryZone -NetworkID "192.168.10.0/24" -ReplicationScope "Forest" -DynamicUpdate "Secure"
        Write-Host "  Reverse zone created: $ReverseZone" -ForegroundColor Green
    } else {
        Write-Host "  Reverse zone already exists" -ForegroundColor Yellow
    }

    $aRecord = Get-DnsServerResourceRecord -ZoneName $DomainName -Name $ServerName -ErrorAction SilentlyContinue
    if (-not $aRecord) {
        Add-DnsServerResourceRecordA -Name $ServerName -ZoneName $DomainName -IPv4Address $ServerIP -CreatePtr
        Write-Host "  A record created: $ServerName -> $ServerIP" -ForegroundColor Green
    }

    Write-Host "`nDNS Configuration Summary:" -ForegroundColor Cyan
    Get-DnsServerZone | Where-Object { $_.ZoneType -eq 'Primary' } | 
        Select-Object ZoneName, ZoneType, DynamicUpdate | Format-Table

    Write-Host "DNS configuration complete." -ForegroundColor Green
}
