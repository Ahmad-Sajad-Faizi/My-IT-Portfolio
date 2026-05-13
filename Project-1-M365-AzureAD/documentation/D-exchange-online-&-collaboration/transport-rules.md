# Transport Rules — Disclaimers & Security Warnings

> **Lab Environment:** Microsoft 365 Business Premium — *Fazi IT Lab tenant*  
> **Focus:** Mail flow rules for external email tagging, executable attachment blocking, and organizational disclaimers.

---

## 1. Overview

This lab documents the creation of **Exchange transport rules** to enforce mail flow policies. Transport rules inspect messages as they enter or leave the organization and apply actions based on conditions. Two primary rules were configured:

1. **Tag External Emails** — Prepends `[EXTERNAL]` to subject lines for security awareness
2. **Block Executable Attachments** — Rejects emails containing dangerous file types

---

## 2. Exchange Mail Flow Rules

### 2.1 Accessing Transport Rules

Navigated to the **Mail flow > Rules** section in the Exchange admin center.

![Exchange Transport Rules Overview](assets/transport-rules/image175.png)

> **Navigation:** *Exchange admin center* → *Mail flow* → *Rules*

---

## 3. Rule 1: Tag External Emails

### 3.1 Creating the Rule

Created a transport rule to identify and tag all emails originating from outside the organization.

**Rule Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | Tag External Emails |
| **Status** | Enabled |
| **Priority** | 0 (highest) |

![Create New Transport Rule](assets/transport-rules/image176.png)

### 3.2 Rule Conditions

Configured the condition to identify external senders.

| Condition | Value |
|-----------|-------|
| **Apply this rule if** | The sender is located: **Outside the organization** |
| **Do the following** | Prepend the subject of the message with: `[EXTERNAL]` |

![Set Rule Conditions](assets/transport-rules/image177.png)

### 3.3 Sender Location Configuration

Selected "Outside the organization" to target all external email sources.

![Select Sender Location](assets/transport-rules/image178.png)

### 3.4 Subject Prefix Configuration

Configured the `[EXTERNAL]` prefix to be prepended to the subject line.

![Specify Subject Prefix](assets/transport-rules/image179.png)

### 3.5 Rule Conditions Summary

Reviewed the complete condition set before proceeding to settings.

![Rule Conditions Summary](assets/transport-rules/image180.png)

### 3.6 Review and Create

Final review of the "Tag External Emails" rule.

![Review and Finish Tag External Emails](assets/transport-rules/image181.png)

### 3.7 Rule Created Successfully

The rule was created and enabled in the transport rules list.

![Tag External Emails Rule Created](assets/transport-rules/image182.png)

### 3.8 Rule Details View

Detailed view showing the rule configuration and status.

![Tag External Emails Details](assets/transport-rules/image183.png)

---

## 4. Rule 2: Block Executable Attachments

### 4.1 Creating the Security Rule

Created a second transport rule to block emails containing executable file attachments.

**Rule Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | Block Executable Attachments |
| **Status** | Enabled |
| **Priority** | 1 |

![Block Executable Attachments Rule](assets/transport-rules/image184.png)

### 4.2 Rule Conditions

Configured conditions to detect dangerous file types.

| Condition | Value |
|-----------|-------|
| **Apply this rule if** | Any attachment: file extension matches `.exe`, `.bat`, `.cmd`, `.js`, `.vbs`, `.ps1` |
| **Do the following** | Reject the message with the explanation: *"Emails with executable attachments are blocked for security reasons"* |

![Set Rule Conditions for Block Executable](assets/transport-rules/image185.png)

### 4.3 Rule Settings

Configured the rejection message and severity level.

| Setting | Value |
|---------|-------|
| **Rule mode** | Enforce |
| **Severity** | High |
| **Match sender address in message** | Header |

![Set Rule Settings](assets/transport-rules/image188.png)

### 4.4 Review and Create

Final review of the "Block Executable Attachments" rule.

![Review Block Executable Rule](assets/transport-rules/image186.png)

### 4.5 Rule Created Successfully

The security rule was created and enabled.

![Block Executable Rule Created](assets/transport-rules/image187.png)

---

## 5. Transport Rules Dashboard

### 5.1 All Rules Overview

Reviewed the complete list of configured transport rules.

| Rule Name | Status | Priority | Action |
|-----------|--------|----------|--------|
| Tag External Emails | Enabled | 0 | Prepend `[EXTERNAL]` to subject |
| Block Executable Attachments | Enabled | 1 | Reject message with explanation |

![Transport Rules List](assets/transport-rules/image189.png)

---

## 6. Key Takeaways

| Lesson | Detail |
|--------|--------|
| **External Email Tagging** | Prepending `[EXTERNAL]` trains users to treat external emails with caution, reducing phishing success rates. |
| **Attachment Blocking** | Blocking executables at the transport layer prevents malware delivery before it reaches user inboxes. |
| **Rule Priority** | Priority 0 rules execute first. Order matters when multiple rules could apply to the same message. |
| **Enforce vs. Test Mode** | Use "Test with Policy Tips" initially to measure impact before enforcing blocking rules. |
| **NDR Messaging** | Clear rejection explanations help legitimate senders understand why their email was blocked. |

---

## 7. Production Recommendations

- **Additional File Types:** Extend the blocked attachment list to include `.zip`, `.rar`, `.iso` if your organization doesn't legitimately exchange compressed files.
- **Safe Senders:** Create an exception list for trusted partners who legitimately send executable files (e.g., software vendors).
- **Policy Tips:** Use Policy Tips in test mode to warn users about policy violations without blocking legitimate business.
- **Audit Logging:** Enable message tracking to monitor rule effectiveness and identify false positives.
- **Disclaimer Rule:** Add a third transport rule to append legal disclaimers to all outbound emails for compliance.

---

## 8. References

- [Exchange Transport Rules](https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/mail-flow-rules)
- [Mail Flow Rule Conditions and Exceptions](https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/conditions-and-exceptions)
- [Mail Flow Rule Actions](https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/actions)
- [Block Attachments with Transport Rules](https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/inspect-message-attachments)
- [Add Disclaimers to Outbound Email](https://learn.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/disclaimers-signatures-footers-or-headers)

---

*Lab completed: Exchange Online tenant (Fazi IT Lab) with transport rules for external email tagging and executable attachment blocking.*
