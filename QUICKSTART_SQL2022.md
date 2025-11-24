# Quick Start: SQL Server 2022 Windows Authentication

**Goal:** Connect your Node.js app to SQL Server 2022 using Windows Integrated Security in under 10 minutes.

---

## ⚡ 5-Minute Setup

### Step 1: Install ODBC Driver (2 minutes)

**Download and install ODBC Driver 18:**
```
https://go.microsoft.com/fwlink/?linkid=2249004
```

Or use PowerShell (as Administrator):
```powershell
# Download and install silently
$url = "https://go.microsoft.com/fwlink/?linkid=2249004"
$output = "$env:TEMP\msodbcsql.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -ArgumentList "/i $output /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait
Write-Host "✅ ODBC Driver 18 installed!"
```

**Verify:**
```powershell
Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}
```

### Step 2: Install Node Package (1 minute)

```bash
npm install msnodesqlv8
```

**If it fails with build errors:**
```bash
# Install build tools first (PowerShell as Admin)
npm install --global windows-build-tools

# Then retry
npm install msnodesqlv8
```

### Step 3: Configure Environment (1 minute)

**Create or update `.env` file:**
```env
# Your SQL Server details
DB_SERVER=localhost
DB_DATABASE=YourDatabaseName
DB_PORT=1433

# SQL Server 2022 settings
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# App settings
PORT=5000
NODE_ENV=development
```

**Replace:**
- `localhost` with your SQL Server name (or keep as-is for local)
- `YourDatabaseName` with your actual database name

**Find your server name:**
```cmd
sqlcmd -L
```

### Step 4: Grant Database Access (1 minute)

**Run in SQL Server Management Studio (SSMS):**

```sql
-- Find your Windows username first
-- Open Command Prompt and run: whoami
-- Example output: DOMAIN\YourUsername

USE master;
GO

-- Create login (replace with your username from whoami)
CREATE LOGIN [DOMAIN\YourUsername] FROM WINDOWS;
GO

-- Grant database access
USE YourDatabaseName;  -- Replace with your database
GO

CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
GO

-- Grant permissions (use appropriate role)
ALTER ROLE db_owner ADD MEMBER [DOMAIN\YourUsername];
GO

-- Verify
SELECT SUSER_NAME() AS 'You are logged in as';
```

### Step 5: Test Connection (30 seconds)

```bash
node test-connection.js
```

**Expected output:**
```
✅ ALL TESTS PASSED!
🎉 Your Node.js application can now connect to SQL Server 2022!
```

---

## 🚀 Using in Your Application

### Option 1: Use the New Configuration (Recommended)

**Update your imports:**

```javascript
// Replace your old database import
// const { getConnection } = require('./server/config/database');

// With the new Windows Auth configuration
const { getConnection } = require('./server/config/database-windows-auth');

// Everything else stays the same!
async function example() {
  const pool = await getConnection();
  const result = await pool.request().query('SELECT * FROM YourTable');
  console.log(result.recordset);
}
```

### Option 2: Update Existing Configuration

**Edit `server/config/database.js`:**

```javascript
const sql = require('mssql');
require('dotenv').config();

// Build connection string for Windows Authentication
const connectionString = 
  `Server=${process.env.DB_SERVER},${process.env.DB_PORT};` +
  `Database=${process.env.DB_DATABASE};` +
  `Trusted_Connection=Yes;` +
  `Driver={ODBC Driver 18 for SQL Server};` +
  `Encrypt=yes;` +
  `TrustServerCertificate=yes;`;

const config = {
  driver: 'msnodesqlv8',  // ← Change this
  connectionString: connectionString,  // ← Add this
  
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

// Rest of your code stays the same
```

---

## ✅ Verification Checklist

Before starting your app, verify:

- [ ] ODBC Driver 18 installed
  ```powershell
  Get-OdbcDriver -Name "ODBC Driver 18 for SQL Server"
  ```

- [ ] msnodesqlv8 package installed
  ```bash
  npm list msnodesqlv8
  ```

- [ ] `.env` file configured with correct server and database

- [ ] Windows user has database access
  ```cmd
  sqlcmd -S localhost -E -Q "SELECT SUSER_NAME()"
  ```

- [ ] Test connection passes
  ```bash
  node test-connection.js
  ```

---

## 🎯 Start Your Application

```bash
# Start backend
npm run server

# In another terminal, start frontend
npm run dev
```

**You should see:**
```
🔌 Connecting to SQL Server 2022...
   Driver: msnodesqlv8 (ODBC Driver 18 for SQL Server)
   Server: localhost:1433
   Database: YourDatabase
   Authentication: Windows Integrated Security
✅ Database connected successfully!
   Connected as: DOMAIN\YourUsername
   SQL Version: Microsoft SQL Server 2022 (RTM) - 16.0.1000.6
```

---

## ❌ Common Issues

### "Data source name not found"

**Problem:** ODBC Driver not installed

**Fix:**
```powershell
# Install ODBC Driver 18
# Download: https://go.microsoft.com/fwlink/?linkid=2249004
```

### "Login failed for user"

**Problem:** Windows user lacks database permissions

**Fix:** Run the SQL script in Step 4 above

### "Certificate chain was issued by an authority that is not trusted"

**Problem:** SQL Server 2022 enforces encryption

**Fix:** Add to `.env`:
```env
DB_TRUST_SERVER_CERTIFICATE=true
```

### "node-gyp rebuild failed"

**Problem:** Missing build tools

**Fix:**
```bash
# PowerShell as Administrator
npm install --global windows-build-tools

# Then retry
npm install msnodesqlv8
```

### "Connection timeout"

**Problem:** SQL Server not accessible

**Fix:**
```powershell
# 1. Check SQL Server is running
Get-Service MSSQLSERVER

# 2. Test connectivity
Test-NetConnection -ComputerName localhost -Port 1433

# 3. If fails, check firewall
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

---

## 📚 Need More Help?

- **Detailed Guide:** See `SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`
- **Diagnostic Test:** Run `node test-connection.js`
- **Check Logs:** Look at console output for specific error messages

---

## 🔐 Security Notes

✅ **What's Good:**
- No passwords in code or config files
- Uses Windows authentication (most secure)
- Each user connects as themselves
- Full audit trail in SQL Server

⚠️ **For Production:**
- Use proper SSL certificates (not self-signed)
- Grant minimum required permissions (not db_owner)
- Use service accounts for automated processes
- Enable SQL Server auditing

---

## 🎉 Success!

If `test-connection.js` passes, you're ready to go!

Your application now uses:
- ✅ Windows Integrated Security
- ✅ No credentials in code
- ✅ SQL Server 2022 compatible
- ✅ Production-ready configuration

**Next Steps:**
1. Start your application: `npm run server`
2. Test your endpoints
3. Deploy with confidence!

---

**Questions?** Check the comprehensive guide: `SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`
