# .env File Setup Help

## Quick Setup

Your `.env` file should look like this:

```env
# Database Configuration
DB_SERVER=localhost\SQLEXPRESS
DB_DATABASE=YourDatabaseName
DB_PORT=1433

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

## Finding Your Database Details

### 1. Find Your SQL Server Name

**Option A: Using SQL Server Management Studio (SSMS)**
1. Open SSMS
2. Look at the "Connect to Server" dialog
3. The "Server name" field shows your server name

**Common Server Names:**
- `localhost` - Default instance on local machine
- `localhost\SQLEXPRESS` - SQL Server Express on local machine
- `.\SQLEXPRESS` - Alternative format for SQL Express
- `YOUR-COMPUTER-NAME\SQLEXPRESS` - SQL Express with computer name
- `YOUR-COMPUTER-NAME` - Default instance with computer name

**Option B: Using Command Line**
```cmd
sqlcmd -L
```
This lists all SQL Server instances on your network.

**Option C: Using PowerShell**
```powershell
Get-Service | Where-Object {$_.Name -like "*SQL*"}
```

### 2. Find Your Database Name

**In SSMS:**
1. Connect to your SQL Server
2. Expand "Databases" in Object Explorer
3. Find the database that contains the `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` stored procedure
4. That's your database name

**Using SQL Query:**
```sql
-- Find databases with the stored procedure
SELECT 
    DB_NAME(database_id) AS DatabaseName
FROM sys.dm_exec_procedure_stats
WHERE object_name(object_id, database_id) = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS';
```

## Example Configurations

### Example 1: SQL Server Express (Most Common)
```env
DB_SERVER=localhost\SQLEXPRESS
DB_DATABASE=BookingSystem
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

### Example 2: Default SQL Server Instance
```env
DB_SERVER=localhost
DB_DATABASE=BookingSystem
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

### Example 3: Remote SQL Server
```env
DB_SERVER=192.168.1.100\SQLEXPRESS
DB_DATABASE=BookingSystem
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

### Example 4: Named Instance with Domain
```env
DB_SERVER=MYSERVER\INSTANCE01
DB_DATABASE=BookingSystem
DB_PORT=1433
DB_DOMAIN=MYDOMAIN
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

## Configuration Options Explained

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `DB_SERVER` | ✅ Yes | SQL Server name or IP | `localhost\SQLEXPRESS` |
| `DB_DATABASE` | ✅ Yes | Database name | `BookingSystem` |
| `DB_PORT` | ✅ Yes | SQL Server port (usually 1433) | `1433` |
| `DB_DOMAIN` | ❌ No | Windows domain (only if needed) | `MYDOMAIN` |
| `DB_INSTANCE_NAME` | ❌ No | SQL Server instance name | `SQLEXPRESS` |
| `DB_ENCRYPT` | ✅ Yes | Encrypt connection | `true` |
| `DB_TRUST_SERVER_CERTIFICATE` | ✅ Yes | Trust self-signed certificates | `true` |
| `PORT` | ✅ Yes | Backend server port | `5000` |
| `NODE_ENV` | ✅ Yes | Environment | `development` |
| `MAX_FILE_SIZE` | ✅ Yes | Max upload size in bytes | `10485760` (10MB) |
| `ALLOWED_FILE_TYPES` | ✅ Yes | Allowed file extensions | `.xlsx,.xls` |

## Testing Your Configuration

### Step 1: Test SQL Server Connection
```cmd
sqlcmd -S localhost\SQLEXPRESS -E
```
- `-S` specifies the server
- `-E` uses Windows Authentication

If this works, you can connect to SQL Server.

### Step 2: Test Database Access
```cmd
sqlcmd -S localhost\SQLEXPRESS -d YourDatabaseName -E -Q "SELECT DB_NAME()"
```
Replace `YourDatabaseName` with your actual database name.

### Step 3: Check Stored Procedure
```sql
-- Run this in SSMS or sqlcmd
USE YourDatabaseName;
GO

SELECT * 
FROM sys.procedures 
WHERE name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS';
GO
```

If this returns a row, the stored procedure exists.

## Common Issues

### Issue: "Cannot read properties of undefined (reading 'length')"

**Cause:** Empty domain field causing NTLM authentication to fail.

**Solution:** 
1. Pull the latest code: `git pull origin main`
2. Make sure `DB_DOMAIN` is either not in your `.env` file, or has a valid domain name

### Issue: "Login failed for user"

**Cause:** Your Windows user doesn't have access to the database.

**Solution:** Run this in SSMS (as admin):
```sql
USE [YourDatabaseName];
GO

-- Replace DOMAIN\USERNAME with your Windows username
-- To find your username, run: whoami in Command Prompt
CREATE USER [DOMAIN\USERNAME] FOR LOGIN [DOMAIN\USERNAME];
GO

ALTER ROLE db_owner ADD MEMBER [DOMAIN\USERNAME];
GO
```

### Issue: "Server not found"

**Cause:** Wrong server name or SQL Server not running.

**Solutions:**
1. Check SQL Server is running:
   - Open Services (services.msc)
   - Look for "SQL Server (MSSQLSERVER)" or "SQL Server (SQLEXPRESS)"
   - Make sure it's "Running"

2. Verify server name:
   ```cmd
   sqlcmd -L
   ```

3. Try different formats:
   - `localhost\SQLEXPRESS`
   - `.\SQLEXPRESS`
   - `(local)\SQLEXPRESS`
   - Your computer name: `COMPUTERNAME\SQLEXPRESS`

### Issue: "Certificate validation failed"

**Solution:** Set this in your `.env`:
```env
DB_TRUST_SERVER_CERTIFICATE=true
```

## Getting Your Windows Username

To find your Windows username (needed for database permissions):

**Command Prompt:**
```cmd
whoami
```

**PowerShell:**
```powershell
$env:USERNAME
```

This will show something like:
- `DOMAIN\username` (if on a domain)
- `COMPUTERNAME\username` (if local account)

## Minimal Working .env File

If you're having trouble, start with this minimal configuration:

```env
DB_SERVER=localhost\SQLEXPRESS
DB_DATABASE=YourDatabaseName
DB_PORT=1433
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
PORT=5000
NODE_ENV=development
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

Note: `DB_ENCRYPT=false` is less secure but can help diagnose connection issues.

## Next Steps After Configuration

1. **Pull latest code:**
   ```bash
   git pull origin main
   ```

2. **Restart the server:**
   ```bash
   npm run server
   ```

3. **Look for success message:**
   ```
   ✅ Database connected successfully using Windows Integrated Security
      Server: localhost\SQLEXPRESS
      Database: YourDatabaseName
      Authentication: Windows Integrated Security (NTLM)
   ```

4. **If successful, start the frontend:**
   ```bash
   npm run dev
   ```

## Still Having Issues?

1. Check the error message carefully
2. Verify SQL Server is running
3. Test connection with `sqlcmd`
4. Check Windows user has database access
5. Review the server console output
6. Check the `.env` file has no typos or extra spaces

---

**Need more help?** Check the error message and compare it with the common issues above.
