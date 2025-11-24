# 🎯 Alternative SQL Server Connection Solutions

## Current Problem

You're experiencing: `The "config.server" property is required and must be of type string.`

**Root Cause:** `msnodesqlv8` is not properly installed/compiled, and `mssql` is falling back to `tedious` which doesn't handle the connection string format.

---

## ✅ SOLUTION 1: Properly Install msnodesqlv8 (Recommended for Windows)

### Prerequisites Check

```powershell
# 1. Check if you have Visual Studio Build Tools
npm config get msvs_version

# 2. Check if you have Python
python --version

# 3. Check Node.js version (should be LTS)
node --version
```

### Installation Steps

```powershell
# Step 1: Install Windows Build Tools (if needed)
npm install --global windows-build-tools

# Step 2: Install msnodesqlv8 with verbose logging
npm install msnodesqlv8 --save --verbose

# Step 3: Verify installation
npm list msnodesqlv8
```

### If Installation Succeeds

Test immediately:
```powershell
node test-db-connection-simple.js
```

### If Installation Fails

You'll see errors about:
- Missing Visual C++ Build Tools
- Python not found
- node-gyp compilation errors

**→ Move to Solution 2**

---

## ✅ SOLUTION 2: Use node-sqlserver-v8 (Alternative Native Driver)

This is a more reliable alternative to msnodesqlv8 with better installation success rate.

### Installation

```powershell
npm uninstall msnodesqlv8
npm install node-sqlserver-v8 --save
```

### Update Configuration

Create new file: `server/config/database-v8.js`

```javascript
const sql8 = require('node-sqlserver-v8');
require('dotenv').config();

const connectionString = 
  `Server=${process.env.DB_SERVER},${process.env.DB_PORT || 1433};` +
  `Database=${process.env.DB_DATABASE};` +
  `Trusted_Connection=Yes;` +
  `Driver={${process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server'}};` +
  `TrustServerCertificate=yes;`;

let pool = null;

async function getConnection() {
  return new Promise((resolve, reject) => {
    if (pool) {
      return resolve(pool);
    }
    
    console.log('🔌 Connecting with node-sqlserver-v8...');
    console.log('   Connection String:', connectionString);
    
    sql8.open(connectionString, (err, conn) => {
      if (err) {
        console.error('❌ Connection failed:', err.message);
        return reject(err);
      }
      
      pool = conn;
      console.log('✅ Connected successfully!');
      resolve(conn);
    });
  });
}

async function executeQuery(query, params = []) {
  const conn = await getConnection();
  
  return new Promise((resolve, reject) => {
    conn.query(query, params, (err, results) => {
      if (err) return reject(err);
      resolve(results);
    });
  });
}

async function executeStoredProcedure(procName, params = {}) {
  const conn = await getConnection();
  
  // Build parameter string
  const paramArray = Object.entries(params).map(([key, value]) => {
    if (typeof value === 'string') return `@${key}='${value}'`;
    if (value === null) return `@${key}=NULL`;
    return `@${key}=${value}`;
  });
  
  const query = `EXEC ${procName} ${paramArray.join(', ')}`;
  
  return new Promise((resolve, reject) => {
    conn.query(query, (err, results) => {
      if (err) return reject(err);
      resolve(results);
    });
  });
}

async function closeConnection() {
  if (pool) {
    pool.close(() => {
      console.log('✅ Connection closed');
      pool = null;
    });
  }
}

module.exports = {
  getConnection,
  executeQuery,
  executeStoredProcedure,
  closeConnection
};
```

### Test It

```powershell
node -e "const db = require('./server/config/database-v8'); db.executeQuery('SELECT @@VERSION').then(r => console.log(r)).catch(e => console.error(e));"
```

---

## ✅ SOLUTION 3: Use SQL Authentication (Easiest, Most Reliable)

If Windows Authentication continues to be problematic, switch to SQL Authentication.

### Step 1: Create SQL Server Login

Run in SSMS:

```sql
USE [master];
GO

-- Create SQL login
CREATE LOGIN [BookingImporterApp] 
WITH PASSWORD = 'YourSecurePassword123!',
     CHECK_POLICY = OFF,
     CHECK_EXPIRATION = OFF;
GO

USE [Accounts];
GO

-- Create user in database
CREATE USER [BookingImporterApp] 
FOR LOGIN [BookingImporterApp];
GO

-- Grant permissions
ALTER ROLE db_datareader ADD MEMBER [BookingImporterApp];
ALTER ROLE db_datawriter ADD MEMBER [BookingImporterApp];
GRANT EXECUTE TO [BookingImporterApp];
GO
```

### Step 2: Update .env

```env
USE_WINDOWS_AUTH=false

DB_SERVER=THSACCStaTst051
DB_DATABASE=Accounts
DB_PORT=1433
DB_USER=BookingImporterApp
DB_PASSWORD=YourSecurePassword123!

DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
```

### Step 3: Test

```powershell
node test-db-connection-simple.js
```

**This will work immediately** because `mssql` with `tedious` driver handles SQL Auth perfectly.

---

## ✅ SOLUTION 4: Use ODBC Package Directly

Bypass mssql entirely and use ODBC directly.

### Installation

```powershell
npm install odbc --save
```

### Create New Database Config

Create: `server/config/database-odbc.js`

```javascript
const odbc = require('odbc');
require('dotenv').config();

const connectionString = 
  `Driver={${process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server'}};` +
  `Server=${process.env.DB_SERVER},${process.env.DB_PORT || 1433};` +
  `Database=${process.env.DB_DATABASE};` +
  `Trusted_Connection=Yes;` +
  `TrustServerCertificate=yes;`;

let pool = null;

async function getConnection() {
  if (pool) {
    return pool;
  }
  
  console.log('🔌 Connecting with ODBC...');
  console.log('   Connection String:', connectionString);
  
  pool = await odbc.pool(connectionString);
  
  console.log('✅ Connected successfully!');
  return pool;
}

async function executeQuery(query, params = []) {
  const pool = await getConnection();
  const result = await pool.query(query, params);
  return result;
}

async function executeStoredProcedure(procName, params = {}) {
  const pool = await getConnection();
  
  // Build CALL statement
  const paramPlaceholders = Object.keys(params).map(() => '?').join(', ');
  const query = `{CALL ${procName}(${paramPlaceholders})}`;
  const paramValues = Object.values(params);
  
  const result = await pool.query(query, paramValues);
  return result;
}

async function closeConnection() {
  if (pool) {
    await pool.close();
    pool = null;
    console.log('✅ Connection closed');
  }
}

module.exports = {
  getConnection,
  executeQuery,
  executeStoredProcedure,
  closeConnection
};
```

### Test It

```powershell
node -e "const db = require('./server/config/database-odbc'); db.executeQuery('SELECT @@VERSION').then(r => console.log(r)).catch(e => console.error(e));"
```

---

## 📊 Solution Comparison

| Solution | Difficulty | Reliability | Windows Auth | Performance |
|----------|-----------|-------------|--------------|-------------|
| **msnodesqlv8** | ⭐⭐⭐ Hard | ⭐⭐ Medium | ✅ Yes | ⭐⭐⭐⭐ Excellent |
| **node-sqlserver-v8** | ⭐⭐ Medium | ⭐⭐⭐ Good | ✅ Yes | ⭐⭐⭐⭐ Excellent |
| **SQL Auth (tedious)** | ⭐ Easy | ⭐⭐⭐⭐ Excellent | ❌ No | ⭐⭐⭐ Good |
| **ODBC package** | ⭐⭐ Medium | ⭐⭐⭐⭐ Excellent | ✅ Yes | ⭐⭐⭐⭐ Excellent |

---

## 🎯 RECOMMENDED ACTION PLAN

### For Your Situation (Windows + Need Windows Auth):

**Try in this order:**

1. **First: Fix msnodesqlv8 installation** (10 minutes)
   ```powershell
   npm install --global windows-build-tools
   npm install msnodesqlv8 --save --verbose
   ```
   
   If successful → Test and you're done! ✅

2. **If that fails: Try ODBC package** (15 minutes)
   ```powershell
   npm install odbc --save
   ```
   
   Use `database-odbc.js` configuration above
   
   If successful → Production ready! ✅

3. **If that fails: Use SQL Authentication** (5 minutes)
   - Create SQL login in SSMS
   - Update .env
   - Works immediately! ✅

---

## 🔧 Quick Fix Script

Save this as `fix-connection.ps1`:

```powershell
# Quick Fix Script for SQL Server Connection

Write-Host "=== SQL Server Connection Fix Script ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Try msnodesqlv8
Write-Host "Test 1: Checking msnodesqlv8..." -ForegroundColor Yellow
$msnodesqlv8 = npm list msnodesqlv8 2>&1
if ($msnodesqlv8 -match "msnodesqlv8@") {
    Write-Host "✅ msnodesqlv8 is installed" -ForegroundColor Green
    Write-Host "Testing connection..." -ForegroundColor Yellow
    node test-db-connection-simple.js
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connection works! You're all set!" -ForegroundColor Green
        exit 0
    }
} else {
    Write-Host "❌ msnodesqlv8 not installed" -ForegroundColor Red
    Write-Host "Attempting to install..." -ForegroundColor Yellow
    npm install msnodesqlv8 --save
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Installation successful!" -ForegroundColor Green
        Write-Host "Testing connection..." -ForegroundColor Yellow
        node test-db-connection-simple.js
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Connection works! You're all set!" -ForegroundColor Green
            exit 0
        }
    }
}

