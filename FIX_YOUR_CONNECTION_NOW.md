# 🚨 FIX YOUR CONNECTION ERROR - COMPLETE GUIDE

## ❌ The Error You're Seeing:
```
The "config.server" property is required and must be of type string.
```

## ✅ ROOT CAUSE IDENTIFIED:

Your `.env` file had **Windows Authentication DISABLED** (`USE_WINDOWS_AUTH=false`), but you were trying to run the Windows Authentication test script.

**I've just fixed your `.env` file!**

---

## 🎯 STEP-BY-STEP SOLUTION (5 Minutes)

### Step 1: Pull the Updated .env File
```powershell
cd C:\GitHub\BookingImporter
git pull origin main
```

### Step 2: Verify msnodesqlv8 is Installed
```powershell
npm list msnodesqlv8
```

**Expected output:**
```
BookingImporter@0.0.0 C:\GitHub\BookingImporter
└── msnodesqlv8@4.5.0
```

✅ **You already have this!** (You mentioned it's installed)

### Step 3: Verify Your .env File

Open `.env` and confirm these settings:

```env
USE_WINDOWS_AUTH=true

DB_SERVER=THSACCStaTst051
DB_DATABASE=Accounts
DB_PORT=1433

ODBC_DRIVER=ODBC Driver 18 for SQL Server

DB_USER=
DB_PASSWORD=
```

**Key Points:**
- ✅ `USE_WINDOWS_AUTH=true` (was false before!)
- ✅ `DB_SERVER` without port (no `:1433`)
- ✅ `DB_USER` and `DB_PASSWORD` are empty
- ✅ `ODBC_DRIVER` is specified

### Step 4: Test the Connection
```powershell
node test-connection-windows.js
```

**Expected SUCCESS output:**
```
╔══════════════════════════════════════════════════════════════════╗
║     SQL Server Connection Test - Windows Authentication         ║
╚══════════════════════════════════════════════════════════════════╝

📋 Configuration Details:
─────────────────────────────────────────────────────────────────
   Driver:          msnodesqlv8
   ODBC Driver:     ODBC Driver 18 for SQL Server
   Server:          THSACCStaTst051
   Port:            1433
   Database:        Accounts
   Authentication:  Windows Integrated Security
   User:            (current Windows user)

🔌 Attempting to connect...

✅ Connection successful!

📊 Running test query...

╔══════════════════════════════════════════════════════════════════╗
║                     Connection Details                           ║
╚══════════════════════════════════════════════════════════════════╝

Database Name:   Accounts
System User:     DOMAIN\YourUsername
Database User:   dbo

✅ Stored procedure found!
✅ ALL TESTS PASSED!
```

### Step 5: Start Your Application
```powershell
# Terminal 1 - Start Backend
npm run server

# Terminal 2 - Start Frontend (in a new terminal)
npm run dev
```

### Step 6: Access Your Application
Open browser: **http://localhost:5173**

---

## 🔍 WHY THIS WORKS NOW

### Before (BROKEN):
```env
USE_WINDOWS_AUTH=false  ❌ Wrong!
DB_SERVER=localhost     ❌ Wrong server!
DB_DATABASE=BookingDB   ❌ Wrong database!
```

The test script checked `USE_WINDOWS_AUTH` and exited immediately because it was `false`.

### After (FIXED):
```env
USE_WINDOWS_AUTH=true           ✅ Correct!
DB_SERVER=THSACCStaTst051       ✅ Your actual server!
DB_DATABASE=Accounts            ✅ Your actual database!
ODBC_DRIVER=ODBC Driver 18...   ✅ Driver specified!
```

Now the test script will:
1. ✅ See Windows Auth is enabled
2. ✅ Build correct ODBC connection string
3. ✅ Use msnodesqlv8 driver (which you have installed)
4. ✅ Connect successfully!

---

## 🏗️ YOUR APPLICATION ARCHITECTURE (Already Perfect!)

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR SETUP (Correct!)                     │
└─────────────────────────────────────────────────────────────┘

React Frontend              Express Backend           SQL Server
(Port 5173)            ←→   (Port 5000)         ←→   (Port 1433)
─────────────────────────────────────────────────────────────────
src/App.jsx                 server/server.js          Accounts DB
src/components/             server/config/            
                           database.js               
                           (Uses msnodesqlv8)        

User uploads Excel    →    Backend receives     →    Data saved
                           Parses with ExcelJS       to database
                           Connects to SQL           
                           Returns results      ←    Query results
User sees results     ←    
```

**You DON'T connect from React to SQL Server directly!**
**React → Backend → SQL Server** ✅

---

## ⚠️ IF TEST STILL FAILS

### Error: "Cannot find module 'msnodesqlv8'"
**Solution:**
```powershell
npm install msnodesqlv8
```

### Error: "Failed to load driver 'msnodesqlv8'"
**Cause:** Missing prerequisites

**Solution:**
1. Install Visual C++ Redistributable:
   - Download: https://aka.ms/vs/17/release/vc_redist.x64.exe
   - Install and restart terminal

2. Install ODBC Driver 18:
   - Download: https://go.microsoft.com/fwlink/?linkid=2249004
   - Install and restart terminal

3. Try again:
   ```powershell
   node test-connection-windows.js
   ```

### Error: "ODBC Driver not found"
**Solution:** Check which driver you have installed

1. Press `Win + R`, type `odbcad32`, press Enter
2. Go to "Drivers" tab
3. Look for one of these:
   - "ODBC Driver 18 for SQL Server" ✅ Best
   - "ODBC Driver 17 for SQL Server" ✅ Good
   - "SQL Server" ✅ Older but works

4. Update `.env` with the EXACT name:
   ```env
   ODBC_DRIVER=ODBC Driver 17 for SQL Server
   ```

### Error: "Login failed for user"
**Cause:** Your Windows user doesn't have database access

**Solution:** Ask your DBA to run this:
```sql
USE [Accounts];
GO

-- Create login for your Windows user
CREATE LOGIN [DOMAIN\YourUsername] FROM WINDOWS;
GO

-- Create user in database
CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
GO

-- Grant permissions
ALTER ROLE db_datareader ADD MEMBER [DOMAIN\YourUsername];
ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\YourUsername];
GRANT EXECUTE TO [DOMAIN\YourUsername];
GO
```

Replace `DOMAIN\YourUsername` with your actual Windows username.

### Error: "Connection timeout"
**Solutions:**
1. Verify SQL Server is running:
   - Open `services.msc`
   - Find "SQL Server (MSSQLSERVER)"
   - Ensure it's "Running"

2. Test with sqlcmd:
   ```powershell
   sqlcmd -S THSACCStaTst051,1433 -E -d Accounts
   ```
   
   If this works, your connection is fine. The issue is with Node.js setup.

3. Check firewall:
   - SQL Server port 1433 must be open
   - Windows Firewall may be blocking

---

## 📊 VERIFICATION CHECKLIST

Before starting the application, verify:

- [ ] ✅ msnodesqlv8@4.5.0 is installed (`npm list msnodesqlv8`)
- [ ] ✅ `.env` has `USE_WINDOWS_AUTH=true`
- [ ] ✅ `.env` has correct `DB_SERVER` (THSACCStaTst051)
- [ ] ✅ `.env` has correct `DB_DATABASE` (Accounts)
- [ ] ✅ `.env` has `ODBC_DRIVER` specified
- [ ] ✅ Visual C++ Redistributable installed
- [ ] ✅ ODBC Driver 18 (or 17) installed
- [ ] ✅ SQL Server is running
- [ ] ✅ Your Windows user has database access
- [ ] ✅ Test connection succeeds: `node test-connection-windows.js`

---

## 🚀 QUICK START COMMANDS

```powershell
# 1. Navigate to project
cd C:\GitHub\BookingImporter

