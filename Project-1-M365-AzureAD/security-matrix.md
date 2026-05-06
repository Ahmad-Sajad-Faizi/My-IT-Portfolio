# Security Matrix — M365 + Azure AD Policy Overview

> This document provides a structured reference of all security controls configured in this project. Use it during implementation and periodic security reviews.

---

## 1. Security Defaults vs Conditional Access

Choose **one approach** per tenant. They cannot coexist.

| Feature | Security Defaults | Conditional Access |
|---|---|---|
| **Requires** | Free / Any licence | Azure AD Premium P1+ |
| **MFA for all users** | Yes — always | Yes — configurable |
| **MFA for admins** | Yes — every sign-in | Yes — every sign-in |
| **Block legacy auth** | Yes | Yes (via policy CA002) |
| **Named locations** | No | Yes |
| **Risk-based policies** | No | Yes (P2) |
| **Device compliance** | No | Yes |
| **Per-app exceptions** | No | Yes |
| **Exclude specific users** | No | Yes |
| **Recommended for** | Small orgs, labs | Production environments |

---

## 2. Conditional Access Policy Register

| Policy ID | Policy Name | Users | Apps | Conditions | Grant Control | State |
|---|---|---|---|---|---|---|
| CA001 | Require MFA for all users | All users (excl. Break Glass) | All cloud apps | — | Require MFA | On |
| CA002 | Block legacy authentication | All users | All cloud apps | Client apps = Legacy auth clients | Block | On |
| CA003 | Require MFA for admins | Directory roles (all admin roles) | All cloud apps | — | Require MFA | On |
| CA004 | Block sign-in from high-risk countries | All users | All cloud apps | Locations = excluded named locations | Block | On |
| CA005 | Require compliant device for admins | Directory roles (admin) | All cloud apps | — | Require MFA + Require compliant device | On |
| CA006 | Guest MFA requirement | Guest users | All cloud apps | — | Require MFA | On |

### Named Locations

| Location Name | Type | Values | Used In |
|---|---|---|---|
| Corporate office | IP ranges | Add your office public IPs | CA004 (trusted) |
| High-risk countries | Country/Region | List of excluded countries | CA004 |

---

## 3. MFA Authentication Methods

Configure at **Entra Admin Center → Protection → Authentication methods → Authentication methods policy**.

| Method | Recommended | Notes |
|---|---|---|
| **Microsoft Authenticator (push)** | ✅ Enabled | Most phishing-resistant option after passkeys |
| **TOTP (third-party authenticator)** | ✅ Enabled | Useful for users who cannot use Authenticator |
| **Passkeys (FIDO2)** | ✅ Enabled (if P1) | Strongest option — phishing resistant |
| **Temporary Access Pass** | ✅ Enabled | For onboarding or emergency access |
| **SMS / Voice call** | ⚠️ Fallback only | Vulnerable to SIM swap — use only as last resort |
| **Email OTP** | ❌ Disable for users | Too easy to compromise if email is breached |
| **Certificate-based auth** | Optional | For high-security environments |

---

## 4. Password Policies

| Setting | Recommended Value | Location |
|---|---|---|
| **Minimum password length** | 12 characters | Entra ID → Password reset → Password policies |
| **Password complexity** | Enabled (upper, lower, digit, symbol) | Azure AD default |
| **Password expiration** | Never (with MFA enforced) | Microsoft's current recommendation |
| **Smart lockout threshold** | 10 attempts | Entra ID → Security → Authentication methods → Password protection |
| **Smart lockout duration** | 60 seconds (base) | Same location |
| **Custom banned passwords** | Add company name, product names | Entra ID → Password protection |
| **Self-service password reset** | Enabled for all users | Protection → Password reset |
| **SSPR authentication methods** | 2 required | Protection → Password reset |

> 📌 **Note**: Microsoft no longer recommends mandatory periodic password rotation when MFA is enforced. Forced password resets lead to predictable patterns (e.g. `Password1!` → `Password2!`). Use SSPR + breach detection (Identity Protection) instead.

---

## 5. Admin Roles Reference