# Test 2: Try ODBC package
Write-Host ""
Write-Host "Test 2: Trying ODBC package..." -ForegroundColor Yellow
npm install odbc --save

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ ODBC package installed" -ForegroundColor Green
    Write-Host "Creating configuration..." -ForegroundColor Yellow
    # Copy database-odbc.js configuration
    Write-Host "✅ Use Solution 4 from SOLUTION_ALTERNATIVE_DRIVERS.md" -ForegroundColor Green
}

# Test 3: Suggest SQL Auth
Write-Host ""
Write-Host "Test 3: SQL Authentication (fallback)" -ForegroundColor Yellow
Write-Host "If above solutions don't work, use SQL Authentication:" -ForegroundColor Cyan
Write-Host "1. Create SQL login in SSMS" -ForegroundColor White
Write-Host "2. Update .env with USE_WINDOWS_AUTH=false" -ForegroundColor White
Write-Host "3. Add DB_USER and DB_PASSWORD" -ForegroundColor White
Write-Host ""
Write-Host "See Solution 3 in SOLUTION_ALTERNATIVE_DRIVERS.md" -ForegroundColor Cyan
```

Run it:
```powershell
powershell -ExecutionPolicy Bypass -File fix-connection.ps1
```

---

## 📝 Summary

**Your Issue:** msnodesqlv8 not properly installed → mssql falls back to tedious → tedious doesn't understand connection string format

**Best Solutions:**
1. ✅ **Fix msnodesqlv8 installation** (if you can compile native modules)
2. ✅ **Use ODBC package** (reliable, native, Windows Auth)
3. ✅ **Use SQL Authentication** (easiest, works immediately)

**Next Step:** Choose one solution above and follow its steps.

---

*Created: November 24, 2025*
*For: Windows + SQL Server 2022 + Node.js*