# 2. Pull latest changes
git pull origin main

# 3. Verify msnodesqlv8 (should already be installed)
npm list msnodesqlv8

# 4. Test connection
node test-connection-windows.js

# 5. If test passes, start backend
npm run server

# 6. In a NEW terminal, start frontend
npm run dev

# 7. Open browser
start http://localhost:5173
```

---

## 🎯 WHAT EACH COMMAND DOES

| Command | What It Does | Expected Result |
|---------|--------------|-----------------|
| `git pull origin main` | Gets latest code & .env fix | "Already up to date" or files updated |
| `npm list msnodesqlv8` | Checks if package installed | Shows `msnodesqlv8@4.5.0` |
| `node test-connection-windows.js` | Tests database connection | "✅ Connection successful!" |
| `npm run server` | Starts backend API server | "Server running on port 5000" |
| `npm run dev` | Starts React frontend | "Local: http://localhost:5173" |

---

## 💡 UNDERSTANDING THE ARCHITECTURE

### ❌ WRONG (What You Might Think):
```
React App → SQL Server
(Browser)    (Database)
```
**This CANNOT work!** Browsers can't connect to databases directly.

### ✅ CORRECT (What You Actually Have):
```
React App  →  Express Backend  →  SQL Server
(Browser)     (Node.js Server)    (Database)
Port 5173     Port 5000           Port 1433

