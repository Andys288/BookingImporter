# Windows Authentication Setup Guide

## 🚨 CRITICAL: Install msnodesqlv8 Package

The `msnodesqlv8` package is **REQUIRED** for Windows Authentication to work. This package is NOT installed by default.

### Installation Steps

1. **Install the package:**
   ```bash
   npm install msnodesqlv8
   ```

2. **Verify installation:**
   ```bash
   npm list msnodesqlv8
   ```
   
   You should see:
   ```
   my-react-app@0.0.0 C:\GitHub\BookingImporter
   └── msnodesqlv8@4.2.1
   ```

## Prerequisites

Before installing `msnodesqlv8`, ensure you have:

### 1. Visual C++ Redistributable
The `msnodesqlv8` package requires Visual C++ runtime libraries.

**Download and install:**
- [Visual C++ Redistributable for Visual Studio 2015-2022](https://aka.ms/vs/17/release/vc_redist.x64.exe)

**To check if installed:**
- Open "Apps & Features" in Windows
- Search for "Microsoft Visual C++ 2015-2022 Redistributable"

### 2. ODBC Driver for SQL Server
You need an ODBC driver installed on your Windows machine.

**Recommended: ODBC Driver 18 for SQL Server**
- Download: https://go.microsoft.com/fwlink/?linkid=2249004
- Or search for "ODBC Driver 18 for SQL Server" in Microsoft downloads

**Alternative: ODBC Driver 17 for SQL Server**
- Download: https://go.microsoft.com/fwlink/?linkid=2249006

**To check installed drivers:**
1. Press `Win + R`
2. Type `odbcad32` and press Enter
3. Go to "Drivers" tab
4. Look for "ODBC Driver 18 for SQL Server" or "ODBC Driver 17 for SQL Server"

### 3. Node.js Build Tools (if installation fails)
If `npm install msnodesqlv8` fails with compilation errors:

```bash
npm install --global windows-build-tools
```

Or install Visual Studio Build Tools:
- Download: https://visualstudio.microsoft.com/downloads/
- Select "Build Tools for Visual Studio"
- Install "Desktop development with C++"

## Configuration

### .env File Setup

```env
# Windows Authentication Settings
USE_WINDOWS_AUTH=true

# Database Connection
DB_SERVER=THSACCStaTst051
DB_PORT=1433
DB_DATABASE=Accounts

# ODBC Driver (choose one that's installed on your system)
ODBC_DRIVER=ODBC Driver 18 for SQL Server
# ODBC_DRIVER=ODBC Driver 17 for SQL Server
# ODBC_DRIVER=SQL Server

# SQL Authentication (not used when USE_WINDOWS_AUTH=true)
DB_USER=
DB_PASSWORD=
```

### Important Notes:

1. **DB_SERVER**: Should be just the server name, WITHOUT port
   - ✅ Correct: `DB_SERVER=THSACCStaTst051`
   - ❌ Wrong: `DB_SERVER=THSACCStaTst051:1433`

2. **DB_PORT**: Specify port separately
   - Default is 1433

3. **ODBC_DRIVER**: Must match exactly what's installed
   - Check in ODBC Data Sources (odbcad32)

## Testing the Connection

After installing `msnodesqlv8`, test your connection:

```bash
node test-connection-windows.js
```

### Expected Output (Success):
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
```

## Troubleshooting

### Error: "Cannot find module 'msnodesqlv8'"

**Solution:**
```bash
npm install msnodesqlv8
```

### Error: "The 'config.server' property is required"

This means the `msnodesqlv8` driver is not being used. The mssql package is falling back to the default `tedious` driver.

**Solutions:**
1. Verify `msnodesqlv8` is installed:
   ```bash
   npm list msnodesqlv8
   ```

2. If not installed:
   ```bash
   npm install msnodesqlv8
   ```

3. Clear node_modules and reinstall:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

### Error: "Failed to load driver 'msnodesqlv8'"

**Cause:** Missing Visual C++ Redistributable or ODBC Driver

**Solutions:**
1. Install Visual C++ Redistributable (see Prerequisites above)
2. Install ODBC Driver 18 for SQL Server (see Prerequisites above)
3. Restart your terminal/PowerShell after installation

### Error: "ODBC Driver not found"

**Solution:**
1. Check which drivers are installed:
   - Run `odbcad32` (ODBC Data Sources)
   - Go to "Drivers" tab
   
2. Update your .env file to match an installed driver:
   ```env
   ODBC_DRIVER=ODBC Driver 17 for SQL Server
   ```
   or
   ```env
   ODBC_DRIVER=SQL Server
   ```

### Error: "Login failed for user"

**Cause:** Your Windows user doesn't have access to the database

**Solution:**
1. Connect to SQL Server as admin
2. Run these commands:
   ```sql
   USE [Accounts];
   GO
   
   -- Create login for your Windows user (if not exists)
   CREATE LOGIN [DOMAIN\YourUsername] FROM WINDOWS;
   GO
   
   -- Create user in database
   CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
   GO
   
   -- Grant necessary permissions
   ALTER ROLE db_datareader ADD MEMBER [DOMAIN\YourUsername];
   ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\YourUsername];
   GRANT EXECUTE TO [DOMAIN\YourUsername];
   GO
   ```

### Error: "Connection timeout"

**Solutions:**
1. Verify SQL Server is running:
   - Open `services.msc`
   - Find "SQL Server (MSSQLSERVER)"
   - Ensure it's "Running"

2. Test with sqlcmd:
   ```bash
   sqlcmd -S THSACCStaTst051,1433 -E -d Accounts
   ```

3. Check firewall settings:
   - SQL Server port (1433) must be open
   - Windows Firewall may be blocking

4. Verify SQL Server allows remote connections:
   - Open SQL Server Configuration Manager
   - SQL Server Network Configuration → Protocols
   - Enable "TCP/IP"

## Quick Verification Checklist

Before running the application, verify:

- [ ] `msnodesqlv8` package is installed (`npm list msnodesqlv8`)
- [ ] Visual C++ Redistributable is installed
- [ ] ODBC Driver 18 (or 17) for SQL Server is installed
- [ ] `.env` file has `USE_WINDOWS_AUTH=true`
- [ ] `.env` file has correct `DB_SERVER` (without port)
- [ ] `.env` file has correct `DB_DATABASE`
- [ ] `.env` file has correct `ODBC_DRIVER` name
- [ ] SQL Server is running
- [ ] Your Windows user has database access
- [ ] Test connection succeeds: `node test-connection-windows.js`

## Starting the Application

Once the test connection succeeds:

```bash
npm run server
```

The server will start on http://localhost:3001

## Additional Resources

- [msnodesqlv8 GitHub](https://github.com/TimelordUK/node-sqlserver-v8)
- [ODBC Driver Downloads](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)
- [Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe)
- [SQL Server Configuration](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-windows-service-accounts-and-permissions)

## Need Help?

If you're still having issues:

1. Run the test script and save the output:
   ```bash
   node test-connection-windows.js > connection-test.log 2>&1
   ```

2. Check the log file for specific error messages

3. Verify all prerequisites are installed

4. Try connecting with sqlcmd to rule out network/permission issues:
   ```bash
   sqlcmd -S THSACCStaTst051,1433 -E -d Accounts -Q "SELECT @@VERSION"
   ```
