# Troubleshooting Guide — M365 + Azure AD

> **About this document:** This file serves two purposes. The first section (**Real Issues Encountered**) logs actual problems that came up during the implementation of this project, with the exact symptoms and how they were resolved. The second section (**Reference Guide**) is a broader troubleshooting reference covering common M365 and Azure AD issues, intended as a knowledge base for future use.

> Each issue includes symptoms, root cause, and step-by-step resolution. Issues are grouped by area.

---

## Real Issues Encountered During This Project

> This section documents genuine problems encountered while building the Faizi-IT BV lab environment. It will grow as the project progresses.

---

### Issue 001 — MFA registration prompt did not appear for new users after tenant creation

**When:** Section A — Tenant setup, after creating the first standard user accounts.

**Symptoms:** Newly created users (Emma Larsson, David Okonkwo, etc.) could sign in without being prompted to register MFA, even though the Global Admin account had MFA configured.

**Root cause:** The tenant had **Security Defaults** enabled (which enforces MFA on a per-login basis when Microsoft decides) but Conditional Access policies had not yet been configured. Security Defaults does not force immediate MFA registration at first sign-in for all users — it prompts users gradually over a 14-day window.

**Resolution:**
1. Navigated to **Entra Admin Center → Identity → Overview → Properties → Manage Security defaults** and confirmed Security Defaults was enabled.
2. For the lab, decided to leave Security Defaults active for the current section (A) and replace it with explicit Conditional Access policies in Section B, which will force MFA registration for all users immediately.
3. Added a note in `setup-guide.md` Step 8 to document this behaviour so future users know what to expect.

**Lesson learned:** Security Defaults and Conditional Access serve different purposes. Security Defaults is suitable for quick baseline protection but lacks the granularity needed for a realistic lab. Plan to migrate to Conditional Access in Section B.

---

*(Additional issues will be logged here as the project progresses.)*

---

---

# Reference Guide

---

## 1. Domain & DNS

---

### Domain verification fails — "We can't verify your domain"

**Symptoms**: The Microsoft 365 wizard says it cannot detect the TXT record after you've added it.

**Causes and fixes**:

