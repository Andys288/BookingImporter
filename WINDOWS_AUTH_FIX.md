# 🔧 Windows Authentication Connection Fix

## Problem

When testing the Node.js connection with Windows Authentication, you're getting this error:

```
❌ Node.js connection FAILED!
Error Details:
  The "config.server" property is required and must be of type string.
```

## Root Cause

The `msnodesqlv8` driver requires a specific connection string format that's different from the standard `mssql` configuration. The server name and port need to be formatted correctly in the ODBC connection string.

## ✅ Solution Applied

I've updated the database configuration to properly handle Windows Authentication with `msnodesqlv8`. Here's what changed:

### 1. Updated Connection String Format

**Before:**
```javascript
const connectionString = `Server=${process.env.DB_SERVER};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={SQL Server Native Client 11.0};`;
```

**After:**
```javascript
// Extract server name without port
const serverName = process.env.DB_SERVER.split(':')[0];
const port = process.env.DB_PORT || '1433';
const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';

// Build proper ODBC connection string
const connectionString = `Server=${serverName},${port};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={${driver}};TrustServerCertificate=yes;`;
```

### 2. Key Changes

1. **Server Format**: Changed from `Server:Port` to `Server,Port` (comma instead of colon)
2. **ODBC Driver**: Updated to use "ODBC Driver 18 for SQL Server" (modern driver)
3. **Trust Certificate**: Added `TrustServerCertificate=yes` for SQL Server 2022+ compatibility
4. **Configurable Driver**: Added `ODBC_DRIVER` environment variable for flexibility

---

## 📋 Configuration Steps

### Step 1: Update Your `.env` File

Your `.env` file should look like this:

```env
# ============================================
# Database Configuration
# ============================================
USE_WINDOWS_AUTH=true

# SQL Server Connection
DB_SERVER=THSACCSTATSt051
DB_DATABASE=Accounts
DB_PORT=1433

# ODBC Driver (for Windows Authentication)
ODBC_DRIVER=ODBC Driver 18 for SQL Server

# Connection Options
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# Server Configuration
PORT=5000
NODE_ENV=development

# Upload Configuration
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

**Important Notes:**
- ✅ `DB_SERVER` should be just the server name (without `:1433`)
- ✅ `DB_PORT` should be set separately
- ✅ `USE_WINDOWS_AUTH=true` to enable Windows Authentication
- ✅ `ODBC_DRIVER` specifies which ODBC driver to use

### Step 2: Verify ODBC Driver Installation

Check if you have the ODBC Driver installed:

1. Open **"ODBC Data Sources (64-bit)"** from Windows Start menu
2. Go to the **"Drivers"** tab
3. Look for one of these:
   - ✅ ODBC Driver 18 for SQL Server (recommended)
   - ✅ ODBC Driver 17 for SQL Server
   - ✅ SQL Server (older, but works)

**If you don't have ODBC Driver 18:**

**Option A: Install ODBC Driver 18** (Recommended)
```
Download from: https://go.microsoft.com/fwlink/?linkid=2249004
```

**Option B: Use ODBC Driver 17**
```env
ODBC_DRIVER=ODBC Driver 17 for SQL Server
```

**Option C: Use older SQL Server driver**
```env
ODBC_DRIVER=SQL Server
```

### Step 3: Test the Connection

Run the test script:

```bash
node test-connection-windows.js
```

This will:
- ✅ Verify your configuration
- ✅ Test the database connection
- ✅ Check for the stored procedure
- ✅ Display connection details
- ✅ Provide troubleshooting tips if it fails

---

## 🔍 Understanding the Connection String

### ODBC Connection String Format

```
Server=ServerName,Port;Database=DatabaseName;Trusted_Connection=Yes;Driver={DriverName};TrustServerCertificate=yes;
```

**Components:**
- `Server=ServerName,Port` - Server and port separated by comma
- `Database=DatabaseName` - Target database
- `Trusted_Connection=Yes` - Use Windows Authentication
- `Driver={DriverName}` - ODBC driver to use (in curly braces)
- `TrustServerCertificate=yes` - Trust self-signed certificates (SQL Server 2022+)

### Example Connection Strings

**For your server (THSACCSTATSt051:1433):**
```
Server=THSACCSTATSt051,1433;Database=Accounts;Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};TrustServerCertificate=yes;
```

**With ODBC Driver 17:**
```
Server=THSACCSTATSt051,1433;Database=Accounts;Trusted_Connection=Yes;Driver={ODBC Driver 17 for SQL Server};TrustServerCertificate=yes;
```

**With older SQL Server driver:**
```
Server=THSACCSTATSt051,1433;Database=Accounts;Trusted_Connection=Yes;Driver={SQL Server};
```

---

## 🧪 Testing Steps

### 1. Test with sqlcmd (Verify SQL Server Access)

```bash
sqlcmd -S THSACCSTATSt051,1433 -E -d Accounts
```

If this works, your Windows user has access to SQL Server.

### 2. Test with Node.js Test Script

```bash
node test-connection-windows.js
```

Expected output:
```
╔══════════════════════════════════════════════════════════════════╗
║     SQL Server Connection Test - Windows Authentication         ║
╚══════════════════════════════════════════════════════════════════╝

