# 🎯 SETUP INSTRUCTIONS - READ THIS FIRST!

## ⚠️ CRITICAL ISSUE IDENTIFIED AND FIXED

The error you're seeing:
```
The "config.server" property is required and must be of type string.
```

**Root Cause:** The `msnodesqlv8` package is **NOT INSTALLED** in your local repository.

This package is **REQUIRED** for Windows Authentication to work with SQL Server.

---

## 🚀 SOLUTION - Follow These Steps

### Step 1: Pull Latest Changes
```powershell
cd C:\GitHub\BookingImporter
git pull origin main
```

### Step 2: Install msnodesqlv8 Package

**EASIEST WAY - Use the installer:**
```powershell
# Just double-click this file in Windows Explorer:
install-windows-auth.bat

# OR run in PowerShell:
.\install-windows-auth.ps1
```

**OR Manual Installation:**
```powershell
npm install msnodesqlv8
```

### Step 3: Verify Installation
```powershell
npm list msnodesqlv8
```

You should see:
```
BookingImporter@0.0.0 C:\GitHub\BookingImporter
└── msnodesqlv8@4.2.1
```

### Step 4: Test Connection
```powershell
node test-connection-windows.js
```

**If successful, you'll see:**
```
✅ Connection successful!
📊 Running test query...
Database Name:   Accounts
System User:     DOMAIN\YourUsername
✅ ALL TESTS PASSED!
```

### Step 5: Start the Application
```powershell
npm run server
```

---

## 📋 Prerequisites (Install if msnodesqlv8 fails)

If `npm install msnodesqlv8` fails, you need these:

### 1. Visual C++ Redistributable
- **Download:** https://aka.ms/vs/17/release/vc_redist.x64.exe
- Run the installer
- Restart your terminal

### 2. ODBC Driver 18 for SQL Server
- **Download:** https://go.microsoft.com/fwlink/?linkid=2249004
- Run the installer
- Restart your terminal

### 3. Verify ODBC Driver is Installed
1. Press `Win + R`
2. Type `odbcad32`
3. Click "Drivers" tab
4. Look for "ODBC Driver 18 for SQL Server"

---

## 📝 Your .env File

Make sure your `.env` file looks like this:

```env
# Windows Authentication (REQUIRED)
USE_WINDOWS_AUTH=true

# Database Connection
DB_SERVER=THSACCStaTst051
DB_PORT=1433
DB_DATABASE=Accounts

# ODBC Driver
ODBC_DRIVER=ODBC Driver 18 for SQL Server

# Leave these EMPTY for Windows Auth
DB_USER=
DB_PASSWORD=

# Server Settings
PORT=5000
NODE_ENV=development

# Upload Settings
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

**⚠️ IMPORTANT:** 
- `DB_SERVER` should be just the server name (NO PORT!)
- Port goes in `DB_PORT` separately

---

## 🔍 What Changed in the Repository

I've added/updated these files:

### New Files:
1. **QUICK_START_WINDOWS_AUTH.md** ⭐ START HERE!
   - 5-minute quick start guide
   - Step-by-step checklist

2. **WINDOWS_AUTH_SETUP.md** 📚 Complete Guide
   - Detailed setup instructions
   - All prerequisites explained
   - Comprehensive troubleshooting

3. **install-windows-auth.bat** 🔧 Easy Installer
   - Double-click to install msnodesqlv8
   - Includes helpful prompts

4. **install-windows-auth.ps1** 🔧 PowerShell Installer
   - PowerShell version with colors
   - Same functionality as .bat file

### Updated Files:
1. **package.json**
   - Added `msnodesqlv8@^4.2.1` to dependencies
   - Now included in `npm install`

2. **README.md**
   - Added prominent Windows Auth warning
   - Links to setup guides

3. **test-connection-windows.js**
   - Fixed to use ConnectionPool correctly
   - Better error messages

---

## ✅ Quick Checklist

Follow this in order:

- [ ] 1. Pull latest code: `git pull origin main`
- [ ] 2. Install msnodesqlv8: Run `install-windows-auth.bat`
- [ ] 3. Verify installation: `npm list msnodesqlv8`
- [ ] 4. Check .env file is configured correctly
- [ ] 5. Test connection: `node test-connection-windows.js`
- [ ] 6. If test passes, start server: `npm run server`
- [ ] 7. Open browser: http://localhost:5000

---

## 🆘 Troubleshooting

### Error: "Cannot find module 'msnodesqlv8'"
**Solution:** Run `npm install msnodesqlv8`

### Error: "config.server property is required"
**Solution:** msnodesqlv8 is not installed or not loading correctly
1. Delete `node_modules` folder
2. Delete `package-lock.json`
3. Run `npm install`
4. Run `npm install msnodesqlv8`

### Error: "Failed to load driver 'msnodesqlv8'"
**Solution:** Missing prerequisites
1. Install Visual C++ Redistributable
2. Install ODBC Driver 18 for SQL Server
3. Restart terminal
4. Try `npm install msnodesqlv8` again

### Error: "ODBC Driver not found"
**Solution:** Wrong driver name in .env
1. Open `odbcad32` (ODBC Data Sources)
2. Check "Drivers" tab
3. Use exact name in .env file:
   - `ODBC Driver 18 for SQL Server` (recommended)
   - `ODBC Driver 17 for SQL Server` (alternative)
   - `SQL Server` (older systems)

### Error: "Login failed for user"
**Solution:** Windows user doesn't have database access
1. Ask your DBA to grant access
2. Or run this in SQL Server Management Studio:
   ```sql
   USE [Accounts];
   CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
   ALTER ROLE db_datareader ADD MEMBER [DOMAIN\YourUsername];
   ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\YourUsername];
   GRANT EXECUTE TO [DOMAIN\YourUsername];
   ```

---

## 📚 Documentation Files (in order of importance)

1. **QUICK_START_WINDOWS_AUTH.md** - Start here! 5-minute setup
2. **WINDOWS_AUTH_SETUP.md** - Complete guide with all details
3. **WINDOWS_AUTH_FIX.md** - Troubleshooting guide
4. **README.md** - Project overview
5. **LOCAL_SETUP_GUIDE.md** - General setup guide

---

## 🎯 Expected Timeline

- **Prerequisites already installed:** 2-3 minutes
- **Need to install prerequisites:** 10-15 minutes
- **First time setup:** 15-20 minutes

---

## 📞 Still Stuck?

1. Read **QUICK_START_WINDOWS_AUTH.md**
2. Run the test and save output:
   ```powershell
   node test-connection-windows.js > test-output.txt 2>&1
   ```
3. Check **WINDOWS_AUTH_SETUP.md** for your specific error
4. Verify all prerequisites are installed

---

## ✨ What You'll Have When Done

✅ Working Windows Authentication connection to SQL Server  
✅ Test script that confirms everything works  
✅ Backend server running on port 5000  
✅ Frontend ready to upload Excel files  
✅ Full documentation for future reference  

---

**🚀 Ready? Start with Step 1 above!**

**⏱️ Time to complete: ~5 minutes (if prerequisites installed)**

---

## 🎉 Success Looks Like This:

```
PS C:\GitHub\BookingImporter> node test-connection-windows.js

╔══════════════════════════════════════════════════════════════════╗
║     SQL Server Connection Test - Windows Authentication         ║
╚══════════════════════════════════════════════════════════════════╝

🔌 Attempting to connect...

✅ Connection successful!

📊 Running test query...

╔══════════════════════════════════════════════════════════════════╗
║                     Connection Details                           ║
╚══════════════════════════════════════════════════════════════════╝

Database Name:   Accounts
System User:     DOMAIN\YourUsername
Database User:   dbo

SQL Server Version:
Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64)

🔍 Checking for stored procedure...
✅ Stored procedure TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS found!

╔══════════════════════════════════════════════════════════════════╗
║                    ✅ ALL TESTS PASSED! ✅                       ║
╚══════════════════════════════════════════════════════════════════╝

Your database connection is working correctly!
You can now start the application with: npm run server
```

**When you see this, you're ready to go! 🎊**
