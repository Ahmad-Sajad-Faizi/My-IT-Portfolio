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
| 2 | **Sarah Mitchell** | s.mitchell@faiziitlab.onmicrosoft.com | User Administrator | IT / Support | M365 Business Premium | Admin |
| 3 | **James Kowalski** | j.kowalski@faiziitlab.onmicrosoft.com | User Administrator | IT / Security | M365 Business Premium | Admin |
| 4 | **Emma Larsson** | e.larsson@faiziitlab.onmicrosoft.com | Standard User | Development | M365 Business Premium | Member |
| 5 | **David Okonkwo** | d.okonkwo@faiziitlab.onmicrosoft.com | Standard User | Development | M365 Business Premium | Member |
| 6 | **Lisa Vandenberg** | l.vandenberg@faiziitlab.onmicrosoft.com | Standard User | Marketing | M365 Business Premium | Member |
| 7 | **Marco Rossi** | m.rossi@faiziitlab.onmicrosoft.com | Standard User | Sales | M365 Business Premium | Member |
| 8 | **Fatima Al-Hassan** | f.alhassan@faiziitlab.onmicrosoft.com | Standard User | HR | M365 Business Premium | Member |
| 9 | **Thomas Berger** | t.berger@faiziitlab.onmicrosoft.com | Guest User | External Consultant | — | Guest |
| 10 | **Yuki Tanaka** | y.tanaka@faiziitlab.onmicrosoft.com | Guest User | External Auditor | — | Guest |

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
   - Username: `s.mitchell`
   - Domain: `faiziitlab.onmicrosoft.com`
   - Automatically create a password: **Enabled**
   - Require password change at next sign-in: **Enabled**
   ![Add User — Sarah Mitchell Basics](media/Pasted%20image%2020260507194013.png)
   ![Add User — Sarah Mitchell Basics](media/Pasted%20image%2020260507194219.png)
3. **Assign product licences:**
   - Select location: **Belgium**
   - Assign: **Microsoft 365 Business Premium**
   - Create user with product licence: **checked**
   ![Add User — Sarah Mitchell Licences](media/Pasted%20image%2020260507194316.png)
   ![Add User — Sarah Mitchell Licence Confirm](media/Pasted%20image%2020260507194340.png)

4. **Optional settings — Roles:**
   - Select role: **User Administrator**
   ![Add User — Sarah Mitchell Roles](media/Pasted%20image%2020260507194407.png)
   ![Add User — Sarah Mitchell Optional Settings](media/Pasted%20image%2020260507194455.png)

5. **Review and finish:**
   - Verify display name, username, licences, and role assignment.
   - Click **Finish adding**.
   ![Add User — Sarah Mitchell Review](media/Pasted%20image%2020260507194604.png)
   ![Add User — Sarah Mitchell Success](media/Pasted%20image%2020260507194622.png)

6. **Result:** Sarah Mitchell appears in Active users with the User Administrator role and Business Premium licence.
   ![Active Users — Sarah Mitchell Profile](media/Pasted%20image%2020260507194631.png)

---

### 3.3 User Administrator — James Kowalski

**Procedure:**

1. **Set up the basics:**
   - First name: James
   - Last name: Kowalski
   - Display name: James Kowalski
   - Username: `j.kowalski`
   ![Add User — James Kowalski Basics](media/Pasted%20image%2020260507194648.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — James Kowalski Licences](media/Pasted%20image%2020260507194658.png)

3. **Optional settings — Roles:**
   - Select role: **User Administrator**
   ![Add User — James Kowalski Roles](media/Pasted%20image%2020260507194708.png)

4. **Review and finish:**
   ![Add User — James Kowalski Review](media/Pasted%20image%2020260507194715.png)
   ![Add User — James Kowalski Success](media/Pasted%20image%2020260507194726.png)

---

### 3.4 Standard User — Emma Larsson (Development)

**Procedure:**

1. **Set up the basics:**
   - First name: Emma
   - Last name: Larsson
   - Display name: Emma Larsson
   - Username: `e.larsson`
   ![Add User — Emma Larsson Basics](media/Pasted%20image%2020260507194733.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — Emma Larsson Licences](media/Pasted%20image%2020260507233756.png)

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![Add User — Emma Larsson Roles](media/Pasted%20image%2020260507195210.png)

4. **Review and finish:**
   ![Add User — Emma Larsson Review](media/Pasted%20image%2020260507195218.png)
   ![Add User — Emma Larsson Success](media/Pasted%20image%2020260507233717.png)

---

### 3.5 Standard User — David Okonkwo (Development)

**Procedure:**

1. **Set up the basics:**
   - First name: David
   - Last name: Okonkwo
   - Display name: David Okonkwo
   - Username: `d.okonkwo`
   ![Add User — David Okonkwo Basics](media/Pasted%20image%2020260507195234.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — David Okonkwo Licences](media/Pasted%20image%2020260507195241.png)

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![Add User — David Okonkwo Roles](media/Pasted%20image%2020260507195247.png)

4. **Review and finish:**
   ![Add User — David Okonkwo Review](media/Pasted%20image%2020260507195254.png)
   ![Add User — David Okonkwo Success](media/Pasted%20image%2020260507195302.png)

---

### 3.6 Standard User — Lisa Vandenberg (Marketing)

**Procedure:**

