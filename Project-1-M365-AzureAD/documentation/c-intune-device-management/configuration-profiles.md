# Configuration Profiles

> **Lab Environment:** Microsoft 365 Business Premium — *Fazi IT Lab tenant*  
> **Focus:** Wi-Fi auto-connect, certificate-based VPN with custom Linux VPN server, and endpoint security baselines via Microsoft Intune.

---

## 1. Overview

This lab documents the creation and deployment of **Microsoft Intune device configuration profiles** covering:
- **Wi-Fi profile** — Auto-connect corporate wireless with WPA2-Enterprise
- **Trusted certificate profile** — Deploy root CA for VPN authentication
- **VPN profile** — IKEv2 certificate-based VPN with split tunneling
- **Endpoint protection profile** — BitLocker, Defender, and firewall hardening
- **Antivirus policy** — Microsoft Defender real-time protection configuration

---

## 2. Wi-Fi Configuration Profile

### 2.1 Creating the Wi-Fi Profile

Navigated to **Dashboard > Configuration** in the Intune admin center and created a new policy.

![Windows Configuration Policies](assets/configuration-profiles/image1.png)

Selected **Windows 10 and later** platform with **Wi-Fi** template.

![Create Wi-Fi Profile](assets/configuration-profiles/image2.png)

**Profile Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | INT-WLAN-Global |
| **Description** | Corporate Wi-Fi auto-connect |
| **Platform** | Windows 10 and later |
| **Profile type** | Wi-Fi |

![Wi-Fi Profile Basics](assets/configuration-profiles/image4.png)

### 2.2 Wi-Fi Configuration Settings

Configured the wireless network parameters:

| Setting | Value |
|---------|-------|
| **Wi-Fi type** | Basic |
| **Network name (SSID)** | `FAZI-CORP-WIFI` |
| **Connect automatically when in range** | Yes |
| **Connect to more preferred network if available** | No |
| **Connect to this network, even when it is not broadcasting its SSID to SSD** | Yes |
| **Internet Connectivity Test** | Unrestricted |
| **Wireless Security Type** | WPA2/WPA3-Enterprise |
| **EAP type** | EAP-TLS (certificate-based) |
| **Authentication method** | Certificate |
| **Trusted server certificate names** | `FAZI-CORP-ROOT` |
| **Root certificates for server validation** | FaziRootCA.cer |
| **Authentication method (client)** | Certificate |
| **Client certificate (outer identity)** | FaziRootCA.cer |

![Wi-Fi Configuration Settings](assets/configuration-profiles/image5.png)

### 2.3 Wi-Fi Assignment

Assigned the Wi-Fi profile to **All devices** group.

![Wi-Fi Assignment](assets/configuration-profiles/image6.png)

### 2.4 Wi-Fi Applicability Rules

Configured applicability rules to ensure the profile only applies to relevant devices.

![Wi-Fi Applicability Rules](assets/configuration-profiles/image7.png)

### 2.5 Review and Create

Reviewed the complete Wi-Fi profile configuration before deployment.

![Wi-Fi Review and Create](assets/configuration-profiles/image8.png)

---

## 3. Trusted Certificate Profile

### 3.1 Creating the Trusted Certificate Profile

Created a **Trusted certificate** profile to deploy the Fazi IT Lab root CA to managed devices for VPN server validation.

![Create Trusted Certificate Profile](assets/configuration-profiles/image25.png)

**Profile Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | Fazi Root CA |
| **Description** | Root CA for VPN and Wi-Fi certificate validation |
| **Platform** | Windows 10 and later |
| **Profile type** | Trusted certificate |

![Trusted Certificate Basics](assets/configuration-profiles/image26.png)

### 3.2 Certificate Configuration

| Setting | Value |
|---------|-------|
| **Certificate file** | `FaziRootCA.cer` |
| **Destination store** | Computer certificate store - Root |

![Trusted Certificate Settings](assets/configuration-profiles/image27.png)

### 3.3 Certificate Assignment

Assigned the trusted certificate profile to **All devices**.

![Trusted Certificate Assignment](assets/configuration-profiles/image28.png)

### 3.4 Review and Create

![Trusted Certificate Review](assets/configuration-profiles/image29.png)

---

## 4. VPN Server Infrastructure (Linux + strongSwan)