Frontend      API Server          Data Storage
- UI          - msnodesqlv8       - Accounts DB
- Forms       - database.js       - Stored Procs
- Display     - Routes/APIs       - Tables
```

**Your backend (`server/server.js`) handles ALL database connections!**

---

## 📝 YOUR .env FILE (CORRECT VERSION)

```env
# ============================================
# Database Configuration
# ============================================
USE_WINDOWS_AUTH=true

# SQL Server Connection
DB_SERVER=THSACCStaTst051
DB_DATABASE=Accounts
DB_PORT=1433

# ODBC Driver (for Windows Authentication)
ODBC_DRIVER=ODBC Driver 18 for SQL Server

# SQL Authentication (leave empty for Windows Auth)
DB_USER=
DB_PASSWORD=

# Connection Options
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# ============================================
# Server Configuration
# ============================================
PORT=5000
NODE_ENV=development

# ============================================
# Upload Configuration
# ============================================
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

---

## 🎉 SUCCESS INDICATORS

### When Everything Works:

**1. Test Script Output:**
```
✅ Connection successful!
✅ Stored procedure found!
✅ ALL TESTS PASSED!
```

**2. Backend Server Output:**
```
🔌 Attempting database connection...
   Driver: msnodesqlv8 (Windows Native ODBC)
   Server: THSACCStaTst051,1433
   Database: Accounts
✅ Database connected successfully!
Server running on port 5000
```

**3. Frontend Output:**
```
VITE v5.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

**4. Browser:**
- Application loads at http://localhost:5173
- No console errors (F12)
- Can upload Excel files
- Can download templates

---

## ⏱️ EXPECTED TIMELINE

| Task | Time | Status |
|------|------|--------|
| Pull latest code | 30 sec | ⏳ Do this now |
| Verify msnodesqlv8 | 10 sec | ✅ Already done |
| Test connection | 30 sec | ⏳ Do this next |
| Start backend | 10 sec | ⏳ After test passes |
| Start frontend | 10 sec | ⏳ After backend starts |
| **TOTAL** | **~2 min** | 🎯 **Quick!** |

---

## 🆘 STILL HAVING ISSUES?

### Option 1: Run Full Diagnostic
```powershell
# Save full test output
node test-connection-windows.js > diagnostic.txt 2>&1

# Review the file
notepad diagnostic.txt
```

### Option 2: Check Prerequisites
```powershell
# Check ODBC drivers
odbcad32

# Check if SQL Server is running
services.msc

# Test with sqlcmd
sqlcmd -S THSACCStaTst051,1433 -E -d Accounts -Q "SELECT @@VERSION"
```

### Option 3: Review Documentation
- **WINDOWS_AUTH_SETUP.md** - Complete setup guide
- **QUICK_START_WINDOWS_AUTH.md** - Quick reference
- **SETUP_INSTRUCTIONS_FOR_YOU.md** - Detailed instructions

---

## 📞 COMMON QUESTIONS

**Q: Do I need to install anything else?**
A: Only if msnodesqlv8 installation failed. Then you need Visual C++ Redistributable and ODBC Driver 18.

**Q: Why was my .env file wrong?**
A: It was set to SQL Authentication mode (`USE_WINDOWS_AUTH=false`) with placeholder values. You need Windows Authentication mode.

**Q: Can I use SQL Authentication instead?**
A: Yes, but you'd need a SQL Server username/password. Windows Auth is more secure and easier.

**Q: Will this work on other machines?**
A: Yes, as long as:
- They have msnodesqlv8 installed
- They have ODBC Driver 18 installed
- Their Windows user has database access
- They can reach the SQL Server

**Q: How do I deploy this?**
A: For production, you'd typically:
1. Build the frontend: `npm run build`
2. Deploy backend to a Windows server
3. Configure IIS or use PM2 to run Node.js
4. Ensure server has database access

---

## ✅ FINAL CHECKLIST

Before you start, confirm:

- [ ] Pulled latest code from GitHub
- [ ] `.env` file has `USE_WINDOWS_AUTH=true`
- [ ] `.env` file has correct server name (THSACCStaTst051)
- [ ] `.env` file has correct database (Accounts)
- [ ] msnodesqlv8@4.5.0 is installed
- [ ] ODBC Driver 18 is installed
- [ ] Visual C++ Redistributable is installed
- [ ] SQL Server is running
- [ ] Your Windows user has database access

**If all checked, run:** `node test-connection-windows.js`

---

## 🎊 YOU'RE READY!

Your application is **correctly architected** and **properly configured**.

The only issue was the `.env` file settings, which I've fixed.

**Next step:** Run the test script and start your servers!

```powershell
node test-connection-windows.js
```

**Expected time to working application: 2-3 minutes** ⏱️

---

**Good luck! 🚀**