| Role | Permissions | When to Use |
|---|---|---|
| **Global Administrator** | Full tenant control | Maximum 2–4 accounts; use only when necessary |
| **Global Reader** | Read-only across all services | Auditors, compliance officers |
| **User Administrator** | Create/edit/delete users and groups | Help Desk, HR-facing IT |
| **Helpdesk Administrator** | Reset passwords, manage service requests | Tier 1 Help Desk |
| **Exchange Administrator** | Full Exchange Online management | Email admins |
| **Teams Administrator** | Full Teams management | Collaboration admins |
| **SharePoint Administrator** | Full SharePoint/OneDrive management | Document management admins |
| **Licence Administrator** | Assign/remove licences | Procurement or HR IT |
| **Security Administrator** | Manage Defender, Conditional Access, Identity Protection | Security engineers |
| **Security Reader** | Read-only security portal access | SOC analysts, auditors |
| **Conditional Access Administrator** | Create and modify CA policies | Identity/security admins |
| **Authentication Administrator** | Reset MFA for non-admin users | Help Desk (advanced) |
| **Privileged Role Administrator** | Assign/manage all privileged roles | Only 1–2 people, tightly controlled |

### Least-Privilege Principle

- Assign the **narrowest role** that covers the task
- Use **Privileged Identity Management (PIM)** (requires P2) to make admin roles time-limited and approval-gated
- Review role assignments **quarterly** using Entra ID → Identity Governance → Access Reviews

---

## 6. Service-Level Security Settings

### Exchange Online

| Control | Setting | Location |
|---|---|---|
| Anti-spam inbound | Enabled (default policy hardened) | Exchange Admin → Policies → Threat policies |
| Anti-malware | Block common attachment types | Threat policies → Anti-malware |
| Anti-phishing | Enable impersonation protection | Threat policies → Anti-phishing |
| Safe Attachments | Enabled — Dynamic Delivery | Threat policies → Safe Attachments |
| Safe Links | Enabled | Threat policies → Safe Links |
| SMTP AUTH (legacy) | Disabled globally, allowlisted per device | Exchange Admin → Settings → Mail flow |
| External email warning banner | Enabled | Mail flow → Rules → External sender tag |
| DKIM signing | Enabled for custom domain | Email authentication → DKIM |
| DMARC | Configured at DNS level (p=quarantine) | Domain registrar DNS |

### SharePoint Online and OneDrive

| Control | Setting |
|---|---|
| External sharing (SharePoint) | New and existing guests (or org-only for sensitive) |
| External sharing (OneDrive) | Same as or more restrictive than SharePoint |
| Require sign-in to access shared links | Enabled |
| Default link type | Specific people (not "Anyone with link") |
| Guest link expiration | 30 days |
| File and folder link permissions | View only (default) |

### Teams

| Control | Setting |
|---|---|
| Guest access | Enabled (restricted by Entra ID guest invite settings) |
| External access | Enabled for trusted domains only |
| Meeting recording | Allowed (auto-expire after 60 days) |
| Anonymous meeting join | Disabled |
| Lobby bypass | Organiser and co-organisers only for external meetings |

---

## 7. Audit and Monitoring Checklist

| Item | Configured | Notes |
|---|---|---|
| Unified Audit Log enabled | ☐ | compliance.microsoft.com → Audit |
| Sign-in log diagnostic settings | ☐ | Forward to Log Analytics |
| Break Glass account alert | ☐ | Alert on any sign-in from this account |
| Risky sign-in alert | ☐ | Entra ID → Identity Protection → Alerts |
| Admin role change alert | ☐ | Audit log alert on role assignment events |
| Failed MFA spike alert | ☐ | Alert on >10 MFA failures in 5 minutes per user |
| Secure Score review | ☐ | security.microsoft.com → Secure Score — target 60%+ |

---

## 8. Secure Score Targets

Microsoft Secure Score measures your security posture. Track at [https://security.microsoft.com/securescore](https://security.microsoft.com/securescore).

| Milestone | Target Score | Key Actions |
|---|---|---|
| Day 1 (baseline) | ~30% | Default tenant state |
| After this setup guide | ~55–65% | MFA, CA policies, anti-phishing, DKIM, DMARC |
| After Intune MDM setup | ~70–75% | Device compliance policies enforced |
| After PIM and Identity Protection | ~80%+ | Privileged access hardening |

> Secure Score is directional, not a guarantee of security. Prioritise the highest-impact actions relevant to your threat model.