Before deploying the Intune VPN profile, a custom VPN server was built on Linux using **strongSwan** for IKEv2/IPsec connectivity.

### 4.1 strongSwan Configuration

Configured the IPsec tunnel parameters in `/etc/ipsec.conf`:

```bash
conn ikev2-vpn
    auto=add
    compress=no
    type=tunnel
    keyexchange=ikev2
    fragmentation=yes
    forceencaps=yes
    dpdaction=clear
    dpddelay=300s
    rekey=no
    left=%any
    leftid=@vpn.fazi.ovh
    leftcert=server-cert.pem
    leftsendcert=always
    leftsubnet=0.0.0.0/0
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=192.168.100.0/24
    rightdns=8.8.8.8,1.1.1.1
    rightsendcert=never
    eap_identity=%identity
```

![strongSwan IPsec Config](assets/configuration-profiles/image18.png)

### 4.2 IPsec Secrets

Configured EAP credentials in `/etc/ipsec.secrets`:

![IPsec Secrets](assets/configuration-profiles/image19.png)

### 4.3 IP Forwarding and Firewall

Enabled IP forwarding and configured UFW firewall rules:

```bash
# Enable IP forwarding
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sysctl -p

# Allow IPsec protocols
sudo ufw allow OpenSSH
sudo ufw allow 500,4500/udp
sudo ipsec restart
```

![IP Forwarding Config](assets/configuration-profiles/image20.png)

![UFW Firewall Rules](assets/configuration-profiles/image21.png)

![strongSwan Restart](assets/configuration-profiles/image23.png)

### 4.4 Root CA Certificate

Generated and exported the **FaziRootCA.cer** certificate for Intune deployment.

![FaziRootCA Certificate](assets/configuration-profiles/image24.png)

---

## 5. VPN Configuration Profile

### 5.1 Creating the VPN Profile

Created a new **VPN** profile in Intune for IKEv2 certificate-based remote access.

![Create VPN Profile](assets/configuration-profiles/image31.png)

**Profile Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | FAZI-REMOTE-VPN |
| **Description** | IKEv2 certificate-based VPN for remote workers |
| **Platform** | Windows 10 and later |
| **Profile type** | VPN |

![VPN Profile Basics](assets/configuration-profiles/image32.png)

### 5.2 VPN Connection Settings

| Setting | Value |
|---------|-------|
| **Connection type** | IKEv2 |
| **Connection name** | FAZI-REMOTE-VPN |
| **VPN server address** | `vpn.fazi.ovh` |
| **Authentication method** | Certificates |
| **Remember credentials at each logon** | Yes |
| **Always-on VPN** | Disabled (user-initiated) |
| **Device tunnel** | Disabled |
| **DNS suffix search list** | `fazi.ovh` |

![VPN Configuration Settings](assets/configuration-profiles/image33.png)

### 5.3 DNS and Split Tunneling

| Setting                | Value                            |
| ---------------------- | -------------------------------- |
| **DNS suffixes**       | `fazi.ovh`, `domain.contoso.com` |
| **Split tunneling**    | Enable                           |
| **Destination prefix** | 192.168.100.0                    |
| **Prefix size**        | 24                               |

![VPN DNS Settings](assets/configuration-profiles/image34.png)

### 5.4 VPN Assignment

Assigned the VPN profile to **All devices** group.

![VPN Assignment](assets/configuration-profiles/image35.png)

### 5.5 VPN Applicability Rules

![VPN Applicability Rules](assets/configuration-profiles/image36.png)

### 5.6 Review and Create

Reviewed the complete VPN profile with EAP XML configuration.

![VPN Review - EAP XML](assets/configuration-profiles/image37.png)

![VPN Review - Summary](assets/configuration-profiles/image38.png)

### 5.7 Profile Created Successfully

![VPN Profile Created](assets/configuration-profiles/image39.png)

---

## 6. Endpoint Protection Profile

### 6.1 Creating the Endpoint Protection Profile

Created an **Endpoint protection** profile to enforce BitLocker, Windows Defender, and firewall settings.

![Create Endpoint Protection Profile](assets/configuration-profiles/image40.png)

**Profile Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | SEC-W11-Baseline-Protection |
| **Description** | Enforces BitLocker encryption, Windows Defender real-time protection, and firewall rules for all corporate endpoints. |
| **Platform** | Windows 10 and later |
| **Profile type** | Endpoint protection |

