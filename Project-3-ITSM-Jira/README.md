### PROJECT 3 README ###

# Project 3 — Ticketing & ITSM Tools

**Duration:** unkown | **Status:** Planned | **Cost:** €0

> Build a professional helpdesk system with workflows and SLAs following ITIL principles using Jira Service Management.

---

## Objective

IT support professionals need to manage incidents, service requests, and changes according to ITIL best practices. This project builds a fully functioning ticket system for "FaiziIT BV".

---

## Technologies

![Jira](https://img.shields.io/badge/Jira_Service_Management-0052CC?style=flat&logo=jira&logoColor=white)
![Confluence](https://img.shields.io/badge/Confluence-172B4D?style=flat&logo=confluence&logoColor=white)
![ITIL](https://img.shields.io/badge/ITIL_4-6B46C1?style=flat&logoColor=white)

---

## Requirements Checklist

### A. Jira Service Management Setup
- [ ] Project created: "IT Support Desk"
- [ ] Request types: Incident, Service Request, Change Request, Problem
- [ ] Custom fields: Asset tag, Affected system, Priority

### B. Workflow & Automation
- [ ] Workflow: Open → In Progress → Waiting → Resolved → Closed
- [ ] Auto-assign by category
- [ ] Escalation after 4 hours without response
- [ ] Auto-reply on ticket creation
- [ ] SLAs defined (Critical/High/Medium/Low)

### C. Knowledge Base
- [ ] 5+ self-service articles (password reset, VPN, printer, Outlook, Wi-Fi)
- [ ] Self-service portal configured

### D. Asset Management (CMDB)
- [ ] Asset schema (Computers, Monitors, Printers, Network)
- [ ] 10+ test assets entered
- [ ] Asset → ticket linking

### E. Reporting
- [ ] Dashboard (open tickets, MTTR, FCR rate, tickets per agent)
- [ ] Weekly PDF report export

---

## SLA Matrix

| Priority | Response Time | Resolution Time |
|----------|--------------|----------------|
| Critical | 15 minutes | 4 hours |
| High | 1 hour | 8 hours |
| Medium | 4 hours | 2 days |
| Low | 1 day | 5 days |

---

*Part of the [IT Portfolio 2026](../README.md) — Ahmad Sajad Faizi*
