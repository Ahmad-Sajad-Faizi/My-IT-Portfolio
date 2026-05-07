# A.2 — User Accounts

> **Project:** Faizi-IT BV — Microsoft 365 & Azure AD Administration  
> **Section:** A. Tenant Setup & User Management  
> **Document:** User Accounts (10 Test Users, Roles, and Departments)

---

## 1. Objective

Create a realistic organisational user structure for Faizi-IT BV consisting of **10 user accounts** across different roles, departments, and access levels. This simulates a real-world IT support scenario where user lifecycle management — creation, licensing, and role assignment — is a core responsibility.

---

## 2. User Account Planning

Before creating accounts, the following structure was designed to reflect a typical small-to-medium IT company:

| # | Display Name | Username | Role | Department | Licence | Account Type |
|---|-------------|----------|------|------------|---------|--------------|
| 1 | **Ahmad Faizi** | ahmad@faiziitlab.onmicrosoft.com | Global Administrator | IT / Management | Business Premium | Admin |
| 2 | **Sarah Mitchell** | smitchell@faiziitlab.onmicrosoft.com | User Administrator | IT / Support | M365 Business Premium | Admin |
| 3 | **James Kowalski** | jkowalski@faiziitlab.onmicrosoft.com | User Administrator | IT / Security | M365 Business Premium | Admin |
| 4 | **Emma Larsson** | elarsson@faiziitlab.onmicrosoft.com | Standard User | Development | M365 Business Premium | Member |
| 5 | **David Okonkwo** | dokonkwo@faiziitlab.onmicrosoft.com | Standard User | Development | M365 Business Premium | Member |
| 6 | **Lisa Vandenberg** | lvandenberg@faiziitlab.onmicrosoft.com | Standard User | Marketing | M365 Business Premium | Member |
| 7 | **Marco Rossi** | mrossi@faiziitlab.onmicrosoft.com | Standard User | Sales | M365 Business Premium | Member |
| 8 | **Fatima Al-Hassan** | falhassan@faiziitlab.onmicrosoft.com | Standard User | HR | M365 Business Premium | Member |
| 9 | **Thomas Berger** | tberger@faiziitlab.onmicrosoft.com | Guest User | External Consultant | — | Guest |
| 10 | **Yuki Tanaka** | ytanaka@faiziitlab.onmicrosoft.com | Guest User | External Auditor | — | Guest |

> **Design rationale:**
> - **2 User Administrators** to demonstrate delegated admin responsibilities without full Global Admin rights.
> - **5 Standard Users** across different departments to test group-based policies and dynamic membership later.
> - **2 Guest Users** to simulate B2B collaboration and external access scenarios.

---

## 3. Step-by-Step User Creation

All users were created via the **Microsoft 365 admin center** (`admin.microsoft.com`) following the wizard: **Users → Active users → Add a user**.

### 3.1 Global Administrator (Pre-existing)

The Global Admin account was created automatically during tenant signup (see [A.1 Tenant Overview](tenant-overview.md)).

---

### 3.2 User Administrator — Sarah Mitchell

**Procedure:**

1. Navigate to **Users → Active users → Add a user**.
2. **Set up the basics:**
   - First name: Sarah
   - Last name: Mitchell
   - Display name: Sarah Mitchell
   - Username: `smitchell`
   - Domain: `faiziitlab.onmicrosoft.com`
   - Automatically create a password: **Enabled**
   - Require password change at next sign-in: **Enabled**
   ![[media/Pasted image 20260507194013.png]]
   ![[media/Pasted image 20260507194219.png]]
3. **Assign product licences:**
   - Select location: **Belgium**
   - Assign: **Microsoft 365 Business Premium**
   - Create user without product licence: **Unchecked**
   ![[media/Pasted image 20260507194316.png]]
   ![[media/Pasted image 20260507194340.png]]

4. **Optional settings — Roles:**
   - Select role: **User Administrator**
   - Admin center access: Limited (only user management)
   ![[media/Pasted image 20260507194407.png]]
   ![[media/Pasted image 20260507194455.png]]

5. **Review and finish:**
   - Verify display name, username, licences, and role assignment.
   - Click **Finish adding**.
   ![[media/Pasted image 20260507194604.png]]
   ![[media/Pasted image 20260507194622.png]]

6. **Result:** Sarah Mitchell appears in Active users with the User Administrator role and Business Premium licence.
   ![[media/Pasted image 20260507194631.png]]

---

### 3.3 User Administrator — James Kowalski

**Procedure:**

1. **Set up the basics:**
   - First name: James
   - Last name: Kowalski
   - Display name: James Kowalski
   - Username: `jkowalski`
   ![[media/Pasted image 20260507194648.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507194658.png]]

3. **Optional settings — Roles:**
   - Select role: **User Administrator**
   ![[media/Pasted image 20260507194708.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507194715.png]]
   ![[media/Pasted image 20260507194726.png]]

---

### 3.4 Standard User — Emma Larsson (Development)

**Procedure:**

1. **Set up the basics:**
   - First name: Emma
   - Last name: Larsson
   - Display name: Emma Larsson
   - Username: `elarsson`
   ![[media/Pasted image 20260507194733.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507233756.png]]

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![[media/Pasted image 20260507195210.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507195218.png]]
   ![[media/Pasted image 20260507233717.png]]

---

### 3.5 Standard User — David Okonkwo (Development)

**Procedure:**

