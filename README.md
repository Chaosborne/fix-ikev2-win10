# VPN IKEv2 Fix for Windows 10

### « Remote server not responding ... »

#### ⚠️ This is not a solution to the underlying problem. It's a quick workaround to fix the connection when it stops working.
## 🚀 Quick Fix

**Run:**
1. `Renew-IP.bat` ⭐ - renew IP addresses (often solves the problem!)
2. If that doesn't help: `Fix-VPN-Quick.bat` - complete VPN fix
4. Connect to VPN through system tray

## 🔬 Step-by-step Testing

If quick fix doesn't help, test files **in order** (**after each file** try to connect to VPN):

1. **Renew-IP.bat** ⭐ - renew IP addresses (often solves the problem!)
2. **Enable-Adapters.bat**
5. **Restart-Adapters.bat**
3. **Start-RemoteAccess.bat**
4. **Clear-IPsec-SA.bat**

## 📁 File Description

### Main scripts:
- **Fix-VPN-Quick.bat** - complete VPN fix (disconnect VPN, clear IPsec SA, clear caches, start services, restart adapters, create firewall rules)
- **Smart-VPN-Fix.bat** - automatically remembers successful methods and tries them first

### Test files:
- **Renew-IP.bat** - renew IP addresses
- **Enable-Adapters.bat** - enable disabled network adapters
- **Restart-Adapters.bat** - restart network adapters
- **Start-RemoteAccess.bat** - start RemoteAccess service
- **Clear-IPsec-SA.bat** - clear IPsec Security Associations

### Additional:
- **Network-Recovery.bat** - network recovery for serious problems

## 📋 Additional Actions

If nothing helps:
1. Restart router (unplug power for 30 sec)
2. Shut down and turn on your PC

## 📝 Logs

All actions are logged to `VPN-Quick-Fix.log` for diagnostics.
