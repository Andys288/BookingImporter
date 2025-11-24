# Windows SQL Driver Setup - msnodesqlv8

## Why We Switched Drivers

The `tedious` driver (default for `mssql` package) has poor support for Windows Integrated Security. It requires explicit credentials even when trying to use Windows Authentication.

The `msnodesqlv8` driver is specifically designed for Windows and properly supports Windows Integrated Security - just like `sqlcmd -E` does.

## Setup on Your Windows Machine

### Step 1: Pull the Latest Code
```bash
git pull origin main
```

### Step 2: Install the Windows Driver
```bash
npm install
```

This will install `msnodesqlv8` which includes native Windows components for proper SQL Server integration.

**Note:** This package requires:
- Windows OS
- Visual C++ Redistributable (usually already installed)
- Node.js native build tools (npm handles this automatically)

### Step 3: Your `.env` File Should Be Simple

```env
DB_SERVER=THSACCSTATSt051
DB_DATABASE=Accounts
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

**No DB_USER, DB_PASSWORD, or DB_DOMAIN needed!**

### Step 4: Start the Server
```bash
npm run server
```

### Expected Output:
```
🔌 Attempting database connection...
   Driver: msnodesqlv8 (Windows Native)
   Server: THSACCSTATSt051
   Database: Accounts
   Authentication: Windows Integrated Security
   User: (current Windows user - automatic)
✅ Database connected successfully!
   Connected as current Windows user
```

## How It Works

1. **msnodesqlv8** uses native Windows ODBC drivers
2. It automatically uses the Windows credentials of whoever runs the application
3. No passwords stored anywhere
4. Each user connects as themselves
5. Works exactly like `sqlcmd -E`

## Benefits

✅ **True Windows Authentication** - No workarounds needed
✅ **No Credentials in Code** - Completely secure
✅ **Per-User Access** - Each user connects as themselves
✅ **Native Performance** - Uses Windows ODBC drivers directly
✅ **Simple Configuration** - Just server and database name

## Troubleshooting

### If npm install fails:

**Error: "node-gyp rebuild failed"**

Install Windows Build Tools:
```bash
npm install --global windows-build-tools
```

Then try again:
```bash
npm install
```

### If connection fails:

1. **Check your Windows user has database access:**
   ```sql
   -- Run in SSMS
   USE [Accounts];
   GO
   
   -- Check current user
   SELECT SUSER_NAME();
   GO
   
   -- Grant access (replace with your username from whoami)
   CREATE USER [THSACC\YourUsername] FOR LOGIN [THSACC\YourUsername];
   GO
   
   ALTER ROLE db_owner ADD MEMBER [THSACC\YourUsername];
   GO
   ```

2. **Verify SQL Server allows Windows Authentication:**
   - Open SQL Server Configuration Manager
   - Check that Windows Authentication is enabled
   - Restart SQL Server service if you made changes

3. **Test with sqlcmd:**
   ```cmd
   sqlcmd -S THSACCSTATSt051 -E -d Accounts -Q "SELECT SUSER_NAME()"
   ```
   
   If this works, the Node.js app should work too.

## Comparison: tedious vs msnodesqlv8

| Feature | tedious (old) | msnodesqlv8 (new) |
|---------|---------------|-------------------|
| Windows Auth | ❌ Poor support | ✅ Full support |
| Credentials needed | ⚠️ Yes (workarounds) | ✅ No |
| Native Windows | ❌ No | ✅ Yes |
| ODBC drivers | ❌ No | ✅ Yes |
| Pass-through auth | ❌ No | ✅ Yes |
| Configuration | 😫 Complex | 😊 Simple |

## Security Note

With `msnodesqlv8`:
- ✅ No passwords in `.env` files
- ✅ No passwords in code
- ✅ No passwords in memory
- ✅ Windows handles all authentication
- ✅ Audit trail shows actual user (not a service account)
- ✅ Each user has their own permissions

This is the **proper** way to do Windows Integrated Security!

## For Production Deployment

When deploying to a server:
1. The Windows service account running Node.js needs database access
2. Grant the service account permissions in SQL Server
3. No configuration changes needed - it just works!

---

**This should have been the solution from the start!** 🎉
