# ⚡ Quick Fix Reference - Windows Authentication

## 🎯 The Fix in 3 Steps

### Step 1: Update `.env` File

```env
USE_WINDOWS_AUTH=true
DB_SERVER=THSACCSTATSt051
DB_DATABASE=Accounts
DB_PORT=1433
ODBC_DRIVER=ODBC Driver 18 for SQL Server
```

**Key Change:** Remove `:1433` from `DB_SERVER`, add `DB_PORT` separately

### Step 2: Test Connection

```bash
node test-connection-windows.js
```

### Step 3: Start Application

```bash
npm run server
npm run dev
```

---

## 🔧 What Changed

### Connection String Format

**Before (Broken):**
```
Server=THSACCSTATSt051:1433;...
```

**After (Fixed):**
```
Server=THSACCSTATSt051,1433;...
```

**Key:** Comma instead of colon!

---

## 🆘 If It Still Doesn't Work

### Try Different ODBC Drivers

**Option 1: ODBC Driver 18** (Default)
```env
ODBC_DRIVER=ODBC Driver 18 for SQL Server
```

**Option 2: ODBC Driver 17**
```env
ODBC_DRIVER=ODBC Driver 17 for SQL Server
```

**Option 3: Legacy Driver**
```env
ODBC_DRIVER=SQL Server
```

### Check ODBC Driver Installation

1. Open **"ODBC Data Sources (64-bit)"**
2. Go to **"Drivers"** tab
3. Look for your driver

**Don't have it?** Download here:
- ODBC Driver 18: https://go.microsoft.com/fwlink/?linkid=2249004

---

## 📋 Your Configuration

Based on your test output, use these values:

```env
USE_WINDOWS_AUTH=true
DB_SERVER=THSACCSTATSt051
DB_DATABASE=Accounts
DB_PORT=1433
ODBC_DRIVER=ODBC Driver 18 for SQL Server
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

---

## ✅ Quick Test Commands

```bash
# 1. Test with sqlcmd
sqlcmd -S THSACCSTATSt051,1433 -E -d Accounts

# 2. Test with Node.js
node test-connection-windows.js

# 3. Start backend
npm run server

# 4. Start frontend (new terminal)
npm run dev

# 5. Open browser
http://localhost:3000
```

---

## 📚 Documentation Files

- `WINDOWS_AUTH_FIX.md` - Complete guide
- `CHANGES_SUMMARY.md` - All changes made
- `test-connection-windows.js` - Test script
- This file - Quick reference

---

## 🎉 Expected Result

When `node test-connection-windows.js` works, you'll see:

```
✅ Connection successful!
✅ Stored procedure TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS found!
✅ ALL TESTS PASSED!
```

Then you're ready to go! 🚀

---

*Quick Reference - November 24, 2025*
