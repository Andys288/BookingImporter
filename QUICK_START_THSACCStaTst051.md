# 🚀 Quick Start Guide for THSACCStaTst051

## ✅ Your Configuration is Already Set!

Your `.env` file is already configured with the correct server:

```env
USE_WINDOWS_AUTH=true
DB_SERVER=THSACCStaTst051
DB_DATABASE=Accounts
DB_PORT=1433
ODBC_DRIVER=ODBC Driver 18 for SQL Server
```

---

## 🎯 Quick Test (2 minutes)

### Step 1: Test the Connection

Run this command in PowerShell:

```powershell
node test-connection-THSACCStaTst051.js
```

**Expected Output:**
```
✅ CONNECTION TEST SUCCESSFUL!
🎉 Your connection to THSACCStaTst051 is working perfectly!
```

---

### Step 2: If Connection Fails

#### Option A: Check if msnodesqlv8 is installed

```powershell
npm list msnodesqlv8
```

If not installed:
```powershell
npm install msnodesqlv8
```

#### Option B: Test with sqlcmd

```powershell
sqlcmd -S THSACCStaTst051 -E -Q "SELECT @@VERSION"
```

If this works, your SQL Server connection is fine, and it's just a Node.js driver issue.

---

## 🚀 Start Your Application

Once the connection test passes:

### Terminal 1 - Backend Server
```powershell
npm run server
```

**Expected Output:**
```
🔌 Attempting database connection...
   Server: THSACCStaTst051,1433
   Database: Accounts
   Authentication: Windows Integrated Security
✅ Database connected successfully!
🚀 Server running on port 5000
```

### Terminal 2 - Frontend
```powershell
npm run dev
```

**Expected Output:**
```
VITE v5.x.x  ready in xxx ms
➜  Local:   http://localhost:5173/
```

### Open Browser
Navigate to: **http://localhost:5173**

---

## 🔧 Troubleshooting

### Error: "Cannot find module 'msnodesqlv8'"

**Solution:**
```powershell
npm install msnodesqlv8
```

---

### Error: "Login failed for user 'DOMAIN\YourUsername'"

**Solution:** Your Windows user needs database access.

Ask your DBA to run this SQL on **THSACCStaTst051**:

```sql
USE [Accounts];
GO

-- Replace DOMAIN\YourUsername with your actual Windows account
CREATE USER [DOMAIN\YourUsername] FOR LOGIN [DOMAIN\YourUsername];
GO

-- Grant read/write permissions
ALTER ROLE db_datareader ADD MEMBER [DOMAIN\YourUsername];
ALTER ROLE db_datawriter ADD MEMBER [DOMAIN\YourUsername];
GO
```

To find your Windows username:
```powershell
echo $env:USERDOMAIN\$env:USERNAME
```

---

### Error: "Cannot open database 'Accounts'"

**Possible causes:**
1. Database name is wrong (check with DBA)
2. Your user doesn't have access to this database
3. Database doesn't exist on this server

**Check available databases:**
```powershell
sqlcmd -S THSACCStaTst051 -E -Q "SELECT name FROM sys.databases"
```

---

### Error: "A network-related or instance-specific error"

**Possible causes:**
1. Server name is wrong
2. SQL Server is not running
3. Firewall is blocking port 1433
4. Network connectivity issue

**Test connectivity:**
```powershell
# Test if server is reachable
ping THSACCStaTst051

# Test if SQL Server port is open
Test-NetConnection -ComputerName THSACCStaTst051 -Port 1433

# Test SQL Server directly
sqlcmd -S THSACCStaTst051 -E -Q "SELECT @@VERSION"
```

---

## 📋 Connection Details Summary

| Setting | Value |
|---------|-------|
| **Server** | THSACCStaTst051 |
| **Port** | 1433 |
| **Database** | Accounts |
| **Authentication** | Windows Authentication |
| **Driver** | msnodesqlv8 (ODBC Driver 18) |
| **Your Windows User** | Automatic (current logged-in user) |

---

## 🎯 Next Steps After Connection Works

1. ✅ Test connection: `node test-connection-THSACCStaTst051.js`
2. ✅ Start backend: `npm run server`
3. ✅ Start frontend: `npm run dev`
4. ✅ Open browser: http://localhost:5173
5. ✅ Test file upload with your Excel files

---

## 📚 Additional Documentation

- **START_HERE_FINAL.md** - Complete quick start guide
- **FINAL_DIAGNOSIS_AND_SOLUTION.md** - Detailed diagnosis and solutions
- **FIX_NOW_STEP_BY_STEP.md** - Step-by-step troubleshooting
- **SOLUTION_ALTERNATIVE_DRIVERS.md** - Alternative driver options

---

## 🆘 Still Having Issues?

1. **Check the test output** - It provides specific error messages
2. **Review the troubleshooting section** above
3. **Check your Windows user has SQL Server access**
4. **Verify SQL Server is running** on THSACCStaTst051
5. **Test with sqlcmd** to isolate Node.js vs SQL Server issues

---

## ✅ Success Checklist

- [ ] msnodesqlv8 is installed (`npm list msnodesqlv8`)
- [ ] SQL Server Native Client is installed
- [ ] Connection test passes (`node test-connection-THSACCStaTst051.js`)
- [ ] Backend server starts successfully (`npm run server`)
- [ ] Frontend starts successfully (`npm run dev`)
- [ ] Can access http://localhost:5173
- [ ] Can upload Excel files

---

**Your server name is already configured correctly! Just run the test to verify the connection works.** 🎉