![Endpoint Protection Basics](assets/configuration-profiles/image41.png)

### 6.2 Windows Encryption Settings

| Setting | Value |
|---------|-------|
| **Encrypt devices** | Require |
| **Configure encryption methods** | Enable |
| **Encryption method for operating system drives** | XTS-AES 256-bit |
| **Compatible TPM startup** | Require TPM |
| **Compatible TPM startup PIN** | Require PIN and TPM |
| **Compatible TPM startup key** | Require TPM |
| **Compatible TPM startup key and PIN** | Require TPM, startup key, and PIN |
| **Minimum PIN length** | 6 |
| **OS drive recovery** | Enable |
| **OS drive recovery password** | Require |
| **OS drive recovery key** | Allow |
| **Hide OS drive recovery options** | Yes |
| **Enable BitLocker after recovery information to storage** | Yes |

![Windows Encryption Settings](assets/configuration-profiles/image42.png)

### 6.3 Additional BitLocker Settings

| Setting | Value |
|---------|-------|
| **Allow standard users to enable encryption during Azure AD Join** | Yes |
| **Warning for other disk encryption** | Block |
| **Allow device user to suspend encryption** | Not configured |
| **Configure recovery password rotation** | Require for Azure AD joined devices |
| **Fixed drive recovery** | Enable |
| **Fixed drive recovery password** | Require |
| **Fixed drive recovery key** | Allow |
| **Hide fixed drive recovery options** | Yes |
| **Enable BitLocker after recovery information to storage** | Yes |
| **Write access to fixed data drives not protected by BitLocker** | Block |

![BitLocker Additional Settings](assets/configuration-profiles/image43.png)

### 6.4 Endpoint Protection Assignment

Assigned the endpoint protection profile to **All devices**.

![Endpoint Protection Assignment](assets/configuration-profiles/image44.png)

### 6.5 Endpoint Protection Applicability Rules

![Endpoint Protection Applicability](assets/configuration-profiles/image45.png)

### 6.6 Review and Create

![Endpoint Protection Review](assets/configuration-profiles/image46.png)

### 6.7 Profile Created Successfully

![Endpoint Protection Created](assets/configuration-profiles/image47.png)

---

## 7. Microsoft Defender Antivirus Policy

### 7.1 Creating the Antivirus Policy

Created a dedicated **Microsoft Defender Antivirus** policy for granular security control.

![Create Antivirus Policy](assets/configuration-profiles/image48.png)

**Policy Details:**
| Attribute | Value |
|-----------|-------|
| **Name** | SEC-W11-Antivirus-Policy |
| **Description** | Standardized Microsoft Defender configuration for real-time protection and cloud-based threat intelligence. |
| **Platform** | Windows 10, Windows 11, and Windows Server |
| **Profile type** | Microsoft Defender Antivirus |

![Antivirus Policy Basics](assets/configuration-profiles/image49.png)

### 7.2 Defender Configuration Settings

| Setting | Value |
|---------|-------|
| **Allow Archive Scanning** | Not configured |
| **Allow Behavior Monitoring** | Allowed (Turns on real-time monitoring) |
| **Allow Cloud Protection** | Allowed (Turns on Cloud Protection Default) |
| **Allow Email Scanning** | Not configured |
| **Allow Full Scan On Mapped Network Drives** | Not configured |
| **Allow Full Scan Removable Drive Scanning** | Not configured |
| **Allow scanning of all downloaded files and attachments** | Not configured |
| **Allow Realtime Monitoring** | Allowed (Turns on and runs real-time monitoring service) |
| **Allow Scanning Network Files** | Not configured |
| **Allow Script Scanning** | Not configured |
| **Allow User UI Access** | Not configured |
| **Avg CPU Load Factor** | Not configured |
| **Archive Max Size** | Not configured |
| **Archive Max Depth** | Not configured |
| **Check For Signatures Before Running Scan** | Not configured |
| **Cloud Block Level** | Not configured |
| **Cloud Extended Timeout** | Not configured |
| **Days To Retain Cleaned Items** | Not configured |

![Defender Configuration Settings](assets/configuration-profiles/image50.png)

