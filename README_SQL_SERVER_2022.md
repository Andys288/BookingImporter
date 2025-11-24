# SQL Server 2022 Windows Authentication - Complete Solution

## 📚 Documentation Overview

This repository now includes comprehensive documentation for connecting Node.js to SQL Server 2022 using Windows Integrated Security.

---

## 🚀 Quick Start (5 minutes)

**Want to get started immediately?**

👉 **Read:** [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)

This guide will have you connected in under 10 minutes with step-by-step instructions.

---

## 📖 Complete Documentation

### 1. **Quick Start Guide** 
📄 [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)

**For:** Getting up and running fast  
**Time:** 5-10 minutes  
**Includes:**
- 5-step setup process
- Installation commands
- Configuration examples
- Common issues and fixes

---

### 2. **Comprehensive Guide**
📄 [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md)

**For:** Complete understanding and troubleshooting  
**Time:** 30-60 minutes (reference)  
**Includes:**
- Why previous approaches failed
- 3 different solution approaches
- Detailed prerequisites
- Diagnostic tools and testing
- 8 common issues with solutions
- Production deployment considerations
- Security best practices

---

### 3. **Driver Comparison**
📄 [`DRIVER_COMPARISON.md`](./DRIVER_COMPARISON.md)

**For:** Understanding your options  
**Time:** 15 minutes  
**Includes:**
- Comparison of tedious vs msnodesqlv8
- Pros and cons of each approach
- Performance benchmarks
- Security comparison
- Decision matrix
- Migration guide

---

### 4. **Connection Test Script**
📄 [`test-connection.js`](./test-connection.js)

**For:** Diagnosing connection issues  
**Usage:** `node test-connection.js`  
**Features:**
- Checks all prerequisites
- Tests ODBC drivers
- Verifies SQL Server service
- Tests network connectivity
- Tests sqlcmd connection
- Tests Node.js connection
- Provides specific error solutions

---

### 5. **Database Configuration**
📄 [`server/config/database-windows-auth.js`](./server/config/database-windows-auth.js)

**For:** Production-ready database connection  
**Features:**
- Windows Integrated Security
- Automatic error handling
- Detailed troubleshooting messages
- Connection pooling
- Graceful shutdown
- Helper functions for queries and stored procedures

---

## 🎯 Which Document Should I Read?

### I want to connect RIGHT NOW
👉 Start with [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)

### I'm getting errors
👉 Run `node test-connection.js` first  
👉 Then check [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md) - Section 7: Common Issues

### I need to understand the options
👉 Read [`DRIVER_COMPARISON.md`](./DRIVER_COMPARISON.md)

### I want to implement this properly
👉 Read [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md) - Complete guide

### I'm migrating from tedious
👉 Read [`DRIVER_COMPARISON.md`](./DRIVER_COMPARISON.md) - Migration Guide section

---

## 🔑 Key Concepts

### What is Windows Integrated Security?

Windows Integrated Security (also called Windows Authentication or Trusted Connection) allows your Node.js application to connect to SQL Server using the Windows credentials of the user running the application.

**Benefits:**
- ✅ No passwords in code or config files
- ✅ Uses existing Windows/Active Directory security
- ✅ Each user connects as themselves (audit trail)
- ✅ Automatic password rotation (Windows handles it)
- ✅ Most secure option for Windows environments

### Why msnodesqlv8?

The `msnodesqlv8` package uses native Windows ODBC drivers, which properly support Windows Integrated Security. The default `tedious` driver is pure JavaScript and has poor Windows Authentication support.

**Think of it like this:**
- `tedious` = Trying to speak Spanish using an English-Spanish dictionary
- `msnodesqlv8` = Having a native Spanish speaker translate for you

---

## 📋 Prerequisites Checklist

Before you start, make sure you have:

- [ ] **Windows OS** (Windows 10/11 or Windows Server)
- [ ] **Node.js** (14.x - 20.x)
- [ ] **SQL Server 2022** (or 2019, 2017)
- [ ] **Admin access** to SQL Server (to grant permissions)
- [ ] **ODBC Driver 18** for SQL Server ([download](https://go.microsoft.com/fwlink/?linkid=2249004))
- [ ] **Visual C++ Build Tools** (for compiling msnodesqlv8)

---

## 🚦 Getting Started

### Step 1: Choose Your Path

**Path A: Quick Start (Recommended for first-time users)**
```bash
# Follow the quick start guide
cat QUICKSTART_SQL2022.md
```

**Path B: Comprehensive Setup (Recommended for production)**
```bash
# Read the complete guide
cat SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md
```

### Step 2: Install Prerequisites

```powershell
# Install ODBC Driver 18 (PowerShell as Admin)
$url = "https://go.microsoft.com/fwlink/?linkid=2249004"
$output = "$env:TEMP\msodbcsql.msi"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process msiexec.exe -ArgumentList "/i $output /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait
```

### Step 3: Install Node Package

```bash
npm install msnodesqlv8 mssql
```

### Step 4: Configure Environment

```env
# .env file
DB_SERVER=localhost
DB_DATABASE=YourDatabase
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
```

### Step 5: Test Connection

```bash
node test-connection.js
```

---

## 🔧 Troubleshooting

### Quick Diagnostics

```bash
# Run the diagnostic test
node test-connection.js
```

This will check:
1. ✅ Prerequisites (Node.js, environment variables)
2. ✅ ODBC drivers installed
3. ✅ SQL Server service running
4. ✅ Network connectivity
5. ✅ sqlcmd connection (OS-level Windows Auth)
6. ✅ Node.js connection

### Common Issues

| Error | Solution | Guide Section |
|-------|----------|---------------|
| "Data source name not found" | Install ODBC Driver 18 | [Issue 1](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#issue-1-data-source-name-not-found) |
| "Login failed for user" | Grant database access | [Issue 2](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#issue-2-login-failed-for-user) |
| "Certificate chain" error | Set `DB_TRUST_SERVER_CERTIFICATE=true` | [Issue 3](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#issue-3-certificate-chain-was-issued-by-an-authority-that-is-not-trusted) |
| "node-gyp rebuild failed" | Install Windows Build Tools | [Issue 4](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#issue-4-node-gyp-rebuild-failed) |
| "Connection timeout" | Check SQL Server service & firewall | [Issue 5](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#issue-5-connection-timeout) |

---

## 💻 Code Examples

### Basic Connection

```javascript
const { getConnection } = require('./server/config/database-windows-auth');

async function example() {
  try {
    const pool = await getConnection();
    const result = await pool.request().query('SELECT @@VERSION');
    console.log(result.recordset);
  } catch (error) {
    console.error('Error:', error.message);
  }
}
```

### Query with Parameters

```javascript
const { executeQuery } = require('./server/config/database-windows-auth');

async function getUserById(userId) {
  const result = await executeQuery(
    'SELECT * FROM Users WHERE UserId = @userId',
    { userId: userId }
  );
  return result.recordset[0];
}
```

### Stored Procedure

```javascript
const { executeStoredProcedure, sql } = require('./server/config/database-windows-auth');

async function callProcedure() {
  const result = await executeStoredProcedure('MyStoredProcedure', {
    param1: { type: sql.Int, value: 123 },
    param2: { type: sql.VarChar(50), value: 'test' },
    outputParam: { type: sql.Int, output: true }
  });
  
  console.log('Output:', result.output.outputParam);
  return result.recordset;
}
```

---

## 🔐 Security Best Practices

### ✅ Do This

1. **Use Windows Authentication** (not SQL Auth) in production
2. **Grant minimum permissions** (not db_owner unless necessary)
3. **Use environment variables** for configuration
4. **Never commit `.env` files** to git
5. **Enable SQL Server auditing** for compliance
6. **Use proper SSL certificates** in production
7. **Implement connection pooling** (already done in config)
8. **Add retry logic** for transient failures

### ❌ Don't Do This

1. ❌ Don't hardcode server names or credentials
2. ❌ Don't use SQL Authentication if Windows Auth is available
3. ❌ Don't grant excessive permissions
4. ❌ Don't ignore certificate warnings in production
5. ❌ Don't commit sensitive data to version control
6. ❌ Don't use deprecated drivers (SQL Server Native Client 11.0)

---

## 📊 Performance Tips

1. **Use connection pooling** (enabled by default in config)
2. **Reuse connections** (don't create new pool for each request)
3. **Use parameterized queries** (prevents SQL injection + better performance)
4. **Close connections on shutdown** (handled automatically in config)
5. **Monitor connection pool** usage in production

---

## 🚀 Production Deployment

### Checklist

- [ ] ODBC Driver 18 installed on production server
- [ ] Service account has database access
- [ ] Connection pooling configured appropriately
- [ ] Error handling and logging implemented
- [ ] Health check endpoint added
- [ ] Monitoring and alerting set up
- [ ] SSL certificates properly configured
- [ ] Firewall rules configured
- [ ] Backup and recovery tested

### Service Account Setup

```sql
-- Run in SSMS on production server
USE master;
GO

-- Create login for service account
CREATE LOGIN [DOMAIN\ServiceAccount] FROM WINDOWS;
GO

USE YourDatabase;
GO

-- Create user
CREATE USER [DOMAIN\ServiceAccount] FOR LOGIN [DOMAIN\ServiceAccount];
GO

-- Grant appropriate permissions (adjust as needed)
ALTER ROLE db_datareader ADD MEMBER [DOMAIN\ServiceAccount];
ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\ServiceAccount];
GRANT EXECUTE ON SCHEMA::dbo TO [DOMAIN\ServiceAccount];
GO
```

---

## 📈 Monitoring

### Health Check Endpoint

```javascript
const { testConnection } = require('./server/config/database-windows-auth');

app.get('/health', async (req, res) => {
  const dbHealth = await testConnection();
  
  res.status(dbHealth.success ? 200 : 503).json({
    status: dbHealth.success ? 'healthy' : 'unhealthy',
    database: dbHealth.success ? 'connected' : 'disconnected',
    timestamp: new Date().toISOString(),
    details: dbHealth.data || { error: dbHealth.error }
  });
});
```

---

## 🆘 Getting Help

### Self-Service

1. **Run diagnostics:** `node test-connection.js`
2. **Check error message** against [Common Issues](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md#common-issues--solutions)
3. **Review logs** for specific error details
4. **Verify prerequisites** are all installed

### Documentation

- **Quick Start:** [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)
- **Complete Guide:** [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md)
- **Driver Comparison:** [`DRIVER_COMPARISON.md`](./DRIVER_COMPARISON.md)

### External Resources

- **ODBC Driver 18:** https://go.microsoft.com/fwlink/?linkid=2249004
- **msnodesqlv8 GitHub:** https://github.com/TimelordUK/node-sqlserver-v8
- **mssql Package:** https://www.npmjs.com/package/mssql
- **SQL Server Docs:** https://docs.microsoft.com/en-us/sql/

---

## 📝 Summary

### What You Get

✅ **Secure Connection** - Windows Integrated Security (no passwords in code)  
✅ **SQL Server 2022 Compatible** - Uses ODBC Driver 18  
✅ **Production Ready** - Connection pooling, error handling, graceful shutdown  
✅ **Well Documented** - Comprehensive guides and examples  
✅ **Easy Troubleshooting** - Diagnostic test script with specific solutions  
✅ **Best Practices** - Security, performance, and deployment guidance  

### Next Steps

1. ✅ Read [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)
2. ✅ Install prerequisites (ODBC Driver 18, msnodesqlv8)
3. ✅ Configure `.env` file
4. ✅ Run `node test-connection.js`
5. ✅ Update your application to use `database-windows-auth.js`
6. ✅ Test your application
7. ✅ Deploy with confidence!

---

## 🎉 Success Criteria

You'll know everything is working when:

- ✅ `node test-connection.js` shows "ALL TESTS PASSED"
- ✅ Your application connects without errors
- ✅ You see "Connected as: DOMAIN\YourUsername" in logs
- ✅ No credentials in your code or config files
- ✅ SQL Server audit shows your actual Windows username

---

**Ready to get started?** 👉 Open [`QUICKSTART_SQL2022.md`](./QUICKSTART_SQL2022.md)

**Need help?** 👉 Run `node test-connection.js` for diagnostics

**Want to understand more?** 👉 Read [`SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md`](./SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md)

---

**Last Updated:** 2024-01-15  
**SQL Server Version:** 2022 (also works with 2019, 2017)  
**Node.js Versions:** 14.x - 20.x  
**Platform:** Windows 10/11, Windows Server 2019/2022