1. **Set up the basics:**
   - First name: Lisa
   - Last name: Vandenberg
   - Display name: Lisa Vandenberg
   - Username: `l.vandenberg`
   ![Add User — Lisa Vandenberg Basics](media/Pasted%20image%2020260507195314.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — Lisa Vandenberg Licences](media/Pasted%20image%2020260507234622.png)

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![Add User — Lisa Vandenberg Roles](media/Pasted%20image%2020260507234635.png)

4. **Review and finish:**
   ![Add User — Lisa Vandenberg Review](media/Pasted%20image%2020260507195333.png)
   ![Add User — Lisa Vandenberg Success](media/Pasted%20image%2020260507195339.png)

---

### 3.7 Standard User — Marco Rossi (Sales)

**Procedure:**

1. **Set up the basics:**
   - First name: Marco
   - Last name: Rossi
   - Display name: Marco Rossi
   - Username: `m.rossi`
   ![Add User — Marco Rossi Basics](media/Pasted%20image%2020260507233436.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — Marco Rossi Licences](media/Pasted%20image%2020260507195419.png)

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![Add User — Marco Rossi Roles](media/Pasted%20image%2020260507195425.png)

4. **Review and finish:**
   ![Add User — Marco Rossi Review](media/Pasted%20image%2020260507195432.png)
   ![Add User — Marco Rossi Success](media/Pasted%20image%2020260507195441.png)

---

### 3.8 Standard User — Fatima Al-Hassan (HR)

**Procedure:**

1. **Set up the basics:**
   - First name: Fatima
   - Last name: Al-Hassan
   - Display name: Fatima Al-Hassan
   - Username: `f.alhassan`
   ![Add User — Fatima Al-Hassan Basics](media/Pasted%20image%2020260507195451.png)

2. **Assign product licences:**
   - Location: Belgium
   - Licence: Microsoft 365 Business Premium
   ![Add User — Fatima Al-Hassan Licences](media/Pasted%20image%2020260507195456.png)

3. **Optional settings — Roles:**
   - Select role: **User** (no admin access)
   ![Add User — Fatima Al-Hassan Roles](media/Pasted%20image%2020260507195503.png)

4. **Review and finish:**
   ![Add User — Fatima Al-Hassan Review](media/Pasted%20image%2020260507195508.png)
   ![Add User — Fatima Al-Hassan Success](media/Pasted%20image%2020260507195514.png)

---

### 3.9 Guest User — Thomas Berger (External Consultant)

**Procedure:**

1. **Set up the basics:**
   - First name: Thomas
   - Last name: Berger
   - Display name: Thomas Berger
   - Username: `t.berger`
   - No licence assigned (Guest users consume no paid licences)
   - Select role: **Guest Inviter**
   ![Add User — Thomas Berger Set up](media/Pasted%20image%2020260507232415.png)

2. **Confirmation:**
   ![Add User — Thomas Berger Success](media/Pasted%20image%2020260507232820.png)
   
---

### 3.10 Guest User — Yuki Tanaka (External Auditor)

**Procedure:**

1. **Set up the basics:**
   - First name: Yuki
   - Last name: Tanaka
   - Display name: Yuki Tanaka
   - Username: `y.tanaka`
   - No licence assigned
   - Select role: **Guest Inviter** 
   ![Add User — Yuki Tanaka Set up](media/Pasted%20image%2020260507232957.png)

2. **Confirmation:**
   
   ![Add User — Yuki Tanaka Success](media/Pasted%20image%2020260507233101.png)

---

## 4. Final Active Users Overview

After all accounts were created, the **Active users** page in the Microsoft 365 admin center displayed the complete user directory:
 ![Active Users — Complete List](media/Pasted%20image%2020260507233221.png)

### 4.1 User Summary Table

| #   | Display Name     | UPN                                    | Role                 | Licence          | Status   |
| --- | ---------------- | -------------------------------------- | -------------------- | ---------------- | -------- |
| 1   | Ahmad Faizi      | ahmad@faiziitlab.onmicrosoft.com       | Global Administrator | Business Premium | ✅ Active |
| 2   | Sarah Mitchell   | s.mitchell@faiziitlab.onmicrosoft.com   | User Administrator   | Business Premium | ✅ Active |
| 3   | James Kowalski   | j.kowalski@faiziitlab.onmicrosoft.com   | User Administrator   | Business Premium | ✅ Active |
| 4   | Emma Larsson     | e.larsson@faiziitlab.onmicrosoft.com    | Standard User        | Business Premium | ✅ Active |
| 5   | David Okonkwo    | d.okonkwo@faiziitlab.onmicrosoft.com    | Standard User        | Business Premium | ✅ Active |
| 6   | Lisa Vandenberg  | l.vandenberg@faiziitlab.onmicrosoft.com | Standard User        | Business Premium | ✅ Active |
| 7   | Marco Rossi      | m.rossi@faiziitlab.onmicrosoft.com      | Standard User        | Business Premium | ✅ Active |
| 8   | Fatima Al-Hassan | f.alhassan@faiziitlab.onmicrosoft.com   | Standard User        | Business Premium | ✅ Active |
| 9   | Thomas Berger    | t.berger@faiziitlab.onmicrosoft.com     | Guest User           | —                | ✅ Active |
| 10  | Yuki Tanaka      | y.tanaka@faiziitlab.onmicrosoft.com     | Guest User           | —                | ✅ Active |

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