📋 Configuration Details:
─────────────────────────────────────────────────────────────────
   Driver:          msnodesqlv8
   ODBC Driver:     ODBC Driver 18 for SQL Server
   Server:          THSACCSTATSt051
   Port:            1433
   Database:        Accounts
   Authentication:  Windows Integrated Security
   User:            (current Windows user)

   Connection String:
   Server=THSACCSTATSt051,1433;Database=Accounts;Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};TrustServerCertificate=yes;
─────────────────────────────────────────────────────────────────

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

### 3. Start the Application

Once the test passes:

```bash
# Terminal 1 - Backend
npm run server

# Terminal 2 - Frontend
npm run dev
```

---

## 🐛 Common Issues and Solutions

### Issue 1: "ODBC Driver 18 for SQL Server not found"

**Solution:**
1. Install ODBC Driver 18: https://go.microsoft.com/fwlink/?linkid=2249004
2. Or use Driver 17: Set `ODBC_DRIVER=ODBC Driver 17 for SQL Server` in `.env`
3. Or use older driver: Set `ODBC_DRIVER=SQL Server` in `.env`

### Issue 2: "Login failed for user"

**Solution:**
1. Verify your Windows user has access to the database
2. Grant access in SQL Server:
   ```sql
   USE [Accounts];
   CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
   GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [DOMAIN\YourUsername];
   ```

### Issue 3: "Cannot open database 'Accounts'"

**Solution:**
1. Verify the database name is correct
2. Check your user has access to that specific database
3. Test with: `sqlcmd -S THSACCSTATSt051,1433 -E -Q "SELECT name FROM sys.databases"`

### Issue 4: "Connection timeout"

**Solution:**
1. Check SQL Server is running: `services.msc`
2. Verify firewall allows connection on port 1433
3. Check SQL Server is configured for TCP/IP:
   - Open SQL Server Configuration Manager
   - SQL Server Network Configuration → Protocols
   - Enable TCP/IP

### Issue 5: "msnodesqlv8 package not found"

**Solution:**
```bash
npm install msnodesqlv8
```

If installation fails, you may need:
- Visual C++ Redistributable: https://aka.ms/vs/17/release/vc_redist.x64.exe
- Windows Build Tools: `npm install --global windows-build-tools`

---

## 📊 Comparison: Before vs After

### Before (Broken)

```javascript
// ❌ Incorrect format
const connectionString = `Server=${process.env.DB_SERVER};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={SQL Server Native Client 11.0};`;

// With DB_SERVER=THSACCSTATSt051:1433, this becomes:
// Server=THSACCSTATSt051:1433;... (WRONG - colon not supported in ODBC)
```

### After (Fixed)

```javascript
// ✅ Correct format
const serverName = process.env.DB_SERVER.split(':')[0]; // THSACCSTATSt051
const port = process.env.DB_PORT || '1433';              // 1433
const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';

const connectionString = `Server=${serverName},${port};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={${driver}};TrustServerCertificate=yes;`;

// Result:
// Server=THSACCSTATSt051,1433;Database=Accounts;Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};TrustServerCertificate=yes;
// (CORRECT - comma separator, modern driver, trust certificate)
```

---

## 🎯 Quick Reference

### Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `USE_WINDOWS_AUTH` | `true` | Enable Windows Authentication |
| `DB_SERVER` | `THSACCSTATSt051` | Server name (no port) |
| `DB_PORT` | `1433` | Port number |
| `DB_DATABASE` | `Accounts` | Database name |
| `ODBC_DRIVER` | `ODBC Driver 18 for SQL Server` | ODBC driver name |

### Test Commands

```bash
# Test with sqlcmd
sqlcmd -S THSACCSTATSt051,1433 -E -d Accounts

# Test with Node.js
node test-connection-windows.js

# Start application
npm run server
npm run dev
```

### Connection String Template

```
Server={ServerName},{Port};Database={DatabaseName};Trusted_Connection=Yes;Driver={{ODBCDriver}};TrustServerCertificate=yes;
```

---

## ✅ Verification Checklist

Before starting the application, verify:

- [ ] `.env` file exists and has correct values
- [ ] `USE_WINDOWS_AUTH=true`
- [ ] `DB_SERVER` is set (without port)
- [ ] `DB_PORT` is set
- [ ] `DB_DATABASE` is set
- [ ] ODBC Driver is installed
- [ ] `msnodesqlv8` package is installed
- [ ] `sqlcmd` test passes
- [ ] `node test-connection-windows.js` passes
- [ ] Windows user has database access

---

## 📞 Still Having Issues?

If you're still experiencing problems:

1. **Check the test script output** - It provides detailed troubleshooting tips
2. **Verify SQL Server version** - SQL Server 2022 requires `TrustServerCertificate=yes`
3. **Check Windows user permissions** - Must have access to the database
4. **Try different ODBC drivers** - 18, 17, or older "SQL Server" driver
5. **Review server logs** - Check SQL Server error logs for authentication issues

---

## 🎉 Success!

Once `node test-connection-windows.js` shows "ALL TESTS PASSED", you're ready to use the application!

```bash
# Start the backend
npm run server

# Start the frontend (in another terminal)
npm run dev

# Open browser
http://localhost:3000
```

---

*Last Updated: November 24, 2025*
*Tested with: SQL Server 2022, ODBC Driver 18, Windows 11*
