# 🚀 START HERE - SQL Server 2022 Windows Authentication

## Welcome!

You need to connect your Node.js application to SQL Server 2022 using Windows Integrated Security. This guide will get you there in **3 simple steps**.

---

## ⚡ The 3-Step Solution

### Step 1: Install ODBC Driver 18 (2 minutes)

**Open PowerShell as Administrator** and run:

```powershell
$url = "https://go.microsoft.com/fwlink/?linkid=2249004"
$output = "$env:TEMP\msodbcsql.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -ArgumentList "/i $output /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait
Write-Host "✅ ODBC Driver 18 installed!"
```

**Verify it worked:**
```powershell
Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}
```

You should see: `ODBC Driver 18 for SQL Server`

---

### Step 2: Install Node Package (1 minute)

**In your project directory:**

```bash
npm install msnodesqlv8
```

**If you get build errors:**
```bash
# Install build tools first (PowerShell as Admin)
npm install --global windows-build-tools

# Then retry
npm install msnodesqlv8
```

---

### Step 3: Configure & Test (2 minutes)

**A. Update your `.env` file:**

```env
DB_SERVER=localhost
DB_DATABASE=YourDatabaseName
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
```

Replace `YourDatabaseName` with your actual database name.

**B. Grant yourself database access (run in SSMS):**

```sql
-- First, find your Windows username
-- Open Command Prompt and run: whoami
-- Example: DOMAIN\YourUsername

USE master;
GO

CREATE LOGIN [DOMAIN\YourUsername] FROM WINDOWS;
GO

USE YourDatabaseName;  -- Replace with your database
GO

CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
GO

ALTER ROLE db_owner ADD MEMBER [DOMAIN\YourUsername];
GO
```

**C. Test the connection:**

```bash
node test-connection.js
```

**Expected output:**
```
✅ ALL TESTS PASSED!
🎉 Your Node.js application can now connect to SQL Server 2022!
```

---

## ✅ That's It!

If the test passed, you're done! Your application can now connect to SQL Server 2022 using Windows Authentication.

---

## 🎯 Next Steps

### Update Your Application

**Option 1: Use the new configuration file (recommended)**

```javascript
// In your code, replace:
// const { getConnection } = require('./server/config/database');

// With:
const { getConnection } = require('./server/config/database-windows-auth');

// Everything else stays the same!
```

**Option 2: Update your existing database.js**

See [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md) for details.

---

## ❌ Troubleshooting

### Test Failed?

Run the diagnostic test to see exactly what's wrong:

```bash
node test-connection.js
```

The test will tell you:
- ✅ What's working
- ❌ What's broken
- 💡 How to fix it

### Common Issues

| Problem | Quick Fix |
|---------|-----------|
| "Data source name not found" | ODBC Driver not installed - go back to Step 1 |
| "Login failed for user" | Run the SQL script in Step 3B |
| "Certificate chain" error | Add `DB_TRUST_SERVER_CERTIFICATE=true` to `.env` |
| "node-gyp rebuild failed" | Install build tools: `npm install -g windows-build-tools` |

---

## 📚 Want to Learn More?

### Quick Reference

- **Quick Start Guide:** [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md) - 10-minute setup
- **Complete Guide:** [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md) - Everything you need to know
- **Driver Comparison:** [`DRIVER_COMPARISON.md`](./DRIVER_COMPARISON.md) - Why msnodesqlv8?
- **Documentation Index:** [`README_SQL_SERVER_2022.md`](./README_SQL_SERVER_2022.md) - All docs

### What You're Getting

✅ **Secure** - No passwords in code  
✅ **Fast** - Native ODBC performance  
✅ **Simple** - Windows handles authentication  
✅ **Production-Ready** - Connection pooling, error handling  
✅ **Well-Documented** - Comprehensive guides  

---

## 🔑 Key Points

### Why This Solution?

**The Problem:**
- `tedious` (default driver) has poor Windows Authentication support
- SQL Server 2022 has stricter security requirements
- You need true Windows Integrated Security

**The Solution:**
- `msnodesqlv8` uses native Windows ODBC drivers
- Properly supports Windows Authentication
- Works perfectly with SQL Server 2022

### What Changed?

**Before (doesn't work well):**
```javascript
const config = {
  server: 'localhost',
  database: 'MyDB',
  options: {
    trustedConnection: true  // Ignored by tedious!
  }
};
```

**After (works perfectly):**
```javascript
const connectionString = 
  `Server=localhost,1433;` +
  `Database=MyDB;` +
  `Trusted_Connection=Yes;` +
  `Driver={ODBC Driver 18 for SQL Server};`;

const config = {
  driver: 'msnodesqlv8',
  connectionString: connectionString
};
```

---

## 🎉 Success!

Once `node test-connection.js` passes, you're ready to:

1. ✅ Start your application
2. ✅ Connect to SQL Server securely
3. ✅ Deploy with confidence

**No passwords in code. No security risks. Just works!**

---

## 🆘 Need Help?

1. **Run diagnostics:** `node test-connection.js`
2. **Check the error** against troubleshooting section above
3. **Read the guides:** Start with [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)
4. **Review your setup:** Make sure all 3 steps are complete

---

## 📝 Checklist

Before asking for help, verify:

- [ ] ODBC Driver 18 installed (`Get-OdbcDriver` shows it)
- [ ] msnodesqlv8 package installed (`npm list msnodesqlv8`)
- [ ] `.env` file configured with correct server/database
- [ ] Windows user has database access (ran SQL script)
- [ ] SQL Server is running (`Get-Service MSSQLSERVER`)
- [ ] Can connect with sqlcmd: `sqlcmd -S localhost -E`

---

**Ready?** Follow the 3 steps above and you'll be connected in 5 minutes! 🚀

**Questions?** Check [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md) for detailed instructions.

**Problems?** Run `node test-connection.js` to diagnose the issue.
