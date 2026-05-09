# A.3 — Dynamic Groups

> **Project:** Faizi-IT BV — Microsoft 365 & Azure AD Administration  
> **Section:** A. Tenant Setup & User Management  
> **Document:** Dynamic Group Rules and Membership Logic

---

## 1. Objective

Implement **Azure AD Dynamic Groups** to automate user membership based on user attributes (department and location). This eliminates manual group management and ensures that users are automatically assigned to the correct groups as soon as their profile is updated — a critical capability for scalable identity management.

---

## 2. Dynamic Group Planning

The following dynamic groups were designed to align with the organisational structure of Faizi-IT BV:

| Group Name | Membership Rule | Purpose |
|-----------|-----------------|---------|
| **All Company** | `(user.accountEnabled -eq true)` | Organisation-wide communications |
| **IT Department** | `(user.department -eq "IT")` | IT staff access and notifications |
| **Development Team** | `(user.department -eq "Development")` | Dev team resources and collaboration |
| **Marketing Team** | `(user.department -eq "Marketing")` | Marketing resources and campaigns |
| **Sales Team** | `(user.department -eq "Sales")` | Sales tools and CRM access |
| **HR Department** | `(user.department -eq "HR")` | HR tools and confidential resources |
| **EU Employees** | `(user.usageLocation -eq "BE")` | EU-based compliance and policy targeting |
| **Licensed Users** | `(user.assignedPlans -any (assignedPlan.servicePlanId -eq "f245ecc8-75af-4f8e-b61f-27d8114de5f3"))` | Users with Business Premium licences |

> **Note:** The `usageLocation` attribute is set to **BE** (Belgium) for all internal users during licence assignment. Guest users do not have a usage location set, so they are excluded from EU-specific policies automatically.

---

## 3. Prerequisites

- Azure AD Premium P1 or P2 licence (included with Microsoft 365 Business Premium and E5 Developer)
- User accounts must have the `department` and `usageLocation` attributes populated
- Global Administrator or Groups Administrator role

---

## 4. Step-by-Step Implementation

### 4.1 Verify User Attributes

Before creating dynamic groups, ensure that user profiles contain the required attributes. In the Microsoft 365 admin center:

1. Navigate to **Users → Active users**.
2. Select a user (e.g., Emma Larsson) → **Manage contact information**.
3. Verify the **Department** field is populated:
   - Emma Larsson → `Development`
   - Lisa Vandenberg → `Marketing`
   - Marco Rossi → `Sales`
   - Fatima Al-Hassan → `HR`
   - Sarah Mitchell / James Kowalski → `IT`

> **Tip:** These values were set during user creation in the "Optional settings" step. If missing, they can be edited via **Azure AD admin center → Users → Profile → Edit**.

---

### 4.2 Create the "EU Employees" Dynamic Group

This group is critical for the **Conditional Access policy** that blocks non-EU sign-ins (see Section B).

**Procedure:**

1. Navigate to **Microsoft Entra admin center** (`entra.microsoft.com`) → **Identity** → **Groups** → **All groups**.

2. Click **New group**.

3. Configure the group:
   - **Group type:** Security
   - **Group name:** `EU Employees`
   - **Membership type:** Dynamic User
   - **Microsoft Entra roles can be assigned to the group:** No

   ![[media/Pasted image 20260509233311.png]]

4. Click **Edit dynamic query**.

5. Configure the dynamic rule:
   - **Property:** usageLocation
   - **Operator:** Equals
   - **Value:** BE
   - **Rule syntax:** `(user.usageLocation -eq "BE")`

   ![[media/Pasted image 20260509233352.png]]

6. Click **Validate** to test the rule against existing users, then **Save**.

7. Click **Create** to finalize the group.

   ![[media/Pasted image 20260509233419.png]]

8. The group overview page confirms the configuration:
   - **Membership type:** Dynamic
   - **Type:** Security
   - **Created on:** 09/05/2026

   ![[media/Pasted image 20260509233445.png]]

> **Note:** The member count shows **0** immediately after creation because dynamic group membership evaluation takes time to process. After the rule is evaluated (typically within a few minutes to 24 hours), all internal users with `usageLocation = BE` will be automatically added.

---

### 4.3 Create Department-Based Dynamic Groups

Repeat the same process for each department using **Security** group type and **Dynamic User** membership:

#### IT Department
```
(user.department -eq "IT")
```
**Expected members:** Ahmad Faizi, Sarah Mitchell, James Kowalski

#### Development Team
```
(user.department -eq "Development")
```
**Expected members:** Emma Larsson, David Okonkwo

#### Marketing Team
```
(user.department -eq "Marketing")
```
**Expected members:** Lisa Vandenberg

#### Sales Team
```
(user.department -eq "Sales")
```
**Expected members:** Marco Rossi

#### HR Department
```
(user.department -eq "HR")
```
**Expected members:** Fatima Al-Hassan

