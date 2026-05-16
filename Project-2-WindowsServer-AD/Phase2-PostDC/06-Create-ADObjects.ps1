#requires -RunAsAdministrator
<#
.SYNOPSIS
    Create OU structure, security groups, and user accounts
.DESCRIPTION
    Bulk imports users from inline data. Creates department OUs and groups.
#>

param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

$DomainDN = "DC=corp,DC=faizi,DC=ovh"

Write-Host "Creating Active Directory structure..." -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "[WHATIF] Would create OUs, groups, and users" -ForegroundColor Magenta
} else {
    # ============================================
    # 1. CREATE OU STRUCTURE
    # ============================================
    $OUs = @(
        @{ Name="Lab_Computers"; Parent="$DomainDN" },
        @{ Name="Finance"; Parent="OU=Lab_Computers,$DomainDN" },
        @{ Name="HR"; Parent="OU=Lab_Computers,$DomainDN" },
        @{ Name="IT"; Parent="OU=Lab_Computers,$DomainDN" },
        @{ Name="Marketing"; Parent="OU=Lab_Computers,$DomainDN" },
        @{ Name="Computers"; Parent="OU=Lab_Computers,$DomainDN" },
        @{ Name="Groups"; Parent="$DomainDN" },
        @{ Name="Service Accounts"; Parent="$DomainDN" }
    )

    foreach ($ou in $OUs) {
        $existing = Get-ADOrganizationalUnit -Filter { Name -eq $ou.Name } -SearchBase $ou.Parent -ErrorAction SilentlyContinue
        if (-not $existing) {
            New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Parent -ProtectedFromAccidentalDeletion $false
            Write-Host "  Created OU: $($ou.Name)" -ForegroundColor Green
        } else {
            Write-Host "  OU exists: $($ou.Name)" -ForegroundColor Yellow
        }
    }

    # ============================================
    # 2. CREATE SECURITY GROUPS
    # ============================================
    $Groups = @(
        @{ Name="GG_Finance";    Description="Finance Department" },
        @{ Name="GG_HR";         Description="HR Department" },
        @{ Name="GG_IT";         Description="IT Department" },
        @{ Name="GG_Marketing";  Description="Marketing Department" },
        @{ Name="GG_Sales";      Description="Sales Department" },
        @{ Name="DL_All_Users";  Description="All Users Distribution" },
        @{ Name="DL_IT_Team";    Description="IT Team Distribution" }
    )

    foreach ($group in $Groups) {
        $existing = Get-ADGroup -Filter { Name -eq $group.Name } -ErrorAction SilentlyContinue
        if (-not $existing) {
            New-ADGroup `
                -Name $group.Name `
                -Path "OU=Groups,$DomainDN" `
                -GroupScope Global `
                -GroupCategory Security `
                -Description $group.Description
            Write-Host "  Created group: $($group.Name)" -ForegroundColor Green
        } else {
            Write-Host "  Group exists: $($group.Name)" -ForegroundColor Yellow
        }
    }

    # ============================================
    # 3. CREATE USERS (Inline data)
    # ============================================
    $Users = @(
        @{ Name="Ahmad Faizi";       Username="AhmadFaizi";       Department="IT";        Password="IT@dmin2026!" },
        @{ Name="John Smith";        Username="JohnSmith";        Department="Finance";    Password="Fin@nce2026!" },
        @{ Name="Sarah Lee";         Username="SarahLee";         Department="HR";         Password="HR@dept2026!" },
        @{ Name="Mike Brown";        Username="MikeBrown";        Department="Marketing";  Password="Mkt@2026!Pass" },
        @{ Name="Emily Davis";       Username="EmilyDavis";       Department="Finance";    Password="Fin@nce2026!" },
        @{ Name="David Wilson";      Username="DavidWilson";      Department="IT";         Password="IT@dmin2026!" },
        @{ Name="Lisa Anderson";     Username="LisaAnderson";     Department="HR";         Password="HR@dept2026!" },
        @{ Name="Robert Taylor";     Username="RobertTaylor";     Department="Marketing";  Password="Mkt@2026!Pass" },
        @{ Name="Jennifer Martinez"; Username="JenniferMartinez"; Department="Sales";      Password="S@les2026!Pass" },
        @{ Name="James Johnson";     Username="JamesJohnson";     Department="Sales";      Password="S@les2026!Pass" }
    )

    foreach ($user in $Users) {
        $ouPath = "OU=$($user.Department),OU=Lab_Computers,$DomainDN"
        $upn = "$($user.Username)@corp.faizi.ovh"

        $existing = Get-ADUser -Filter { SamAccountName -eq $user.Username } -ErrorAction SilentlyContinue
        if (-not $existing) {
            New-ADUser `
                -Name $user.Name `
                -GivenName ($user.Name -split ' ')[0] `
                -Surname ($user.Name -split ' ')[1] `
                -SamAccountName $user.Username `
                -UserPrincipalName $upn `
                -Path $ouPath `
                -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
                -Enabled $true `
                -ChangePasswordAtLogon $false `
                -PasswordNeverExpires $true

            Add-ADGroupMember -Identity "GG_$($user.Department)" -Members $user.Username
            Add-ADGroupMember -Identity "DL_All_Users" -Members $user.Username

            if ($user.Department -eq "IT") {
                Add-ADGroupMember -Identity "Domain Admins" -Members $user.Username
            }

            Write-Host "  Created user: $($user.Username) [$($user.Department)]" -ForegroundColor Green
        } else {
            Write-Host "  User exists: $($user.Username)" -ForegroundColor Yellow
        }
    }

    Write-Host "`nAD Objects Summary:" -ForegroundColor Cyan
    Write-Host "  OUs: $(@(Get-ADOrganizationalUnit -Filter * -SearchBase $DomainDN).Count)" -ForegroundColor Gray
    Write-Host "  Groups: $(@(Get-ADGroup -Filter * -SearchBase $DomainDN).Count)" -ForegroundColor Gray
    Write-Host "  Users: $(@(Get-ADUser -Filter * -SearchBase $DomainDN).Count)" -ForegroundColor Gray

    Write-Host "`nActive Directory structure complete." -ForegroundColor Green
}
