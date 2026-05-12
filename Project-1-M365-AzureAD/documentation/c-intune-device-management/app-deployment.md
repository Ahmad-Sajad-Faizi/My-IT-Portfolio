# App Deployment via Intune

> **Lab Environment:** Microsoft 365 Business Premium — *Fazi IT Lab tenant*  
> **Focus:** Deploying required applications through Microsoft Intune using Win32 app packaging and Microsoft 365 Apps.

---

## 1. Overview

This lab documents the deployment of business-critical applications via **Microsoft Intune**. Two primary deployment methods were used:
1. **Microsoft 365 Apps** (built-in Office suite deployment)
2. **Win32 apps** (custom line-of-business applications packaged with the Microsoft Win32 Content Prep Tool)

---

## 2. Microsoft 365 Apps Deployment

### 2.1 Adding Microsoft 365 Apps

Started by adding the Microsoft 365 Apps suite from the Intune app catalog.

![Add Microsoft 365 Apps](assets/app-deployment/image145.png)

**App Suite Information:**
| Attribute | Value |
|-----------|-------|
| **Suite Name** | Microsoft 365 Apps for Windows 10 and later |
| **Description** | Microsoft 365 Apps for Windows 10 and later |
| **Publisher** | Microsoft |
| **Category** | Productivity |
| **Show this as a featured app** | No |

### 2.2 Configuring the App Suite

Selected the Office apps to include in the deployment and configured update settings.

![Configure App Suite](assets/app-deployment/image146.png)

**Configuration Settings:**
| Setting | Value |
|---------|-------|
| **Select Office apps** | 8 selected (Access, Excel, OneNote, Outlook, PowerPoint, Publisher, Teams, Word) |
| **Select other Office apps (license required)** | 0 selected |
| **Architecture** | 64-bit |
| **Default file format** | Office Open XML Format |
| **Update channel** | Monthly Enterprise Channel |
| **Remove other versions** | Yes |
| **Use shared computer activation** | No |
| **Accept the Microsoft Software License Terms on behalf of users** | Yes |
| **Install background service for Microsoft Search in Bing** | No |
| **Languages** | 2 languages selected |

### 2.3 Assignments

Configured the deployment assignments for the Microsoft 365 Apps suite.

| Assignment Type | Group | Status |
|----------------|-------|--------|
| **Required** | All users | Active |
| **Available for enrolled devices** | — | No assignments |
| **Uninstall** | — | No assignments |

![Microsoft 365 Apps Assignments](assets/app-deployment/image147.png)

### 2.4 Review and Create

Reviewed the complete app configuration before deployment.

![Review Microsoft 365 Apps](assets/app-deployment/image148.png)

### 2.5 Deployment Monitoring

Monitored the deployment status through the Intune app overview page.

![Microsoft 365 Apps Overview](assets/app-deployment/image149.png)

---

## 3. Win32 App Deployment (Google Chrome)

### 3.1 Downloading the Win32 Content Prep Tool

Downloaded the **Microsoft Win32 Content Prep Tool** from GitHub to package the Google Chrome installer into the `.intunewin` format required by Intune.

![Win32 Content Prep Tool GitHub](assets/app-deployment/image151.png)

### 3.2 Preparing the App Package

Extracted the Win32 Content Prep Tool and prepared the Google Chrome installer files.

![Win32 Content Prep Tool Files](assets/app-deployment/image152.png)

**Package Contents:**
| File | Purpose |
|------|---------|
| `IntuneWinAppUtil.exe` | Tool to convert installers to `.intunewin` format |
| `README.md` | Documentation |
| `ReleaseNotes.txt` | Version notes |

### 3.3 Packaging Google Chrome

Used the Win32 Content Prep Tool to create the Intune-ready package for Google Chrome.

![Google Chrome Package File](assets/app-deployment/image153.png)

**Package Details:**
| Attribute | Value |
|-----------|-------|
| **App package file** | `googlechromeenterpriseinstaller64.intunewin` |
| **Name** | Google Chrome |
| **Platform** | Windows |
| **App version** | 146.0.7000.165 |
| **MAM Enabled** | No |

### 3.4 App Information

Configured the app metadata in Intune.

![Google Chrome App Information](assets/app-deployment/image154.png)

| Setting | Value |
|---------|-------|
| **Name** | Google Chrome |
| **Description** | Google Chrome |
| **Publisher** | Google |
| **App Version** | 146.0.7000.165 |
| **Category** | Productivity |
| **Show this as a featured app** | No |