---

### 4.4 Create the "All Company" Dynamic Group

- **Group type:** Security
- **Membership type:** Dynamic User
- **Rule:**
  ```
  (user.accountEnabled -eq true) and (user.userType -eq "Member")
  ```

> **Note:** The second condition `(user.userType -eq "Member")` excludes guest users from the organisation-wide group.

---

### 4.5 Create the "Licensed Users" Dynamic Group

This group targets all users with an active Microsoft 365 Business Premium licence.

- **Group type:** Security
- **Membership type:** Dynamic User
- **Rule:**
  ```
  (user.assignedPlans -any (assignedPlan.servicePlanId -eq "f245ecc8-75af-4f8e-b61f-27d8114de5f3"))
  ```

**Expected members:** All 8 internal users with Business Premium licences.

---

## 5. Existing Groups vs. New Dynamic Groups

During the project, two types of groups were created:

| Group | Type | Membership | Created In | Purpose |
|-------|------|-----------|------------|---------|
| **All Company** | Microsoft 365 | Assigned | M365 admin center | Teams collaboration |
| **Faizi IT Lab** | Microsoft 365 | Assigned | M365 admin center | Team workspace |
| **IT Department** | Microsoft 365 | Assigned | M365 admin center | Team collaboration |
| **EU Employees** | Security | **Dynamic** | Entra admin center | Conditional Access targeting |
| **IT Department** | Security | **Dynamic** | Entra admin center | Policy & resource access |
| **Development Team** | Security | **Dynamic** | Entra admin center | Dev resource access |

> **Important:** Microsoft 365 groups (created in the M365 admin center) support **Assigned** membership only. For dynamic membership, **Security** groups must be created in the **Microsoft Entra admin center**.

---

## 6. Dynamic Group Membership Verification

After creation, verify membership by navigating to **Microsoft Entra admin center → Groups → [Group Name] → Members**.

### 6.1 Membership Summary

| Group | Rule | Expected Members | Status |
|-------|------|-----------------|--------|
| All Company | `accountEnabled -eq true` | 8 internal users | ✅ Dynamic |
| IT Department | `department -eq "IT"` | 3 users | ✅ Dynamic |
| Development Team | `department -eq "Development"` | 2 users | ✅ Dynamic |
| Marketing Team | `department -eq "Marketing"` | 1 user | ✅ Dynamic |
| Sales Team | `department -eq "Sales"` | 1 user | ✅ Dynamic |
| HR Department | `department -eq "HR"` | 1 user | ✅ Dynamic |
| EU Employees | `usageLocation -eq "BE"` | 8 internal users | ✅ Dynamic |
| Licensed Users | `assignedPlans` contains Business Premium | 8 users | ✅ Dynamic |

---

## 7. Use Cases for Dynamic Groups

| Group | Applied To | Benefit |
|-------|-----------|---------|
| **All Company** | Org-wide Teams announcements, company newsletters | Everyone receives updates automatically |
| **IT Department** | Admin portal access, elevated support tickets | Only IT staff get admin notifications |
| **Department Groups** | Team-specific SharePoint sites, Teams channels | New hires auto-joined to relevant teams |
| **EU Employees** | Conditional Access — Block Non-EU | Ensures only EU staff bypass geo-blocks |
| **Licensed Users** | Intune device policies, app deployments | Only paid users receive managed apps |

---

## 8. Troubleshooting Dynamic Membership

### Issue: User not appearing in a dynamic group
**Cause:** User attribute does not match the rule expression.  
**Resolution:**
1. Go to **Microsoft Entra admin center → Users → [User] → Edit**.
2. Verify the `department` or `usageLocation` field.
3. Wait up to **24 hours** for Azure AD to re-evaluate membership, or force a refresh via **Groups → [Group] → Reevaluate**.

### Issue: Guest users included in "All Company"
**Cause:** Rule `(user.accountEnabled -eq true)` includes all enabled accounts.  
**Resolution:** Modify the rule to exclude guests:
```
(user.accountEnabled -eq true) and (user.userType -eq "Member")
```

### Issue: Dynamic group shows 0 members immediately after creation
**Cause:** Membership evaluation is asynchronous and takes time.  
**Resolution:** Wait 5–30 minutes and refresh. For urgent testing, click **Reevaluate** on the group page.

---

## 9. Verification Checklist

- [x] Dynamic groups created for all departments
- [x] `department` attribute populated on all standard users
- [x] `usageLocation` set to **BE** for all internal users
- [x] "EU Employees" group created with Security type and Dynamic User membership
- [x] "EU Employees" group excludes guest users via `usageLocation` rule
- [x] "Licensed Users" group correctly targets Business Premium subscribers
- [x] Membership auto-updates verified by checking group overview
- [x] Groups ready for Conditional Access and Intune policy targeting

---

*Document generated for Project 1 — Faizi-IT BV M365/Azure AD Administration*