### 7.3 Antivirus Scope Tags

Configured scope tags for policy targeting.

![Antivirus Scope Tags](assets/configuration-profiles/image51.png)

### 7.4 Antivirus Assignment

Assigned the antivirus policy to **All devices** group.

![Antivirus Assignment](assets/configuration-profiles/image52.png)

### 7.5 Antivirus Review and Create

![Antivirus Review](assets/configuration-profiles/image53.png)

### 7.6 Policy Created Successfully

![Antivirus Policy Created](assets/configuration-profiles/image54.png)

---

## 8. Configuration Profile Dashboard

### 8.1 All Profiles Overview

Reviewed the complete list of deployed configuration profiles in the Intune admin center.

| Profile Name | Platform | Profile Type | Last Modified |
|-------------|----------|-------------|---------------|
| INT-WLAN-Global | Windows 10 and later | Wi-Fi | 12/05/2026 |
| FAZI-REMOTE-VPN | Windows 10 and later | VPN | 12/05/2026 |
| Fazi Root CA | Windows 10 and later | Trusted certificate | 12/05/2026 |
| SEC-W11-Antivirus-Policy | Windows 10 and later | Microsoft Defender Antivirus | 12/05/2026 |
| SEC-W11-Baseline-Protection | Windows 10 and later | Endpoint protection | 12/05/2026 |

![All Configuration Profiles](assets/configuration-profiles/image55.png)

---

## 9. Key Takeaways

| Lesson | Detail |
|--------|--------|
| **Certificate-Based VPN** | EAP-TLS with deployed root CA eliminates password-based VPN vulnerabilities and enables machine-level authentication. |
| **Custom VPN Server** | Building a Linux strongSwan VPN server demonstrates full-stack infrastructure skills beyond just cloud administration. |
| **Split Tunneling** | Configuring split tunneling (192.168.100.0/24) routes only corporate traffic through VPN while preserving internet bandwidth for other apps. |
| **BitLocker + TPM** | Requiring TPM + PIN startup provides hardware-backed encryption with user verification, meeting most compliance frameworks. |
| **Defender Cloud Protection** | Enabling cloud-delivered protection ensures zero-day threat coverage beyond signature-based detection. |
| **Profile Stacking** | Deploying Wi-Fi, certificate, VPN, and endpoint profiles together creates a cohesive secure remote work experience. |

---

## 10. Production Recommendations

- **Certificate Lifecycle:** Implement SCEP/NDES or Intune Certificate Connector for automatic certificate renewal instead of manual CA deployment.
- **Always-On VPN:** For production, enable Always-On VPN with device tunnel so VPN connects before user logon, ensuring domain controller reachability.
- **Conditional Access Integration:** Link VPN profiles with Conditional Access policies to enforce device compliance and MFA before VPN establishment.
- **Firewall Rules:** Extend the endpoint protection profile with custom Windows Firewall rules to restrict lateral movement.
- **Attack Surface Reduction:** Add ASR rules to the endpoint protection profile to block Office macro threats and script-based attacks.
- **Monitoring:** Configure Intune diagnostic settings to stream profile deployment events to Log Analytics for failure alerting.

---

## 11. References

- [Intune Wi-Fi Settings for Windows](https://learn.microsoft.com/en-us/mem/intune/configuration/wi-fi-settings-windows)
- [Intune VPN Settings for Windows](https://learn.microsoft.com/en-us/mem/intune/configuration/vpn-settings-windows)
- [Intune Trusted Certificate Profile](https://learn.microsoft.com/en-us/mem/intune/configuration/trusted-certificate-profile)
- [Intune Endpoint Protection](https://learn.microsoft.com/en-us/mem/intune/protect/endpoint-protection-windows-10)
- [Microsoft Defender Antivirus Policy](https://learn.microsoft.com/en-us/mem/intune/protect/antivirus-microsoft-defender-settings-windows)
- [strongSwan IKEv2 VPN Setup](https://docs.strongswan.org/docs/5.9/config/IKEv2.html)
- [Windows BitLocker Group Policy Reference](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/group-policy-settings)

---

*Lab completed: Microsoft Intune tenant (Fazi IT Lab) with Wi-Fi, certificate-based VPN (strongSwan Linux backend), trusted certificate deployment, and endpoint security profiles configured.*
