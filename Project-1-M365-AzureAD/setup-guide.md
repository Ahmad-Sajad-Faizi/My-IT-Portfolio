# Setup Guide — M365 Tenant + Azure AD from Scratch

> **About this document:** This is a general reference guide covering all configuration steps for a Microsoft 365 + Azure AD environment. It is intended as a structured walkthrough and decision-making reference. For the actual implementation of this project — including screenshots and real configuration choices made for Faizi-IT BV — see the step-by-step documentation in the `/documentation/` folder.

> Follow these steps in order. Each section assumes the previous one is complete.

---

## Step 1 — Create the Microsoft 365 Tenant

> **Recommended for labs:** Use the **Microsoft 365 Developer Program** (free, 25 E5 licences, 90-day renewable) instead of a paid trial. Sign up at [developer.microsoft.com/microsoft-365/dev-program](https://developer.microsoft.com/en-us/microsoft-365/dev-program). This is the approach used in this project — see [A.1 Tenant Overview](documentation/A-tenant-setup-%26-user-management/tenant-overview.md) for the actual implementation steps. The commercial sign-up steps below apply if you are setting up a paid production tenant.

### 1.1 Sign Up

1. Go to [https://www.microsoft.com/en-us/microsoft-365/business](https://www.microsoft.com/en-us/microsoft-365/business)
2. Select a plan (Business Basic, Business Standard, or Enterprise E3/E5)
3. Click **Try free for 1 month** or **Buy now**
4. Enter your business email address and follow the sign-up wizard
5. Create your initial admin account — this will be in the format `admin@yourorg.onmicrosoft.com`
6. Note your **tenant name** (the part before `.onmicrosoft.com`) — this cannot be changed later

> 💡 For a lab, the free trial gives you 25 Microsoft 365 Business Premium licences for 30 days — more than enough to test everything in this guide.

### 1.2 First Login

1. Go to [https://admin.microsoft.com](https://admin.microsoft.com) and sign in with your new Global Admin account
2. Complete the welcome wizard (you can skip most of it)
3. Confirm your tenant ID: navigate to **Settings → Org settings → Organization profile**

---

## Step 2 — Add and Verify a Custom Domain

> Skip this step if using the `.onmicrosoft.com` domain for a lab.

### 2.1 Add the Domain

1. In the Microsoft 365 Admin Center, go to **Settings → Domains → Add domain**
2. Enter your domain name (e.g. `contoso.com`) and click **Use this domain**
3. Choose **Add a TXT record** to verify ownership

### 2.2 Create the DNS Verification Record

At your domain registrar (e.g. GoDaddy, Namecheap, Cloudflare), create the following record:

| Type | Name | Value | TTL |
|---|---|---|---|
| TXT | `@` | `MS=msXXXXXXXX` (shown in the wizard) | 3600 |

4. Return to the Microsoft 365 wizard and click **Verify** — allow up to 15 minutes for DNS propagation

### 2.3 Configure M365 DNS Records

Once verified, the wizard will show you the required DNS records for M365 services:

| Service | Record Type | Purpose |
|---|---|---|
| Exchange Online | MX | Email routing to Microsoft |
| Exchange Online | TXT (SPF) | Prevent email spoofing |
| Exchange Online | CNAME (Autodiscover) | Outlook auto-configuration |
| Teams / Skype | CNAME × 2 | Teams federation and SIP |
| Intune | CNAME | Device enrolment |

Add all records at your registrar. Microsoft will verify them automatically within 1 hour.

---

## Step 3 — Configure Azure AD / Entra ID Baseline

### 3.1 Open Entra Admin Center

1. Go to [https://entra.microsoft.com](https://entra.microsoft.com)
2. Sign in as Global Administrator

### 3.2 Configure Organisation Settings

1. Navigate to **Identity → Overview → Properties**
2. Set your **Display name** and **Country/Region**
3. Under **Access management for Azure resources**, toggle on only if you need Azure subscription management

### 3.3 Configure User Settings

1. Go to **Identity → Users → User settings**
2. Review and set the following:

| Setting | Recommended Value | Reason |
|---|---|---|
| Users can register applications | No | Prevent shadow app registrations |
| Users can consent to apps | No | Require admin consent for OAuth apps |
| Guest user access restrictions | Guest users have limited access | Least privilege for external users |
| LinkedIn account connections | No | Privacy and data governance |

### 3.4 Configure Security Defaults (Lab Only)

> For production environments, skip Security Defaults and use Conditional Access (Step 8).

1. Go to **Identity → Overview → Properties → Manage Security defaults**
2. Toggle **Security defaults** to **Enabled**

Security Defaults enforce: MFA for all users, MFA for admins on every sign-in, block legacy authentication protocols.

---

## Step 4 — Create Users

### 4.1 Create Individual Users

1. In Entra Admin Center, go to **Identity → Users → All users → New user → Create new user**
2. Fill in:
   - **User principal name** (UPN): `firstname.lastname@yourdomain.com`
   - **Display name**
   - **Password**: auto-generate and force change on first sign-in
3. Under **Properties**, set **Department**, **Job title**, **Usage location** (required for license assignment)
4. Click **Create**

> 🔁 **Bulk create**: For multiple users, use **Bulk create** and download the CSV template. Fill in the required columns and upload.

### 4.2 Create Admin Accounts

Best practice: create a **separate dedicated admin account** for each administrator — do not use a personal/work account for admin tasks.

1. Create a new user (e.g. `admin.firstname@yourdomain.com`)
2. After creating, assign admin roles (covered in Step 12)

### 4.3 Verify User Creation

1. Go to **Identity → Users → All users**
2. Confirm users appear with the correct UPN and that **Usage location** is set
3. Check that **Account enabled** is toggled on

---

## Step 5 — Create Groups

### 5.1 Create a Security Group (for policies and licensing)

1. Go to **Identity → Groups → All groups → New group**
2. Set:
   - **Group type**: Security
   - **Group name**: e.g. `SG-All-Employees`
   - **Membership type**: Assigned (or Dynamic for rules-based membership)
3. Add members and click **Create**

### 5.2 Create a Microsoft 365 Group (for collaboration)

1. **Group type**: Microsoft 365
2. **Group name**: e.g. `Marketing Team`
3. This automatically creates a shared mailbox, Teams channel, SharePoint site, and Planner board

### 5.3 Dynamic Group (Optional)

Use dynamic membership to automatically add users based on attributes:

1. **Membership type**: Dynamic User
2. Add a rule, e.g.: `(user.department -eq "Sales")`
3. Click **Validate rules** to preview which users would match

---

## Step 6 — Assign Licenses

### 6.1 Assign a License to an Individual User

1. In the Microsoft 365 Admin Center, go to **Billing → Licenses**
2. Click on your license (e.g. Microsoft 365 Business Premium)
3. Click **Assign licenses → Add users**
4. Search for the user, select them, and click **Assign**

### 6.2 Group-Based Licensing (Recommended)

1. Go to **Entra Admin Center → Identity → Groups → All groups**
2. Open a security group (e.g. `SG-All-Employees`)
3. Go to **Licenses → Assignments → Add assignments**
4. Select the license and click **Save**
5. Any user added to the group will automatically receive the licence

> ⚠️ Group-based licensing requires Azure AD Premium P1, which is included in Business Premium, E3, and E5.

---

## Step 7 — Enforce Multi-Factor Authentication (MFA)

> Choose **one** of the two approaches below. Do not run both simultaneously.

### Option A — Per-User MFA (Simple, Legacy)

1. In the Microsoft 365 Admin Center, go to **Users → Active users → Multi-factor authentication** (link at top)
2. Select users and click **Enable**
3. Users will be prompted to register MFA on next sign-in

> ⚠️ Per-user MFA is less flexible — it applies uniformly with no conditions. Use Conditional Access for production.

### Option B — MFA via Conditional Access (Recommended for Production)

Covered in Step 8.

### 7.1 Configure MFA Registration Policy

1. In Entra Admin Center, go to **Protection → Authentication methods → Authentication methods policy**
2. Enable: **Microsoft Authenticator** (push notifications), **TOTP (third-party authenticators)**, **SMS** (as fallback)
3. Disable: **Voice call** (less secure), **Email OTP** for sign-in

### 7.2 Configure SSPR (Self-Service Password Reset)

1. Go to **Protection → Password reset**
2. **Enabled**: Select **All** (or a specific security group)
3. **Authentication methods required**: 2
4. Enable: **Mobile app notification**, **Email**, **Mobile phone** (SMS)
5. Click **Save**

---

## Step 8 — Configure Conditional Access Policies

> Requires Azure AD Premium P1 (included in Business Premium / E3 / E5).
> Before enabling, ensure all users have completed MFA registration. Use **Report-only mode** first.

### 8.1 Require MFA for All Users

1. Go to **Entra Admin Center → Protection → Conditional Access → Policies → New policy**
2. **Name**: `CA001 - Require MFA for all users`
3. **Users**: All users (exclude the Break Glass account — see Step 8.4)
4. **Cloud apps**: All cloud apps
5. **Conditions**: (none for base policy)
6. **Grant**: Grant access → Require multi-factor authentication
7. **Enable policy**: Report-only (test first), then On
8. Click **Create**

### 8.2 Block Legacy Authentication

Legacy protocols (IMAP, POP3, SMTP AUTH, older Exchange ActiveSync) bypass MFA. Block them:

1. **Name**: `CA002 - Block legacy authentication`
2. **Users**: All users
3. **Cloud apps**: All cloud apps
4. **Conditions → Client apps**: Select all legacy authentication clients
5. **Grant**: Block access
6. **Enable policy**: On (after confirming no users rely on legacy clients)

### 8.3 Require MFA for Admin Roles

1. **Name**: `CA003 - Require MFA for admins`
2. **Users → Directory roles**: Select all admin roles (Global Admin, Exchange Admin, SharePoint Admin, etc.)
3. **Cloud apps**: All cloud apps
4. **Grant**: Require MFA + Require compliant device (if using Intune)
5. **Enable policy**: On

### 8.4 Create a Break Glass Account

> A Break Glass account is an emergency admin account excluded from all Conditional Access policies. Store its credentials in a physical safe.

1. Create a new user: `breakglass@yourorg.onmicrosoft.com`
2. Assign **Global Administrator** role
3. Set a strong 20+ character password — record it offline
4. Exclude this account from all Conditional Access policies
5. Set up an alert: **Entra ID → Monitoring → Diagnostic settings → Sign-in logs** — alert on any sign-in from this account

---

## Step 9 — Configure Exchange Online

1. Go to [https://admin.exchange.microsoft.com](https://admin.exchange.microsoft.com)

### 9.1 Verify Accepted Domains

1. **Mail flow → Accepted domains** — confirm your verified domain is listed as **Authoritative**

### 9.2 Configure Anti-Spam and Anti-Malware

1. **Policies & rules → Threat policies**
2. Review and update: **Anti-spam inbound policy**, **Anti-malware policy**, **Anti-phishing policy**
3. Enable **Safe Attachments** and **Safe Links** (requires Defender for Office 365 Plan 1, included in Business Premium)

### 9.3 Create Shared Mailboxes

1. **Recipients → Mailboxes → Add a shared mailbox**
2. Enter the display name and email address (e.g. `support@contoso.com`)
3. Add **Members** — these users can send from and access the shared mailbox
4. Shared mailboxes do not require a licence if under 50 GB

### 9.4 Configure Email Retention

1. **Compliance → Retention policies** (or go to Microsoft Purview)
2. Create a policy: retain all mailbox items for 7 years (or as required by your jurisdiction)

---

## Step 10 — Configure Microsoft Teams

1. Go to [https://admin.teams.microsoft.com](https://admin.teams.microsoft.com)

### 10.1 Configure Messaging Policies

1. **Messaging policies → Global (Org-wide default)**
2. Review settings: enable Giphy (appropriate content filter), disable read receipts if needed for privacy

### 10.2 Configure Meeting Policies

1. **Meetings → Meeting policies → Global**
2. Recommended settings: automatically admit **People in my organization**, require lobby for guests

### 10.3 Configure External Access

1. **Users → External access**
2. **Teams and Skype for Business users in external organisations**: Allow all (or restrict to specific domains)
3. **Guest access**: Enable (manage who can invite guests under Entra ID)

### 10.4 Configure Teams App Permissions

1. **Teams apps → Permission policies**
2. Review which Microsoft and third-party apps are allowed by default

---

## Step 11 — Configure SharePoint Online and OneDrive

1. Go to [https://[tenant]-admin.sharepoint.com](https://admin.microsoft.com) → **Admin centers → SharePoint**

### 11.1 Configure Sharing Settings (Critical)

1. **Policies → Sharing**
2. Set **SharePoint** sharing level: **New and existing guests** (or **Only people in your organisation** for strict environments)
3. Set **OneDrive** sharing level: same as or more restrictive than SharePoint
4. Enable: **Require sign-in to access shared content**

### 11.2 Create a Site Collection

1. **Sites → Active sites → Create**
2. Choose **Team site** (connects to Microsoft 365 Group and Teams)
3. Enter name, owner, and language
4. After creation, configure **Permissions** under **Site settings**

### 11.3 Configure OneDrive Storage Quota

1. **Settings → OneDrive → Storage limit**
2. Set a default per-user quota (1 TB is the default with most plans)

---

## Step 12 — Assign Admin Roles

### 12.1 Assign a Built-In Role

1. In Entra Admin Center, go to **Identity → Users → All users**
2. Open the admin user account
3. **Assigned roles → Add assignments**
4. Select the appropriate role (see `security-matrix.md` for role definitions)

### 12.2 Recommended Role Assignments

| Persona | Recommended Role |
|---|---|
| Primary IT Admin | Global Administrator (1–2 accounts max) |
| Help Desk staff | Helpdesk Administrator |
| Exchange management | Exchange Administrator |
| Teams management | Teams Administrator |
| User management only | User Administrator |
| Read-only auditing | Global Reader |

---

## Step 13 — Enable Audit Logging and Monitoring

### 13.1 Enable Unified Audit Log

1. Go to [https://compliance.microsoft.com](https://compliance.microsoft.com) → **Audit**
2. If prompted, click **Start recording user and admin activity**

> ⚠️ Audit logs are retained for 90 days on E3 and 1 year on E5 / with the Audit (Premium) add-on.

### 13.2 Review Sign-In Logs

1. In Entra Admin Center, go to **Identity → Monitoring → Sign-in logs**
2. Filter by **Status = Failure** to find blocked or failed sign-in attempts
3. Check **Conditional Access** column to see which policies were applied

### 13.3 Set Up Basic Alerts

1. Go to **Entra Admin Center → Identity → Monitoring → Diagnostic settings**
2. Forward logs to a **Log Analytics Workspace** (Azure Monitor) for alerting
3. Basic alerts to configure: failed sign-ins above threshold, Break Glass account sign-in, admin role change

---

## Completion Checklist

- [ ] Tenant created and custom domain verified
- [ ] All users created with correct UPN and Usage location set
- [ ] Licences assigned (individually or via group)
- [ ] MFA enforced via Conditional Access (or Security Defaults for lab)
- [ ] Legacy authentication blocked
- [ ] Break Glass account created and excluded from CA policies
- [ ] Exchange Online: anti-spam and anti-malware policies reviewed
- [ ] SharePoint sharing settings configured
- [ ] Admin roles assigned following least-privilege
- [ ] Unified Audit Log enabled
- [ ] Sign-in logs reviewed for baseline errors
