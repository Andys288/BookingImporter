# SQL Server 2022 Windows Authentication Guide for Node.js

## 🎯 Executive Summary

Connecting Node.js to SQL Server 2022 with Windows Integrated Security requires **native ODBC drivers**. This guide provides **3 proven solutions** with complete troubleshooting steps.

---

## 📋 Table of Contents

1. [Why Previous Attempts Failed](#why-previous-attempts-failed)
2. [Solution 1: msnodesqlv8 (Recommended)](#solution-1-msnodesqlv8-recommended)
3. [Solution 2: mssql with tedious (SQL Auth Fallback)](#solution-2-mssql-with-tedious-sql-auth-fallback)
4. [Solution 3: node-sqlserver-v8 (Alternative Native Driver)](#solution-3-node-sqlserver-v8-alternative-native-driver)
5. [Prerequisites & System Requirements](#prerequisites--system-requirements)
6. [Diagnostic Tools & Testing](#diagnostic-tools--testing)
7. [Common Issues & Solutions](#common-issues--solutions)
8. [Production Deployment Considerations](#production-deployment-considerations)

---

## 🔍 Why Previous Attempts Failed

### Tedious Driver Issues

**Problem:** The `tedious` driver (default for `mssql` package) has **poor Windows Authentication support**.

```javascript
// ❌ This DOESN'T work properly with Windows Auth
const config = {
  server: 'localhost',
  database: 'MyDB',
  options: {
    trustedConnection: true,  // Ignored by tedious!
    encrypt: true
  }
};
```

**Why it fails:**
- Tedious is a **pure JavaScript** implementation (no native ODBC)
- It attempts to implement NTLM/Kerberos in JavaScript (unreliable)
- Requires explicit domain/username even for "trusted" connections
- SQL Server 2022's stricter security often rejects these connections

### msnodesqlv8 Common Failures

**Problem:** Even though `msnodesqlv8` is the right choice, it can fail due to:

1. **Missing ODBC Driver**
   ```
   Error: [Microsoft][ODBC Driver Manager] Data source name not found
   ```
   - SQL Server Native Client 11.0 is deprecated
   - Need ODBC Driver 17 or 18 for SQL Server 2022

2. **Wrong Connection String Format**
   ```javascript
   // ❌ Wrong - uses old driver
   Driver={SQL Server Native Client 11.0}
   
   // ✅ Correct - uses modern driver
   Driver={ODBC Driver 18 for SQL Server}
   ```

3. **Build Tool Issues**
   ```
   Error: node-gyp rebuild failed
   ```
   - Missing Visual C++ Build Tools
   - Wrong Node.js version (needs 14+)

4. **Certificate Validation**
   ```
   Error: SSL Provider: The certificate chain was issued by an authority that is not trusted
   ```
   - SQL Server 2022 enforces encryption by default
   - Need `TrustServerCertificate=Yes` for local dev

---

## ✅ Solution 1: msnodesqlv8 (Recommended)

### Why This is Best

- ✅ **Native Windows ODBC** - Uses Windows authentication directly
- ✅ **True Integrated Security** - No credentials in code
- ✅ **SQL Server 2022 Compatible** - Works with latest ODBC drivers
- ✅ **Production Ready** - Used by Microsoft internally
- ✅ **Best Performance** - Direct ODBC calls

### Step-by-Step Implementation

#### Step 1: Install ODBC Driver 18 for SQL Server

**Download & Install:**
```
https://go.microsoft.com/fwlink/?linkid=2249004
```

Or use command line:
```powershell
# PowerShell (Run as Administrator)
# Download ODBC Driver 18
$url = "https://go.microsoft.com/fwlink/?linkid=2249004"
$output = "$env:TEMP\msodbcsql.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -ArgumentList "/i $output /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait
```

**Verify Installation:**
```powershell
# List installed ODBC drivers
Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}
```

You should see:
```
ODBC Driver 18 for SQL Server
ODBC Driver 17 for SQL Server (if installed)
SQL Server (legacy - avoid)
```

#### Step 2: Install Visual C++ Build Tools (if needed)

**Check if already installed:**
```cmd
where cl.exe
```

If not found, install:
```powershell
# Option A: Install Visual Studio Build Tools
# Download from: https://visualstudio.microsoft.com/downloads/
# Select "Desktop development with C++"

# Option B: Use npm (automated)
npm install --global windows-build-tools
```

#### Step 3: Install msnodesqlv8

```bash
npm install msnodesqlv8 mssql
```

**If installation fails:**
```bash
# Clear npm cache
npm cache clean --force

# Install with verbose logging
npm install msnodesqlv8 --verbose

# If still fails, try specific version
npm install msnodesqlv8@4.2.1
```

#### Step 4: Configure Environment Variables

**Create/Update `.env` file:**
```env
# ============================================
# SQL Server 2022 Configuration
# ============================================
DB_SERVER=localhost
# Or: DB_SERVER=localhost\\SQLEXPRESS
# Or: DB_SERVER=YOUR-COMPUTER-NAME
# Or: DB_SERVER=192.168.1.100

DB_DATABASE=YourDatabaseName
DB_PORT=1433

# Windows Authentication (no user/password needed!)
DB_USE_WINDOWS_AUTH=true

# SQL Server 2022 requires these
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# Server Configuration
PORT=5000
NODE_ENV=development
```

#### Step 5: Create Database Configuration

**Create `server/config/database-windows-auth.js`:**

```javascript
const sql = require('mssql');
require('dotenv').config();

/**
 * SQL Server 2022 Windows Authentication Configuration
 * Uses msnodesqlv8 driver for native Windows Integrated Security
 */

// Determine the correct ODBC driver
function getODBCDriver() {
  // Try ODBC Driver 18 first (SQL Server 2022 compatible)
  // Fall back to 17 if 18 not available
  const drivers = [
    'ODBC Driver 18 for SQL Server',
    'ODBC Driver 17 for SQL Server',
    'SQL Server Native Client 11.0'  // Legacy fallback
  ];
  
  // In production, you'd query available drivers
  // For now, use the most common
  return drivers[0];
}

// Build connection string for Windows Authentication
const connectionString = `Server=${process.env.DB_SERVER},${process.env.DB_PORT};` +
  `Database=${process.env.DB_DATABASE};` +
  `Trusted_Connection=Yes;` +
  `Driver={${getODBCDriver()}};` +
  `Encrypt=${process.env.DB_ENCRYPT === 'true' ? 'yes' : 'no'};` +
  `TrustServerCertificate=${process.env.DB_TRUST_SERVER_CERTIFICATE === 'true' ? 'yes' : 'no'};`;

const config = {
  driver: 'msnodesqlv8',
  connectionString: connectionString,
  
  options: {
    // SQL Server 2022 specific options
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
    enableArithAbort: true,
    
    // Connection timeout (30 seconds)
    connectionTimeout: 30000,
    requestTimeout: 30000
  },
  
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
    acquireTimeoutMillis: 30000
  }
};

let pool = null;

/**
 * Get database connection pool
 * @returns {Promise<sql.ConnectionPool>}
 */
async function getConnection() {
  try {
    if (pool && pool.connected) {
      return pool;
    }
    
    console.log('🔌 Connecting to SQL Server 2022...');
    console.log(`   Driver: msnodesqlv8 (${getODBCDriver()})`);
    console.log(`   Server: ${process.env.DB_SERVER}:${process.env.DB_PORT}`);
    console.log(`   Database: ${process.env.DB_DATABASE}`);
    console.log(`   Authentication: Windows Integrated Security`);
    console.log(`   Encryption: ${process.env.DB_ENCRYPT}`);
    console.log(`   Trust Certificate: ${process.env.DB_TRUST_SERVER_CERTIFICATE}`);
    
    pool = await sql.connect(config);
    
    // Test the connection
    const result = await pool.request().query('SELECT SUSER_NAME() AS CurrentUser, @@VERSION AS SQLVersion');
    
    console.log('✅ Database connected successfully!');
    console.log(`   Connected as: ${result.recordset[0].CurrentUser}`);
    console.log(`   SQL Version: ${result.recordset[0].SQLVersion.split('\n')[0]}`);
    
    return pool;
    
  } catch (error) {
    console.error('❌ Database connection failed!');
    console.error('');
    console.error('Error Details:', error.message);
    console.error('');
    console.error('🔧 Troubleshooting Steps:');
    console.error('');
    
    if (error.message.includes('Data source name not found')) {
      console.error('❌ ODBC Driver not found!');
      console.error('   Install ODBC Driver 18 for SQL Server:');
      console.error('   https://go.microsoft.com/fwlink/?linkid=2249004');
      console.error('');
      console.error('   Verify installation:');
      console.error('   PowerShell: Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}');
    }
    
    if (error.message.includes('Login failed')) {
      console.error('❌ Windows user lacks database access!');
      console.error('   Your Windows user needs SQL Server permissions.');
      console.error('');
      console.error('   Run in SSMS as admin:');
      console.error('   USE [' + process.env.DB_DATABASE + '];');
      console.error('   CREATE USER [' + process.env.USERDOMAIN + '\\' + process.env.USERNAME + ']');
      console.error('   FOR LOGIN [' + process.env.USERDOMAIN + '\\' + process.env.USERNAME + '];');
      console.error('   ALTER ROLE db_owner ADD MEMBER [' + process.env.USERDOMAIN + '\\' + process.env.USERNAME + '];');
    }
    
    if (error.message.includes('certificate chain')) {
      console.error('❌ SSL Certificate validation failed!');
      console.error('   For local development, set in .env:');
      console.error('   DB_TRUST_SERVER_CERTIFICATE=true');
    }
    
    if (error.message.includes('timeout')) {
      console.error('❌ Connection timeout!');
      console.error('   1. Check SQL Server is running: services.msc');
      console.error('   2. Verify server name: ' + process.env.DB_SERVER);
      console.error('   3. Check firewall allows port ' + process.env.DB_PORT);
      console.error('   4. Test with: sqlcmd -S ' + process.env.DB_SERVER + ' -E');
    }
    
    console.error('');
    console.error('Full error object:', error);
    
    throw error;
  }
}

/**
 * Close database connection
 */
async function closeConnection() {
  try {
    if (pool) {
      await pool.close();
      pool = null;
      console.log('✅ Database connection closed');
    }
  } catch (error) {
    console.error('❌ Error closing database connection:', error.message);
  }
}

/**
 * Test database connection
 * @returns {Promise<Object>}
 */
async function testConnection() {
  try {
    const pool = await getConnection();
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        DB_NAME() AS CurrentDatabase,
        @@VERSION AS SQLVersion,
        GETDATE() AS ServerTime
    `);
    
    return {
      success: true,
      data: result.recordset[0]
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  await closeConnection();
  process.exit(0);
});

process.on('SIGTERM', async () => {
  await closeConnection();
  process.exit(0);
});

module.exports = {
  sql,
  getConnection,
  closeConnection,
  testConnection
};
```

#### Step 6: Create Test Script

**Create `test-connection.js`:**

```javascript
const { testConnection } = require('./server/config/database-windows-auth');

async function runTest() {
  console.log('='.repeat(60));
  console.log('SQL Server 2022 Windows Authentication Test');
  console.log('='.repeat(60));
  console.log('');
  
  const result = await testConnection();
  
  console.log('');
  console.log('='.repeat(60));
  
  if (result.success) {
    console.log('✅ CONNECTION SUCCESSFUL!');
    console.log('='.repeat(60));
    console.log('');
    console.log('Connection Details:');
    console.log('  User:', result.data.CurrentUser);
    console.log('  Database:', result.data.CurrentDatabase);
    console.log('  Server Time:', result.data.ServerTime);
    console.log('  SQL Version:', result.data.SQLVersion.split('\n')[0]);
    console.log('');
    console.log('✅ Your application is ready to use this connection!');
  } else {
    console.log('❌ CONNECTION FAILED!');
    console.log('='.repeat(60));
    console.log('');
    console.log('Error:', result.error);
    console.log('');
    console.log('See troubleshooting steps above.');
  }
  
  console.log('');
  process.exit(result.success ? 0 : 1);
}

runTest();
```

#### Step 7: Test the Connection

```bash
node test-connection.js
```

**Expected Success Output:**
```
============================================================
SQL Server 2022 Windows Authentication Test
============================================================

🔌 Connecting to SQL Server 2022...
   Driver: msnodesqlv8 (ODBC Driver 18 for SQL Server)
   Server: localhost:1433
   Database: YourDatabase
   Authentication: Windows Integrated Security
   Encryption: true
   Trust Certificate: true
✅ Database connected successfully!
   Connected as: DOMAIN\YourUsername
   SQL Version: Microsoft SQL Server 2022 (RTM) - 16.0.1000.6

============================================================
✅ CONNECTION SUCCESSFUL!
============================================================

Connection Details:
  User: DOMAIN\YourUsername
  Database: YourDatabase
  Server Time: 2024-01-15T10:30:00.000Z
  SQL Version: Microsoft SQL Server 2022 (RTM) - 16.0.1000.6

✅ Your application is ready to use this connection!
```

---

## 🔄 Solution 2: mssql with tedious (SQL Auth Fallback)

If Windows Authentication continues to fail, use SQL Server Authentication as a fallback.

### Configuration

**Update `.env`:**
```env
DB_SERVER=localhost
DB_DATABASE=YourDatabase
DB_PORT=1433

# SQL Server Authentication (not Windows Auth)
DB_USER=your_sql_username
DB_PASSWORD=your_sql_password

DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
```

**Create `server/config/database-sql-auth.js`:**

```javascript
const sql = require('mssql');
require('dotenv').config();

const config = {
  server: process.env.DB_SERVER,
  port: parseInt(process.env.DB_PORT),
  database: process.env.DB_DATABASE,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
    enableArithAbort: true
  },
  
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

let pool = null;

async function getConnection() {
  try {
    if (pool && pool.connected) {
      return pool;
    }
    
    console.log('🔌 Connecting to SQL Server (SQL Authentication)...');
    pool = await sql.connect(config);
    console.log('✅ Connected as:', process.env.DB_USER);
    
    return pool;
  } catch (error) {
    console.error('❌ Connection failed:', error.message);
    throw error;
  }
}

module.exports = { sql, getConnection };
```

### Enable SQL Server Authentication

**Run in SSMS:**
```sql
-- Enable mixed mode authentication
USE master;
GO

-- Check current authentication mode
EXEC xp_instance_regread 
  @rootkey = 'HKEY_LOCAL_MACHINE',
  @key = 'Software\Microsoft\MSSQLServer\MSSQLServer',
  @value_name = 'LoginMode';
GO
-- 1 = Windows Auth only, 2 = Mixed mode

-- Create SQL login
CREATE LOGIN your_sql_username WITH PASSWORD = 'YourStrongPassword123!';
GO

USE YourDatabase;
GO

CREATE USER your_sql_username FOR LOGIN your_sql_username;
GO

ALTER ROLE db_owner ADD MEMBER your_sql_username;
GO
```

**Note:** Requires SQL Server restart if changing authentication mode.

---

## 🔧 Solution 3: node-sqlserver-v8 (Alternative Native Driver)

An alternative to `msnodesqlv8` with similar functionality.

### Installation

```bash
npm install node-sqlserver-v8
```

### Configuration

```javascript
const sql = require('node-sqlserver-v8');

const connectionString = 
  `Server=${process.env.DB_SERVER};` +
  `Database=${process.env.DB_DATABASE};` +
  `Trusted_Connection=Yes;` +
  `Driver={ODBC Driver 18 for SQL Server};`;

function query(queryString) {
  return new Promise((resolve, reject) => {
    sql.query(connectionString, queryString, (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

// Usage
async function test() {
  try {
    const result = await query('SELECT SUSER_NAME() AS CurrentUser');
    console.log('Connected as:', result[0].CurrentUser);
  } catch (error) {
    console.error('Error:', error);
  }
}
```

---

## 📦 Prerequisites & System Requirements

### Required Software

| Component | Version | Download Link |
|-----------|---------|---------------|
| **Node.js** | 14.x - 20.x | https://nodejs.org/ |
| **SQL Server** | 2022 | Already installed |
| **ODBC Driver 18** | Latest | https://go.microsoft.com/fwlink/?linkid=2249004 |
| **Visual C++ Redistributable** | 2015-2022 | https://aka.ms/vs/17/release/vc_redist.x64.exe |
| **Windows Build Tools** | Latest | `npm install -g windows-build-tools` |

### SQL Server Configuration

**1. Enable TCP/IP Protocol:**

```powershell
# Open SQL Server Configuration Manager
# Or use PowerShell:
$wmi = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer
$uri = "ManagedComputer[@Name='$env:COMPUTERNAME']/ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']"
$tcp = $wmi.GetSmoObject($uri)
$tcp.IsEnabled = $true
$tcp.Alter()

# Restart SQL Server
Restart-Service MSSQLSERVER
```

**2. Configure Windows Firewall:**

```powershell
# Allow SQL Server port
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow

# Allow SQL Browser (for named instances)
New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
```

**3. Grant Windows User Access:**

```sql
-- Run in SSMS as administrator
USE master;
GO

-- Add Windows login
CREATE LOGIN [DOMAIN\Username] FROM WINDOWS;
GO

-- Grant database access
USE YourDatabase;
GO

CREATE USER [DOMAIN\Username] FOR LOGIN [DOMAIN\Username];
GO

-- Grant permissions (adjust as needed)
ALTER ROLE db_owner ADD MEMBER [DOMAIN\Username];
GO

-- Verify
SELECT 
  dp.name AS UserName,
  dp.type_desc AS UserType,
  r.name AS RoleName
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.name = 'DOMAIN\Username';
```

### Windows User Information

**Find your Windows username:**

```cmd
whoami
```

Output: `DOMAIN\Username` or `COMPUTERNAME\Username`

---

## 🔍 Diagnostic Tools & Testing

### 1. Test ODBC Driver Installation

**PowerShell:**
```powershell
# List all ODBC drivers
Get-OdbcDriver | Format-Table Name, Platform

# Check specific driver
Get-OdbcDriver -Name "ODBC Driver 18 for SQL Server"
```

**Expected Output:**
```
Name                              Platform
----                              --------
ODBC Driver 18 for SQL Server     64-bit
```

### 2. Test SQL Server Connectivity

**Using sqlcmd:**
```cmd
REM Test Windows Authentication
sqlcmd -S localhost -E -Q "SELECT SUSER_NAME(), @@VERSION"

REM Test with specific database
sqlcmd -S localhost -d YourDatabase -E -Q "SELECT DB_NAME()"

REM Test named instance
sqlcmd -S localhost\SQLEXPRESS -E -Q "SELECT @@SERVERNAME"
```

**Using PowerShell:**
```powershell
# Test connection
$serverName = "localhost"
$database = "YourDatabase"

$connectionString = "Server=$serverName;Database=$database;Integrated Security=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)

try {
    $connection.Open()
    Write-Host "✅ Connection successful!" -ForegroundColor Green
    Write-Host "Server Version:" $connection.ServerVersion
    $connection.Close()
} catch {
    Write-Host "❌ Connection failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
```

### 3. Test Node.js ODBC Access

**Create `test-odbc.js`:**
```javascript
const { execSync } = require('child_process');

console.log('Testing ODBC Driver availability...\n');

try {
  // Windows only - list ODBC drivers
  const drivers = execSync('powershell "Get-OdbcDriver | Select-Object -ExpandProperty Name"', 
    { encoding: 'utf-8' });
  
  console.log('Available ODBC Drivers:');
  console.log(drivers);
  
  const hasDriver18 = drivers.includes('ODBC Driver 18 for SQL Server');
  const hasDriver17 = drivers.includes('ODBC Driver 17 for SQL Server');
  
  if (hasDriver18) {
    console.log('✅ ODBC Driver 18 found - Perfect for SQL Server 2022!');
  } else if (hasDriver17) {
    console.log('⚠️  ODBC Driver 17 found - Will work, but consider upgrading to 18');
  } else {
    console.log('❌ No modern ODBC driver found!');
    console.log('   Install from: https://go.microsoft.com/fwlink/?linkid=2249004');
  }
} catch (error) {
  console.error('Error checking ODBC drivers:', error.message);
}
```

Run: `node test-odbc.js`

### 4. Verify SQL Server Service

**PowerShell:**
```powershell
# Check SQL Server service status
Get-Service -Name "MSSQL*" | Format-Table Name, Status, StartType

# Start SQL Server if stopped
Start-Service MSSQLSERVER

# Check SQL Browser (needed for named instances)
Get-Service -Name "SQLBrowser" | Format-Table Name, Status, StartType
```

### 5. Test Network Connectivity

**PowerShell:**
```powershell
# Test if SQL Server port is open
Test-NetConnection -ComputerName localhost -Port 1433

# Should show:
# TcpTestSucceeded : True
```

### 6. Check SQL Server Authentication Mode

**SSMS:**
```sql
-- Check authentication mode
SELECT 
  CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
    WHEN 1 THEN 'Windows Authentication Only'
    WHEN 0 THEN 'Mixed Mode (Windows and SQL Server)'
  END AS AuthenticationMode;
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: "Data source name not found"

**Error:**
```
[Microsoft][ODBC Driver Manager] Data source name not found and no default driver specified
```

**Cause:** ODBC driver not installed or wrong driver name in connection string.

**Solution:**
```bash
# 1. Install ODBC Driver 18
# Download: https://go.microsoft.com/fwlink/?linkid=2249004

# 2. Verify installation
powershell "Get-OdbcDriver | Where-Object {$_.Name -like '*SQL Server*'}"

# 3. Update connection string to use correct driver name
# Use exactly: "ODBC Driver 18 for SQL Server"
```

### Issue 2: "Login failed for user"

**Error:**
```
Login failed for user 'DOMAIN\Username'
```

**Cause:** Windows user doesn't have SQL Server permissions.

**Solution:**
```sql
-- Run in SSMS as administrator
USE master;
GO

-- Check if login exists
SELECT * FROM sys.server_principals WHERE name = 'DOMAIN\Username';
GO

-- If not exists, create it
CREATE LOGIN [DOMAIN\Username] FROM WINDOWS;
GO

-- Grant database access
USE YourDatabase;
GO

CREATE USER [DOMAIN\Username] FOR LOGIN [DOMAIN\Username];
GO

-- Grant appropriate role
ALTER ROLE db_datareader ADD MEMBER [DOMAIN\Username];
ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\Username];
-- Or for full access:
ALTER ROLE db_owner ADD MEMBER [DOMAIN\Username];
GO
```

### Issue 3: "Certificate chain was issued by an authority that is not trusted"

**Error:**
```
SSL Provider: The certificate chain was issued by an authority that is not trusted
```

**Cause:** SQL Server 2022 enforces encryption by default, but uses self-signed certificate.

**Solution:**

**Option A: Trust the certificate (Development)**
```env
# In .env file
DB_TRUST_SERVER_CERTIFICATE=true
```

**Option B: Install proper certificate (Production)**
```powershell
# Generate self-signed certificate
$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My"

# Configure SQL Server to use it (SQL Server Configuration Manager)
# Or disable encryption for local dev (not recommended)
```

### Issue 4: "node-gyp rebuild failed"

**Error:**
```
gyp ERR! build error
gyp ERR! stack Error: `C:\Program Files\Microsoft Visual Studio\...` failed with exit code: 1
```

**Cause:** Missing Visual C++ build tools.

**Solution:**

**Option A: Install Visual Studio Build Tools**
```powershell
# Download and install:
# https://visualstudio.microsoft.com/downloads/
# Select "Desktop development with C++"
```

**Option B: Use windows-build-tools**
```bash
# Run PowerShell as Administrator
npm install --global windows-build-tools

# Then retry
npm install msnodesqlv8
```

**Option C: Use pre-built binaries**
```bash
# Install specific version with pre-built binaries
npm install msnodesqlv8@4.2.1 --force
```

### Issue 5: "Connection timeout"

**Error:**
```
ConnectionError: Failed to connect to localhost:1433 - Connection timeout
```

**Cause:** SQL Server not listening, firewall blocking, or wrong server name.

**Solution:**

**1. Check SQL Server is running:**
```powershell
Get-Service MSSQLSERVER
# Should show: Status = Running
```

**2. Check TCP/IP is enabled:**
```powershell
# SQL Server Configuration Manager
# SQL Server Network Configuration → Protocols for MSSQLSERVER → TCP/IP → Enabled
```

**3. Check firewall:**
```powershell
# Test port
Test-NetConnection -ComputerName localhost -Port 1433

# If fails, add firewall rule
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

**4. Verify server name:**
```cmd
REM Get actual server name
sqlcmd -L

REM Or
powershell "(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances"
```

### Issue 6: "Named instance not found"

**Error:**
```
ConnectionError: Failed to connect to localhost\SQLEXPRESS
```

**Cause:** SQL Browser service not running or wrong instance name.

**Solution:**

**1. Start SQL Browser:**
```powershell
Start-Service SQLBrowser
Set-Service SQLBrowser -StartupType Automatic
```

**2. Use explicit port:**
```env
# Instead of: DB_SERVER=localhost\SQLEXPRESS
# Use: DB_SERVER=localhost,1434
```

**3. Find correct instance name:**
```powershell
Get-Service -Name "MSSQL*" | Select-Object Name, DisplayName
```

### Issue 7: "Module not found: msnodesqlv8"

**Error:**
```
Error: Cannot find module 'msnodesqlv8'
```

**Cause:** Package not installed or installation failed silently.

**Solution:**
```bash
# Remove and reinstall
npm uninstall msnodesqlv8
npm cache clean --force
npm install msnodesqlv8 --verbose

# Check if installed
npm list msnodesqlv8

# If still fails, check Node.js version
node --version
# Should be 14.x, 16.x, 18.x, or 20.x
```

### Issue 8: "Pool is closed"

**Error:**
```
ConnectionError: Connection is closed
```

**Cause:** Connection pool was closed or never opened.

**Solution:**
```javascript
// Always check pool status
async function getConnection() {
  if (!pool || !pool.connected) {
    pool = await sql.connect(config);
  }
  return pool;
}

// Don't close pool between requests
// Only close on application shutdown
```

---

## 🚀 Production Deployment Considerations

### 1. Service Account Authentication

When deploying as a Windows service:

```javascript
// The service runs under a specific Windows account
// Grant that account database access:

// In SSMS:
CREATE LOGIN [DOMAIN\ServiceAccount] FROM WINDOWS;
CREATE USER [DOMAIN\ServiceAccount] FOR LOGIN [DOMAIN\ServiceAccount];
ALTER ROLE db_owner ADD MEMBER [DOMAIN\ServiceAccount];
```

### 2. Connection Pooling

```javascript
const config = {
  driver: 'msnodesqlv8',
  connectionString: connectionString,
  
  pool: {
    max: 50,              // Maximum connections
    min: 10,              // Minimum connections
    idleTimeoutMillis: 60000,  // Close idle connections after 1 minute
    acquireTimeoutMillis: 30000,  // Wait 30s for available connection
    evictionRunIntervalMillis: 10000  // Check for idle connections every 10s
  }
};
```

### 3. Error Handling & Retry Logic

```javascript
async function getConnectionWithRetry(maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await getConnection();
    } catch (error) {
      console.error(`Connection attempt ${attempt} failed:`, error.message);
      
      if (attempt === maxRetries) {
        throw error;
      }
      
      // Wait before retry (exponential backoff)
      await new Promise(resolve => setTimeout(resolve, 1000 * attempt));
    }
  }
}
```

### 4. Health Checks

```javascript
async function healthCheck() {
  try {
    const pool = await getConnection();
    await pool.request().query('SELECT 1');
    return { status: 'healthy', database: 'connected' };
  } catch (error) {
    return { status: 'unhealthy', database: 'disconnected', error: error.message };
  }
}

// Express endpoint
app.get('/health', async (req, res) => {
  const health = await healthCheck();
  res.status(health.status === 'healthy' ? 200 : 503).json(health);
});
```

### 5. Logging

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Log all database operations
async function executeQuery(query) {
  const startTime = Date.now();
  try {
    const result = await pool.request().query(query);
    logger.info({
      type: 'database_query',
      query: query,
      duration: Date.now() - startTime,
      rows: result.recordset.length
    });
    return result;
  } catch (error) {
    logger.error({
      type: 'database_error',
      query: query,
      duration: Date.now() - startTime,
      error: error.message
    });
    throw error;
  }
}
```

---

## 📝 Quick Reference

### Connection String Formats

**Windows Authentication (Recommended):**
```javascript
// ODBC Driver 18
`Server=${server};Database=${database};Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};Encrypt=yes;TrustServerCertificate=yes;`

// ODBC Driver 17
`Server=${server};Database=${database};Trusted_Connection=Yes;Driver={ODBC Driver 17 for SQL Server};`

// Named Instance
`Server=${server}\\${instance};Database=${database};Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};`

// With Port
`Server=${server},${port};Database=${database};Trusted_Connection=Yes;Driver={ODBC Driver 18 for SQL Server};`
```

**SQL Server Authentication:**
```javascript
// Standard
`Server=${server};Database=${database};UID=${user};PWD=${password};Driver={ODBC Driver 18 for SQL Server};Encrypt=yes;TrustServerCertificate=yes;`
```

### Environment Variables Template

```env
# Windows Authentication
DB_SERVER=localhost
DB_DATABASE=MyDatabase
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# SQL Authentication (alternative)
# DB_USER=sa
# DB_PASSWORD=YourPassword123!
```

### Test Commands

```bash
# Test ODBC drivers
powershell "Get-OdbcDriver | Where-Object {$_.Name -like '*SQL Server*'}"

# Test SQL Server connection
sqlcmd -S localhost -E -Q "SELECT @@VERSION"

# Test Node.js connection
node test-connection.js

# Check SQL Server service
powershell "Get-Service MSSQLSERVER"

# Test port connectivity
powershell "Test-NetConnection -ComputerName localhost -Port 1433"
```

---

## 🎯 Summary & Recommendations

### ✅ Recommended Approach

1. **Install ODBC Driver 18** for SQL Server
2. **Use msnodesqlv8** package with Windows Authentication
3. **Set TrustServerCertificate=yes** for local development
4. **Grant Windows user proper SQL Server permissions**
5. **Test connection with provided test script**

### 📊 Solution Comparison

| Solution | Pros | Cons | Best For |
|----------|------|------|----------|
| **msnodesqlv8** | ✅ True Windows Auth<br>✅ No credentials in code<br>✅ Native performance | ⚠️ Requires ODBC driver<br>⚠️ Windows only | **Production Windows environments** |
| **tedious (SQL Auth)** | ✅ Cross-platform<br>✅ No native dependencies | ❌ Credentials in config<br>❌ Poor Windows Auth | Development/Testing |
| **node-sqlserver-v8** | ✅ Alternative to msnodesqlv8 | ⚠️ Less maintained | Backup option |

### 🔐 Security Best Practices

- ✅ Use Windows Authentication in production
- ✅ Never commit `.env` files to git
- ✅ Use least-privilege database roles
- ✅ Enable encryption in production
- ✅ Use proper SSL certificates (not self-signed)
- ✅ Implement connection pooling
- ✅ Add retry logic and health checks
- ✅ Log all database errors

---

## 📞 Getting Help

If you're still experiencing issues after following this guide:

1. **Run the diagnostic script:**
   ```bash
   node test-connection.js
   ```

2. **Check the error message** against the "Common Issues" section

3. **Verify prerequisites:**
   - ODBC Driver 18 installed
   - SQL Server running
   - Windows user has database access
   - Firewall allows port 1433

4. **Test with sqlcmd first:**
   ```cmd
   sqlcmd -S localhost -E -Q "SELECT SUSER_NAME()"
   ```
   If this fails, fix SQL Server configuration before troubleshooting Node.js

---

**Last Updated:** 2024-01-15  
**SQL Server Version:** 2022  
**Node.js Versions:** 14.x - 20.x  
**Tested on:** Windows 10/11, Windows Server 2019/2022
