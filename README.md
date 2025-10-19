# VPN IKEv2 Fix for Windows 10

## 🚀 Quick Fix

**Run:**
1. `Test-4-Renew-IP.bat` ⭐ - renew IP addresses (often solves the problem!)
2. If that doesn't help: `Fix-VPN-Quick.bat` - complete VPN fix
4. Connect to VPN through system tray

## 🔬 Step-by-step Testing

If quick fix doesn't help, test files **in order**:

1. **1-Renew-IP.bat** ⭐ - renew IP addresses (often solves the problem!)
2. **2-Enable-Adapters.bat** - enable adapters
5. **3-Restart-Adapters.bat** - restart adapters
3. **4-Start-RemoteAccess.bat** - start RemoteAccess
4. **5-Clear-IPsec-SA.bat** - clear IPsec SA

**After each file** try to connect to VPN.

## 📁 File Description

### Main scripts:
- **Fix-VPN-Quick.bat** - complete VPN fix (disconnect VPN, clear IPsec SA, clear caches, start services, restart adapters, create firewall rules)
- **Smart-VPN-Fix.bat** - automatically remembers successful methods and tries them first

### Test files:
- **1-Renew-IP.bat** - renew IP addresses
- **2-Enable-Adapters.bat** - enable disabled network adapters
- **3-Restart-Adapters.bat** - restart network adapters
- **4-Start-RemoteAccess.bat** - start RemoteAccess service
- **5-Clear-IPsec-SA.bat** - clear IPsec Security Associations

### Additional:
- **Network-Recovery.bat** - network recovery for serious problems

## 📋 Additional Actions

If nothing helps:
1. Restart router (unplug power for 30 sec)
2. Shut down and turn on your PC

## 📝 Logs

All actions are logged to `VPN-Quick-Fix.log` for diagnostics.