1. **Set up the basics:**
   - First name: David
   - Last name: Okonkwo
   - Display name: David Okonkwo
   - Username: `dokonkwo`
   ![[media/Pasted image 20260507195234.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507195241.png]]

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![[media/Pasted image 20260507195247.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507195254.png]]
   ![[media/Pasted image 20260507195302.png]]

---

### 3.6 Standard User — Lisa Vandenberg (Marketing)

**Procedure:**

1. **Set up the basics:**
   - First name: Lisa
   - Last name: Vandenberg
   - Display name: Lisa Vandenberg
   - Username: `lvandenberg`
   ![[media/Pasted image 20260507195314.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507234622.png]]

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![[media/Pasted image 20260507234635.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507195333.png]]
   ![[media/Pasted image 20260507195339.png]]

---

### 3.7 Standard User — Marco Rossi (Sales)

**Procedure:**

1. **Set up the basics:**
   - First name: Marco
   - Last name: Rossi
   - Display name: Marco Rossi
   - Username: `mrossi`
   ![[media/Pasted image 20260507233436.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507195419.png]]

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![[media/Pasted image 20260507195425.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507195432.png]]
   ![[media/Pasted image 20260507195441.png]]

---

### 3.8 Standard User — Fatima Al-Hassan (HR)

**Procedure:**

1. **Set up the basics:**
   - First name: Fatima
   - Last name: Al-Hassan
   - Display name: Fatima Al-Hassan
   - Username: `falhassan`
   ![[media/Pasted image 20260507195451.png]]

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![[media/Pasted image 20260507195456.png]]

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![[media/Pasted image 20260507195503.png]]

4. **Review and finish:**
   ![[media/Pasted image 20260507195508.png]]
   ![[media/Pasted image 20260507195514.png]]

---

### 3.9 Guest User — Thomas Berger (External Consultant)

**Procedure:**

1. **Set up the basics:**
   - First name: Thomas
   - Last name: Berger
   - Display name: Thomas Berger
   - Username: `tberger`
   - No licence assigned (Guest users consume no paid licences)
   - Select role: **Guest Inviter**
   ![[media/Pasted image 20260507232415.png]]

2. **Confirmation:**

   ![[media/Pasted image 20260507232820.png]]
   
---

### 3.10 Guest User — Yuki Tanaka (External Auditor)

**Procedure:**

1. **Set up the basics:**
   - First name: Yuki
   - Last name: Tanaka
   - Display name: Yuki Tanaka
   - Username: `ytanaka`
   - No licence assigned
   - Select role: **Guest Inviter** 
   ![[media/Pasted image 20260507232957.png]]

2. **Confirmation:**
   ![[media/Pasted image 20260507233101.png]]

---

## 4. Final Active Users Overview

After all accounts were created, the **Active users** page in the Microsoft 365 admin center displayed the complete user directory:
![[media/Pasted image 20260507233221.png]]

### 4.1 User Summary Table

| #   | Display Name     | UPN                                    | Role                 | Licence          | Status   |
| --- | ---------------- | -------------------------------------- | -------------------- | ---------------- | -------- |
| 1   | Ahmad Faizi      | ahmad@faiziitlab.onmicrosoft.com       | Global Administrator | Business Premium | ✅ Active |
| 2   | Sarah Mitchell   | smitchell@faiziitlab.onmicrosoft.com   | User Administrator   | Business Premium | ✅ Active |
| 3   | James Kowalski   | jkowalski@faiziitlab.onmicrosoft.com   | User Administrator   | Business Premium | ✅ Active |
| 4   | Emma Larsson     | elarsson@faiziitlab.onmicrosoft.com    | Standard User        | Business Premium | ✅ Active |
| 5   | David Okonkwo    | dokonkwo@faiziitlab.onmicrosoft.com    | Standard User        | Business Premium | ✅ Active |
| 6   | Lisa Vandenberg  | lvandenberg@faiziitlab.onmicrosoft.com | Standard User        | Business Premium | ✅ Active |
| 7   | Marco Rossi      | mrossi@faiziitlab.onmicrosoft.com      | Standard User        | Business Premium | ✅ Active |
| 8   | Fatima Al-Hassan | falhassan@faiziitlab.onmicrosoft.com   | Standard User        | Business Premium | ✅ Active |
| 9   | Thomas Berger    | tberger@faiziitlab.onmicrosoft.com     | Guest User           | —                | ✅ Active |
| 10  | Yuki Tanaka      | ytanaka@faiziitlab.onmicrosoft.com     | Guest User           | —                | ✅ Active |

---

## 5. Role-Based Access Control (RBAC) Summary

| Role                     | Count | Permissions                                                                    |
| ------------------------ | ----- | ------------------------------------------------------------------------------ |
| **Global Administrator** | 1     | Full control over all Microsoft 365 services and Azure AD                      |
| **User Administrator**   | 2     | Manage users, groups, licences; reset passwords; cannot manage global settings |
| **Standard User**        | 5     | End-user access to assigned apps and services; no admin privileges             |
| **Guest User**           | 2     | Limited access to shared resources; no licence consumption                     |

---

## 6. Verification Checklist

- [x] 10 test users created with distinct roles
- [x] 2 User Administrators configured for delegated management
- [x] 5 Standard Users created across multiple departments
- [x] 2 Guest Users added for external collaboration testing
- [x] Microsoft 365 Business Premium licences assigned to all internal users
- [x] Password reset enforced at first sign-in for all new accounts
- [x] All users visible and active in the Microsoft 365 admin center

---

*Document generated for Project 1 — Faizi-IT BV M365/Azure AD Administration*
