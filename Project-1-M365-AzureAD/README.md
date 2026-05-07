# Project 1 — Microsoft 365 & Azure AD Administration

**Duration:** unknown | **Status:** Planned | **Cost:** €0

> Build a complete cloud identity and device management environment for a fictional company, "Faizi-IT BV", using Microsoft 365 and Azure Active Directory.

---

##  Objective

As an IT support professional, managing a full Microsoft 365 environment — including users, devices, and security — is a core competency. This project simulates a real-world scenario where a new company is set up in the cloud from scratch.

---

## Architecture

```
Faizi-IT BV — Microsoft 365 Tenant ()
│
├── Azure Active Directory
│   ├── Global Admin (1x)
│   ├── User Administrators (2x)
│   ├── Standard Users (5x)
│   └── Guest Users / External (2x)
│
├── Microsoft Intune (Device Management)
│   ├── Windows 11 Devices (Autopilot)
│   ├── Compliance Policies
│   └── App Deployment (M365 Apps, Chrome, Acrobat)
│
├── Exchange Online
│   ├── Shared Mailboxes (support@, info@, sales@)
│   └── Transport Rules
│
└── Microsoft Teams
    └── Team Structure with Channels
```

---

## Technologies

![Microsoft 365](https://img.shields.io/badge/Microsoft_365-D83B01?style=flat&logo=microsoft-office&logoColor=white)
![Azure AD](https://img.shields.io/badge/Azure_AD-0078D4?style=flat&logo=microsoft-azure&logoColor=white)
![Intune](https://img.shields.io/badge/Intune-0078D4?style=flat&logo=microsoft&logoColor=white)
![Exchange Online](https://img.shields.io/badge/Exchange_Online-0078D4?style=flat&logo=microsoft-exchange&logoColor=white)

---

## Requirements Checklist

### A. Tenant Setup & User Management
- [ ] Microsoft 365 Developer Tenant (free, 25 licenses)
- [ ] Azure Free Account activated
- [ ] Domain configured (faiziit.onmicrosoft.com)
- [ ] 10 test users created with different roles
- [ ] Licenses assigned (M365 Business Premium, E5 Developer)
- [ ] Dynamic groups configured (department/location based)

### B. Security & Identity
- [ ] MFA enforced for all admins
- [ ] Conditional Access — block non-EU countries
- [ ] Conditional Access — require MFA for all cloud apps
- [ ] Conditional Access — require a compliant device for sensitive data
- [ ] Self-Service Password Reset (SSPR) enabled
- [ ] Azure AD Identity Protection configured
- [ ] Risk-based policies (high risk = force password change)

### C. Intune Device Management
- [ ] Windows 11 enrollment configured (Autopilot-ready)
- [ ] Device compliance policies (BitLocker, Defender, Windows Update)
- [ ] App deployment (M365 Apps, Chrome, Acrobat Reader)
- [ ] Configuration profiles (Wi-Fi, VPN, branding wallpaper)

### D. Exchange Online & Collaboration
- [ ] Shared mailboxes (support@, info@, sales@)
- [ ] Email aliases configured
- [ ] Transport rules (disclaimer, external email warning)
- [ ] Microsoft Teams structure with channels

---

## Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | Architecture diagram (draw.io) | in progress |
| 2 | Step-by-step configuration guide with screenshots | in progress |
| 3 | Security policy matrix | in progress |
| 4 | Troubleshooting log | in progress |

---

## Folder Structure

```

Project-1-M365-AzureAD/
├── README.md                          ← You are here
├── setup-guide.md                     ← Full step-by-step implementation walkthrough
├── security-matrix.md                 ← All security policies and controls in one place
├── troubleshooting.md                 ← Issues encountered and how they were resolved
├── diagrams/
│   └── architecture.svg              ← Tenant architecture diagram
└── documentation/
    ├── A-tenant-setup-&-user-management/
    │   ├── tenant-overview.md         ← Tenant creation, domain, licences
    │   ├── user-accounts.md           ← 10 test users, roles, and departments
    │   └── dynamic-groups.md         ← Dynamic group rules and membership logic
    ├── B-security-&-Identity/
    │   ├── mfa-and-conditional-access.md   ← MFA setup and 3 CA policies
    │   └── sspr-and-identity-protection.md ← SSPR config and risk-based policies
    ├── C-intune-device-management/
    │   ├── enrollment-and-compliance.md    ← Autopilot + compliance policies
    │   ├── app-deployment.md              ← Required app deployment via Intune
    │   └── configuration-profiles.md     ← Wi-Fi, VPN, branding profiles
    └── D-exchange-online-&-collaboration/
        ├── shared-mailboxes.md            ← Shared mailboxes and aliases
        ├── transport-rules.md             ← Disclaimer and warning rules
        └── teams-structure.md            ← Teams and channel configuration

```

---

## Resources

- [Microsoft 365 Developer Program](https://developer.microsoft.com/en-us/microsoft-365/dev-program)
- [Azure AD Documentation](https://docs.microsoft.com/en-us/azure/active-directory/)
- [Intune Documentation](https://docs.microsoft.com/en-us/mem/intune/)
- [MS-900 Exam Prep](https://learn.microsoft.com/en-us/certifications/exams/ms-900/)

---

*Part of the [IT Portfolio 2026](../README.md) — Ahmad Sajad Faizi*