### 3.5 Program Configuration

Defined the install and uninstall commands for the Win32 app.

![Google Chrome Program Configuration](assets/app-deployment/image155.png)

| Setting | Value |
|---------|-------|
| **Install command** | `msiexec /i "googlechromeenterpriseinstaller64.msi" /qn` |
| **Uninstall command** | `msiexec /x "{7F3C31781-14AA-3C78-A1A1-4074C5C34181}" /qn` |
| **Install behavior** | System |
| **Device restart behavior** | App install may force a device restart |
| **Installation time required (mins)** | 60 |

**Return Codes:**
| Code | Type |
|------|------|
| 0 | Success |
| 1707 | Success |
| 3010 | Soft reboot |
| 1641 | Hard reboot |
| 1618 | Retry |

### 3.6 Requirements

Set the device requirements that must be met before the app can be installed.

![Google Chrome Requirements](assets/app-deployment/image156.png)

| Requirement | Value |
|-------------|-------|
| **Operating system architecture** | 64-bit |
| **Minimum operating system** | Windows 10 1607 |
| **Disk space required (MB)** | — |
| **Physical memory required (MB)** | — |
| **Minimum number of logical processors required** | — |
| **Minimum CPU speed required (MHz)** | — |

### 3.7 Detection Rules

Configured detection rules to verify successful installation.

### 3.8 Dependencies and Supersedence

Reviewed app dependencies and supersedence settings.

![Google Chrome Supersedence](assets/app-deployment/image170.png)

### 3.9 Assignments

Assigned Google Chrome as a **Required** app for all users.

![Google Chrome Assignments](assets/app-deployment/image160.png)

### 3.10 Review and Create

Final review of the Google Chrome Win32 app before deployment.

![Review Google Chrome App](assets/app-deployment/image161.png)

---

## 4. App Management Dashboard

### 4.1 All Apps Overview

Reviewed the complete list of deployed applications in the Intune admin center.

![All Apps List](assets/app-deployment/image143.png)

### 4.2 Line-of-Business App

Added a custom line-of-business app (7-Zip) using the Win32 packaging method.

![Add Line-of-Business App](assets/app-deployment/image150.png)

### 4.3 App Selective Wipe

Configured app selective wipe capabilities for managed apps.

![App Selective Wipe](assets/app-deployment/image157.png)

---

## 5. Key Takeaways

| Lesson | Detail |
|--------|--------|
| **Win32 Packaging** | The Microsoft Win32 Content Prep Tool is essential for converting traditional `.msi` and `.exe` installers into Intune-compatible `.intunewin` packages. |
| **Return Codes** | Properly configuring install return codes (0=Success, 3010=Soft reboot) ensures Intune correctly interprets deployment results. |
| **Detection Rules** | Without accurate detection rules, Intune cannot confirm installation success and will retry indefinitely. |
| **System vs. User Context** | Installing in **System** context ensures the app is available to all users on the device. |
| **Supersedence** | Use supersedence to automatically upgrade or replace older app versions without manual redeployment. |

---

## 6. Production Recommendations

- **App Dependencies:** Define dependencies for apps that require prerequisites (e.g., .NET runtime, Visual C++ redistributables).
- **Available vs. Required:** Use **Available** assignments for optional apps users can install on-demand from the Company Portal.
- **Update Rings:** Stagger Microsoft 365 App updates using deployment rings (Pilot → Early Adopters → Broad).
- **Win32 App Size:** Keep `.intunewin` packages under 8 GB; split larger apps or use CDN-based deployment.
- **Monitoring:** Set up alerts for app installation failures via Intune reporting or Log Analytics.

---

## 7. References

- [Add Microsoft 365 Apps to Intune](https://learn.microsoft.com/en-us/mem/intune/apps/apps-add-office365)
- [Win32 App Management in Intune](https://learn.microsoft.com/en-us/mem/intune/apps/apps-win32-app-management)
- [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool)
- [Intune App Deployment Guide](https://learn.microsoft.com/en-us/mem/intune/apps/apps-deployment)
- [App Supersedence in Intune](https://learn.microsoft.com/en-us/mem/intune/apps/apps-supersedence)

---

*Lab completed: Microsoft Intune tenant (Fazi IT Lab) with Microsoft 365 Apps and Win32 app deployments configured.*
