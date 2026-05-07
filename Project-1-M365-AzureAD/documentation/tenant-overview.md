# A.1 — Tenant Overview

> **Project:** Faizi-IT BV — Microsoft 365 & Azure AD Administration  
> **Section:** A. Tenant Setup & User Management  
> **Document:** Tenant Overview (Creation, Domain, Licences)

---

## 1. Objective

Establish a fully functional Microsoft 365 tenant for the fictional company **Faizi-IT BV**. This includes signing up for the Microsoft 365 Developer Program, configuring the default `.onmicrosoft.com` domain, and assigning the appropriate licences to enable cloud identity and collaboration services.

---

## 2. Prerequisites

| Requirement | Details |
|-------------|---------|
| Microsoft Account | Personal Microsoft account for program signup |
| Phone Number | Required for SMS verification (Belgium +32 used) |
| Valid Email | For order confirmations and tenant notifications |

---

## 3. Step-by-Step Implementation

### 3.1 Sign Up for the Microsoft 365 Developer Program

The Microsoft 365 Developer Program provides a free sandbox environment with **25 user licences** (Microsoft 365 E5 Developer) and a 90-day renewable subscription — ideal for lab and portfolio work.

**Procedure:**

1. Navigate to [developer.microsoft.com/microsoft-365/dev-program](https://developer.microsoft.com/en-us/microsoft-365/dev-program).
2. Click **"Join now"** and sign in with a personal Microsoft account.
3. Complete the profile questionnaire:
   - **Primary focus:** Personal projects
   - **Areas of interest:** Microsoft Graph, Microsoft Identity platform, Microsoft Teams, Outlook, Power Platform
   - **Country/Region:** Belgium

   ![Developer Program Signup — Profile]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172108.png")
   ![Developer Program — Focus Areas]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172127.png")
   ![Developer Program — Interests]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172135.png")
   ![Developer Program — Phone Verification]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172145.png")

4. After verification, the tenant dashboard loads. The subscription is provisioned automatically.

   ![Developer Program — Welcome Dashboard]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172213.png")

### 3.2 Subscribe to Microsoft 365 Business Premium

To simulate a realistic SMB environment, a **Microsoft 365 Business Premium** trial was also activated via the Microsoft 365 admin center.

**Procedure:**

1. From the admin center, navigate to **Billing → Purchase services**.
2. Select **Microsoft 365 Business Premium** → Start free trial (1 month).
3. Configure sign-in details:
   - **Username:** Ahmad
   - **Domain:** FaiziITLab
   - **Full domain:** `Ahmad@FaiziITLab.onmicrosoft.com`

   ![Business Premium — Trial Selection]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172242.png")
   ![Business Premium — Sign-in Details]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172258.png")
   ![Business Premium — Account Setup]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172306.png")
   ![Business Premium — Organisation Details]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172316.png")
   ![Business Premium — Username Configuration]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172343.png")

4. Review the order summary and confirm. The tenant is now dual-licenced (E5 Developer + Business Premium).

   ![Business Premium — Order Review]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172356.png")
   ![Business Premium — Confirmation]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172410.png")

### 3.3 Secure the Global Administrator Account

Immediately after tenant creation, MFA was enforced on the Global Admin account using the Microsoft Authenticator app.

**Procedure:**

1. During first sign-in, a prompt requires **"Add extra security to your account"**.
2. Select **Microsoft Authenticator app** → Download from App Store / Google Play.
3. Scan the QR code displayed on screen with the mobile app.
4. Confirm the Authenticator is added and set as the default sign-in method.

   ![MFA Setup — Add Security]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172423.png")
   ![MFA Setup — Install Authenticator]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172434.png")
   ![MFA Setup — Configure in App]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172443.png")
   ![MFA Setup — Scan QR Code]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172452.png")
   ![MFA Setup — Authenticator Added]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172501.png")
   ![MFA Setup — Stay Signed In]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172512.png")

5. Sign in to the **Microsoft 365 admin center** (`admin.microsoft.com`) to verify tenant health.

   ![Admin Center — First Login]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172522.png")
   ![Admin Center — Dashboard]("Project-1-M365-AzureAD/documentation/media/Pasted%20image%2020260507172531.png")

---

## 4. Tenant Configuration Summary

| Property            | Value                                            |
| ------------------- | ------------------------------------------------ |
| **Tenant Name**     | Faizi-IT BV                                      |
| **Default Domain**  | faiziitlab.onmicrosoft.com                       |
| **Global Admin**    | Ahmad Faizi (Ahmad@FaiziITLab.onmicrosoft.com)   |
| **Subscription 1**  | Microsoft 365 E5 Developer (25 licences)         |
| **Subscription 2**  | Microsoft 365 Business Premium Trial (1 licence) |
| **Tenant Location** | Belgium (EU)                                     |
| **MFA Status**      | Enabled on Global Admin                          |

---

## 5. Licences Assigned

| Licence                        | Quantity | Purpose                            |
| ------------------------------ | -------- | ---------------------------------- |
| Microsoft 365 E5 Developer     | 25       | Lab users, testing, development    |
| Microsoft 365 Business Premium | 1        | Primary admin, full service access |

> **Note:** The E5 Developer subscription includes Azure AD Premium P2, enabling advanced security features such as Conditional Access and Identity Protection. The Business Premium subscription provides the SMB-oriented feature set (Intune, Exchange Online, Teams).

---

## 6. Verification Checklist

- [x] Microsoft 365 Developer Tenant created and active
- [x] Microsoft 365 Business Premium trial activated
- [x] Default `.onmicrosoft.com` domain configured (`faiziitlab.onmicrosoft.com`)
- [x] Global Administrator account secured with MFA
- [x] Admin center accessible and functional

---

*Document generated for Project 1 — Faizi-IT BV M365/Azure AD Administration*
