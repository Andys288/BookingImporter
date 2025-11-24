# 🚀 Quick Start - Windows Authentication

## Step-by-Step Setup (5 minutes)

### 1️⃣ Pull Latest Changes
```bash
cd C:\GitHub\BookingImporter
git pull origin main
```

### 2️⃣ Install msnodesqlv8 Package

**Option A: Use the installer script (Recommended)**
```bash
# Double-click this file:
install-windows-auth.bat

# Or in PowerShell:
.\install-windows-auth.ps1
```

**Option B: Manual installation**
```bash
npm install msnodesqlv8
```

### 3️⃣ Verify Installation
```bash
npm list msnodesqlv8
```

You should see:
```
BookingImporter@0.0.0 C:\GitHub\BookingImporter
└── msnodesqlv8@4.2.1
```

### 4️⃣ Test Connection
```bash
node test-connection-windows.js
```

**Expected Output:**
```
✅ Connection successful!
📊 Running test query...
Database Name:   Accounts
System User:     DOMAIN\YourUsername
```

### 5️⃣ Start the Application
```bash
npm run server
```

---

## ⚠️ If Installation Fails

### Install Prerequisites First:

1. **Visual C++ Redistributable**
   - Download: https://aka.ms/vs/17/release/vc_redist.x64.exe
   - Run installer
   - Restart terminal

2. **ODBC Driver 18 for SQL Server**
   - Download: https://go.microsoft.com/fwlink/?linkid=2249004
   - Run installer
   - Restart terminal

3. **Try installation again**
   ```bash
   npm install msnodesqlv8
   ```

---

## 🔍 Verify Prerequisites

### Check ODBC Drivers:
1. Press `Win + R`
2. Type `odbcad32`
3. Go to "Drivers" tab
4. Look for "ODBC Driver 18 for SQL Server"

### Check Visual C++:
1. Open "Apps & Features"
2. Search for "Microsoft Visual C++ 2015-2022 Redistributable"

---

## 📋 Your .env File Should Look Like:

```env
# Windows Authentication
USE_WINDOWS_AUTH=true

# Database
DB_SERVER=THSACCStaTst051
DB_PORT=1433
DB_DATABASE=Accounts

# ODBC Driver
ODBC_DRIVER=ODBC Driver 18 for SQL Server

# Leave these empty for Windows Auth
DB_USER=
DB_PASSWORD=
```

---

## ✅ Checklist

- [ ] Pulled latest code from GitHub
- [ ] Installed msnodesqlv8 package
- [ ] Visual C++ Redistributable installed
- [ ] ODBC Driver 18 installed
- [ ] .env file configured
- [ ] Test connection successful
- [ ] Server starts without errors

---

## 🆘 Still Having Issues?

See the comprehensive guide:
- **[WINDOWS_AUTH_SETUP.md](WINDOWS_AUTH_SETUP.md)** - Full setup instructions
- **[WINDOWS_AUTH_FIX.md](WINDOWS_AUTH_FIX.md)** - Troubleshooting guide

Or run the test with full output:
```bash
node test-connection-windows.js > connection-test.log 2>&1
```

Then review `connection-test.log` for specific errors.

---

## 📞 Common Errors & Quick Fixes

| Error | Quick Fix |
|-------|-----------|
| "Cannot find module 'msnodesqlv8'" | Run: `npm install msnodesqlv8` |
| "config.server property is required" | msnodesqlv8 not installed properly |
| "ODBC Driver not found" | Install ODBC Driver 18 for SQL Server |
| "Failed to load driver" | Install Visual C++ Redistributable |
| "Login failed" | Check Windows user has database access |
| "Connection timeout" | Verify SQL Server is running |

---

**Time to complete:** ~5 minutes (if prerequisites already installed)

**Need help?** Check WINDOWS_AUTH_SETUP.md for detailed instructions.
