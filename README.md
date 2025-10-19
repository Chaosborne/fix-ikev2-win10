# VPN IKEv2 Fix for Windows 10

## Quick VPN Fix

If VPN stopped working, use **one file** to fix it:

### 🚀 Fix-VPN-Quick.bat
**Run as administrator** - this will fix most VPN problems.

## What the script fixes:

✅ **Disconnects VPN** and clears connections  
✅ **Clears IPsec SA** (Security Associations)  
✅ **Clears DNS and ARP cache**  
✅ **Starts necessary services** (RemoteAccess, PolicyAgent, IKEEXT)  
✅ **Restarts network adapters**  
✅ **Creates firewall rules** for IKEv2 (UDP 500, UDP 4500, ESP)  

## How to use:

1. **Right-click** on `Fix-VPN-Quick.bat`
2. **Run as administrator**
3. **Wait for completion** (about 30 seconds)
4. **Connect to VPN** through Windows tray

## If VPN still doesn't work:

1. **Restart router** (unplug power for 30 sec)
2. **Try different internet** (mobile hotspot)
3. **Contact provider** (may block VPN)

## 🔍 VPN Problem Analysis

### What usually "breaks":

**Main cause:** **RemoteAccess (Routing and Remote Access)** service stops.

### Why this happens:

1. **Automatic shutdown** - Windows shuts down "unused" services
2. **Application conflicts** - VPN clients, network utilities may stop the service
3. **Permission issues** - service cannot start automatically
4. **State corruption** - service "hangs" in intermediate state

### Problem symptoms:

- ❌ VPN won't connect (error 809)
- ❌ UDP ports 500/4500 unavailable
- ❌ RemoteAccess service stopped
- ❌ "Server not responding" when connecting

### What the script fixes:

✅ **Start RemoteAccess** - restores VPN traffic processing  
✅ **Clear IPsec SA** - removes "hung" connections  
✅ **Restart network adapters** - resets network states  
✅ **Clear caches** - removes "stuck" DNS/ARP entries  

### Analogy:
It's like if the **postman stopped working** - letters (VPN traffic) weren't delivered, even though mail (internet) worked. The script "woke up" the postman and cleared his route.

**Conclusion:** The problem is in **Windows service**, not in network or provider. VPN "breaks" when Windows shuts down necessary services.

## 🔬 Minimal Actions Testing System

Created testing system to identify only necessary actions:

### Test files (in order of testing):
- **Test-4-Renew-IP.bat** ⭐ - renew IP addresses (try this FIRST!)
- **Test-1-Enable-Adapters.bat** - enable disabled network adapters
- **Test-2-Start-RemoteAccess.bat** - start RemoteAccess service  
- **Test-3-Clear-IPsec-SA.bat** - clear IPsec Security Associations
- **Test-5-Restart-Adapters.bat** - restart network adapters

### Smart testing:
- **Smart-VPN-Fix.bat** - automatically remembers successful methods and tries them first

### How to use:
1. **FIRST** try Test-4-Renew-IP.bat ⭐ (often solves the problem!)
2. If that doesn't help, run Test-1-Enable-Adapters.bat
3. If that doesn't help, run Test-2-Start-RemoteAccess.bat
4. If that doesn't help, run Test-3-Clear-IPsec-SA.bat
5. If that doesn't help, run Test-5-Restart-Adapters.bat
6. After each file try to connect to VPN
7. Remember which file helped
8. Report result to create minimal file

**Goal:** Find minimal set of actions and create one efficient file without unnecessary operations.

Detailed instructions in **ИНСТРУКЦИЯ-ТЕСТИРОВАНИЕ.txt**

## Logs:

All actions are logged to `VPN-Quick-Fix.log` for diagnostics.

## Additional files:

- **Network-Recovery.bat** - network recovery for serious problems

---

**Note:** Script automatically detects and fixes problems. No manual configuration required.