1. **DNS propagation not complete** — DNS changes can take up to 48 hours globally. Wait at least 15–30 minutes and retry. Use a DNS checker like [https://dnschecker.org](https://dnschecker.org) to confirm the TXT record is resolving from multiple locations.

2. **Record entered incorrectly** — Log in to your registrar and confirm:
   - The TXT **value** matches exactly what Microsoft showed (e.g. `MS=ms12345678`)
   - The **host/name** field is set to `@` (not `@.yourdomain.com` — some registrars add the domain automatically)
   - There are no leading or trailing spaces in the value field

3. **Multiple TXT records conflicting** — Some registrars do not support multiple TXT records on `@`. If you already have an SPF record, check if both records are saved. If not, consolidate them (only SPF needs combining; the MS= verification record is temporary).

---

### MX record not routing email after domain setup

**Symptoms**: Emails sent to `user@contoso.com` bounce or still route to the old provider.

**Fix**:

1. In the Exchange Admin Center → **Mail flow → Accepted domains**, confirm `contoso.com` is listed as **Authoritative** (not Internal relay)
2. At your registrar, verify the MX record points to `contoso-com.mail.protection.outlook.com` (the exact value is shown in the M365 DNS setup wizard)
3. Confirm the old MX records have been **deleted** — if two MX records exist, mail may route to the old server
4. Run `nslookup -type=mx contoso.com` from a command prompt to verify what external DNS resolves

---

## 2. User Sign-In and Authentication

---

### User cannot sign in — "Your account is locked"

**Symptoms**: User receives a lockout error immediately or after a few attempts.

**Fix**:

1. In Entra Admin Center → **Identity → Users → All users**, find the user
2. Check **Sign-in logs** for the last failed attempts — note the failure reason
3. Click on the user → **Authentication methods** → **Revoke sessions** to clear stuck sessions
4. If the account is blocked, under the user's profile, confirm **Account enabled** is toggled **On**
5. For Smart Lockout, the lockout is automatic and temporary (default: 60 seconds, doubles with each lockout). If the user is experiencing repeated lockouts due to an incorrect saved password on a device, have them clear saved passwords from all devices first

---

### User is blocked by Conditional Access — "You don't meet the access requirements"

**Symptoms**: User receives an error referencing a Conditional Access policy, or a "More information required" prompt they cannot complete.

**Fix**:

1. In Entra Admin Center → **Identity → Monitoring → Sign-in logs**
2. Find the failed sign-in and click on it → **Conditional Access** tab
3. Identify which policy shows **Failure** and what control was not satisfied
4. Common causes:
   - User has not yet registered for MFA → direct them to [https://aka.ms/mfasetup](https://aka.ms/mfasetup)
   - User is on a non-compliant device → check Intune compliance status
   - User is signing in from a blocked location → verify Named Locations configuration

5. To temporarily allow the user while troubleshooting, switch the policy to **Report-only** mode — do not exclude individual users as a permanent fix

---

### Admin cannot complete MFA — locked out of tenant

**Symptoms**: Global Admin cannot receive MFA prompts (lost phone, new device).

**Fix**:

1. Use the **Break Glass account** (see `setup-guide.md` Step 8.4) to sign in
2. From the Break Glass session, go to **Entra Admin Center → Identity → Users**
3. Open the affected admin's account → **Authentication methods** → delete all registered MFA methods
4. The user can now re-register MFA at [https://aka.ms/mfasetup](https://aka.ms/mfasetup)

> ⚠️ If you do not have a Break Glass account, contact Microsoft Support at [https://admin.microsoft.com](https://admin.microsoft.com) and verify ownership via the tenant onmicrosoft.com account or billing contact.

---

### Users prompted for MFA too frequently

**Symptoms**: Users are asked to authenticate with MFA multiple times per day on the same device.

**Causes and fixes**:

1. **Browser is clearing cookies** — MFA re-prompts occur when session cookies are deleted. Check if users have browsers set to clear cookies on exit
2. **"Remember MFA" not configured** — In Conditional Access, review your session controls. Consider adding a **Sign-in frequency** control of 7–14 days for trusted devices
3. **Device not compliant** — If a CA policy requires a compliant device and Intune compliance is expiring, the user is re-prompted. Check Intune device compliance status

---

## 3. MFA and Authentication Methods

---

### Microsoft Authenticator shows notifications but sign-in still fails

**Symptoms**: User approves the MFA push notification, but the sign-in page says the request expired or failed.

**Fix**:

1. Confirm the user's phone clock is synchronised to internet time — Authenticator is time-based and even a 2-minute drift causes failures
2. Check if **Number matching** is enabled (it should be) — the user must enter the 2-digit number shown on the sign-in screen, not just tap Approve
3. If the app seems stuck: ask the user to remove and re-add the account in Authenticator, then re-register from [https://aka.ms/mfasetup](https://aka.ms/mfasetup)

---

### SSPR (self-service password reset) not available to users

**Symptoms**: Users cannot access the "Forgot my password" link on the sign-in page, or the link redirects to a "Contact your admin" message.

**Fix**:

1. In Entra Admin Center → **Protection → Password reset → Properties**
2. Confirm **Self-service password reset enabled** is set to **All** or the relevant security group
3. Confirm the user is a member of the group if using a scoped group
4. Confirm the user has at least 2 authentication methods registered (if you require 2) — they must register before they can reset

---

## 4. Licensing

---

### "You don't have a licence for this service" error

**Symptoms**: User can sign in but cannot open Teams, Outlook, or another M365 app.

**Fix**:

1. In the Microsoft 365 Admin Center → **Billing → Licences**, confirm licences are available (check available count vs assigned)
2. Open the affected user → **Licences and apps** tab
3. Confirm the correct licence is assigned and that the specific app within the licence is enabled (e.g. Teams may be individually toggled off within the licence)
4. After assigning, allow up to 15 minutes for provisioning. If the service still fails after 1 hour, trigger a force sync by removing and re-assigning the licence

---

### Group-based licensing shows errors

**Symptoms**: In the group's **Licences** tab, some users show a red error.

**Common errors and fixes**:

| Error | Cause | Fix |
|---|---|---|
| `CountViolation` | Not enough licence seats available | Purchase more licences or remove unused assignments |
| `MutuallyExclusiveViolation` | User has two conflicting licences | Remove the older/conflicting licence from the user directly |
| `ProhibitedInUsageLocationViolation` | User's Usage location is not set | Set Usage location on the user's profile in Entra ID |
| `DependencyViolation` | Required dependent service is disabled | Enable the prerequisite service within the licence |

---

## 5. Exchange Online

---

### Emails not received after migrating to M365 / setting up new domain

**Symptoms**: External senders receive NDR (non-delivery report) or email still routes to old mail server.

**Checklist**:

1. Confirm MX record updated at registrar (TTL has expired)
2. Confirm old MX record deleted — only one MX record pointing to `*.mail.protection.outlook.com` should exist
3. In Exchange Admin Center → **Mail flow → Accepted domains** → domain must be **Authoritative**
4. User's mailbox must be licensed before Exchange Online will accept mail for them

---

### User cannot send email — "554 5.2.0 STOREDRV.Submission" error

**Symptoms**: Outbound email from Outlook fails with a 554 error.

**Fix**:

1. This usually means the user's mailbox has exceeded its quota, or the mailbox was just provisioned and hasn't fully propagated
2. Check mailbox size: Exchange Admin Center → **Recipients → Mailboxes** → select user → **Mailbox usage**
3. If recently created, wait 30–60 minutes for provisioning to complete
4. If quota exceeded, increase the mailbox quota or archive older items

---

### SMTP relay from a printer / application is not working

**Symptoms**: Multi-function printer or legacy app cannot send email through M365.

**Fix**:

1. Do not use a user account with MFA for SMTP relay — it will block legacy authentication
2. Use one of the three relay options:

| Option | Best For | How |
|---|---|---|
| Direct send | Sending to internal recipients only | Configure device to send to `[tenant].mail.protection.outlook.com` on port 25 |
| SMTP relay (connector) | Sending to external addresses | Create a mail flow connector in Exchange Admin; requires static IP |
| SMTP client submission | Low-volume, simple devices | Use port 587 with TLS; requires a licensed mailbox with SMTP AUTH explicitly enabled |

3. For SMTP client submission, enable SMTP AUTH on the specific mailbox: Exchange Admin → Mailboxes → select user → **Mailflow settings → Authenticated SMTP → Enable**

---

## 6. Teams

---

### Teams does not appear after licence assignment

**Symptoms**: User is licensed but Teams is not accessible.

**Fix**:

1. Confirm Teams is enabled within the licence: M365 Admin Center → user → **Licences and apps** → expand licence → ensure **Microsoft Teams** is checked
2. Allow up to 24 hours for Teams to provision after initial licence assignment
3. Confirm the user is not blocked by a Teams policy. In Teams Admin Center → **Users → Manage users** → find the user and review assigned policies

---

### Guests cannot join meetings — stuck in lobby

**Symptoms**: External guests are never admitted from the lobby, even when the organiser is present.

**Fix**:

1. In Teams Admin Center → **Meetings → Meeting policies → Global**
2. Check **Automatically admit people** — set to **People in my org and guests** if guests should bypass the lobby, or keep as **Everyone** for maximum access
3. Confirm guest access is enabled: Teams Admin Center → **Users → Guest access** must be **On**
4. Entra ID guest invite settings must allow external users: Entra Admin Center → **External identities → External collaboration settings**

---

## 7. SharePoint and OneDrive

---

### User cannot share a file with an external user

**Symptoms**: The sharing option is greyed out or the user receives "Sharing is not allowed" when sending a link.

**Fix**:

1. The SharePoint tenant-level sharing setting must allow external sharing. Go to SharePoint Admin Center → **Policies → Sharing** and confirm it is not set to **Only people in your organisation**
2. The specific site's sharing setting cannot be more permissive than the tenant-level setting. Check: SharePoint Admin Center → **Sites → Active sites** → select the site → **Policies → Sharing**
3. Confirm the user has at least **Edit** permissions on the item they are trying to share

---

## 8. Admin and Permission Issues

---

### Assigned admin role not appearing or not working

**Symptoms**: User was assigned a role but still cannot access the admin portal or perform the action.

**Fix**:

1. The user must **sign out and sign back in** after a role is assigned — roles are included in the access token issued at sign-in, not applied to existing sessions
2. Confirm the role was saved: Entra Admin Center → user → **Assigned roles** — verify the role appears
3. If using **Privileged Identity Management (PIM)**, the user must **activate** the role before it takes effect — check **Entra ID → PIM → My roles**
4. Confirm there is no Conditional Access policy blocking admin portal access from the user's current location or device

---

### "Insufficient permissions" when trying to create a Conditional Access policy

**Symptoms**: Admin can view but not create or modify Conditional Access policies.

**Fix**:

1. Creating or modifying CA policies requires either **Global Administrator** or **Conditional Access Administrator** role
2. **Security Administrator** can view but not always modify all policies — assign Conditional Access Administrator role specifically
3. If the tenant has enabled **Privileged Identity Management**, the user must activate the role before attempting the action

---

## 9. Diagnostic Tools

| Tool | Purpose | URL |
|---|---|---|
| Microsoft Support and Recovery Assistant (SARA) | Diagnose Outlook, Teams, and OneDrive issues on Windows | [https://aka.ms/SaRA](https://aka.ms/SaRA) |
| Microsoft Remote Connectivity Analyser | Test Exchange/Autodiscover from the outside | [https://testconnectivity.microsoft.com](https://testconnectivity.microsoft.com) |
| DNS Checker | Verify DNS records globally | [https://dnschecker.org](https://dnschecker.org) |
| MXToolbox | MX, SPF, DKIM, and DMARC verification | [https://mxtoolbox.com](https://mxtoolbox.com) |
| Entra Sign-in Logs | Real-time sign-in and CA policy evaluation | Entra Admin Center → Monitoring → Sign-in logs |
| Microsoft 365 Service Health | Official service incidents and outages | admin.microsoft.com → Health → Service health |
| Microsoft 365 Message Centre | Upcoming changes and feature announcements | admin.microsoft.com → Health → Message centre |
