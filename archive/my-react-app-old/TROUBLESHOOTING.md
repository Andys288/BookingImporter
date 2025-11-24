# 🔧 Troubleshooting Guide

## Frontend Preview is Blank

### ✅ **RESOLVED** - Dependencies Installed

The issue was that the required npm packages (`axios` and `react-dropzone`) were not installed initially.

**Solution Applied:**
```bash
cd my-react-app
npm install
```

Then the frontend dev server was restarted to pick up the new dependencies.

---

## Current Status

### ✅ Backend Server
- **Status**: Running
- **Port**: 5000
- **URL**: http://localhost:5000/api
- **Health Check**: http://localhost:5000/api/health

### ✅ Frontend Server
- **Status**: Running
- **Port**: 3000
- **URL**: http://localhost:3000
- **Vite Version**: 7.2.4

---

## Common Issues & Solutions

### 1. **Blank Screen / White Page**

**Possible Causes:**
- Missing dependencies
- JavaScript errors in console
- Wrong port configuration

**Solutions:**
```bash
# Reinstall dependencies
cd my-react-app
npm install

# Restart frontend
npm run dev

# Check for errors in browser console (F12)
```

---

### 2. **Backend Connection Failed**

**Symptoms:**
- "Failed to connect to server" message
- API calls returning 404 or connection refused

**Solutions:**

1. **Check if backend is running:**
   ```bash
   # Should see "Server running on port 5000"
   npm run server
   ```

2. **Test backend health:**
   ```bash
   curl http://localhost:5000/api/health
   ```

3. **Check .env configuration:**
   ```env
   DB_SERVER=your-sql-server
   DB_DATABASE=your-database
   DB_USER=your-username
   DB_PASSWORD=your-password
   DB_PORT=1433
   DB_ENCRYPT=true
   DB_TRUST_CERT=false
   ```

---

### 3. **Database Connection Errors**

**Symptoms:**
- "Database connection failed" in Connection Test
- SQL errors during import

**Solutions:**

1. **Verify database credentials in `.env`**

2. **Test SQL Server connectivity:**
   ```bash
   # From SQL Server Management Studio or Azure Data Studio
   # Try connecting with the same credentials
   ```

3. **Check firewall rules:**
   - Ensure SQL Server port (1433) is accessible
   - Check if SQL Server allows remote connections

4. **Verify stored procedure exists:**
   ```sql
   SELECT * FROM sys.procedures 
   WHERE name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'
   ```

---

### 4. **File Upload Fails**

**Symptoms:**
- "Failed to upload file" error
- Validation errors

**Solutions:**

1. **Check Excel file format:**
   - Must be .xlsx or .xls
   - Download the sample template and compare structure

2. **Verify required columns exist:**
   - ProjectID (Integer)
   - ResourceID (Integer)
   - StartDate (Date format: YYYY-MM-DD)
   - EndDate (Date format: YYYY-MM-DD)
   - AllocationPercentage (0-100)

3. **Check for data validation issues:**
   - No empty required fields
   - Dates in correct format
   - Numbers are valid
   - EndDate >= StartDate

---

### 5. **CORS Errors**

**Symptoms:**
- Browser console shows CORS policy errors
- API calls blocked

**Solutions:**

The backend already has CORS enabled for `http://localhost:3000`. If you change ports:

1. **Update server/server.js:**
   ```javascript
   app.use(cors({
     origin: 'http://localhost:YOUR_NEW_PORT'
   }));
   ```

2. **Restart backend server**

---

### 6. **Port Already in Use**

**Symptoms:**
- "Port 3000 is already in use"
- "Port 5000 is already in use"

**Solutions:**

1. **Find and kill the process:**
   ```bash
   # Linux/Mac
   lsof -ti:3000 | xargs kill -9
   lsof -ti:5000 | xargs kill -9
   
   # Windows
   netstat -ano | findstr :3000
   taskkill /PID <PID> /F
   ```

2. **Or change the port:**
   - Frontend: Edit `vite.config.js`
   - Backend: Edit `server/server.js`

---

## Verification Checklist

Before reporting issues, verify:

- [ ] Both servers are running (frontend on 3000, backend on 5000)
- [ ] Dependencies are installed (`node_modules` folder exists)
- [ ] `.env` file exists with correct database credentials
- [ ] Browser console shows no JavaScript errors (F12)
- [ ] Network tab shows API calls are reaching the backend
- [ ] Database is accessible and stored procedure exists
- [ ] Excel file follows the template structure

---

## Getting Help

### Check Logs

**Frontend logs:**
```bash
# In the terminal running npm run dev
# Look for compilation errors or warnings
```

**Backend logs:**
```bash
# In the terminal running npm run server
# Look for database connection errors or API errors
```

**Browser console:**
```
F12 → Console tab
Look for red error messages
```

### Test Individual Components

1. **Test Backend Health:**
   ```bash
   curl http://localhost:5000/api/health
   # Should return: {"status":"ok","message":"Server is running"}
   ```

2. **Test Database Connection:**
   - Click "Test Connection" button in the UI
   - Should show green success message

3. **Test File Upload:**
   - Download sample template
   - Upload without modifications
   - Should process successfully

---

## Quick Reset

If everything seems broken, try a complete reset:

```bash
# Stop all servers (Ctrl+C in both terminals)

# Clean install
cd my-react-app
rm -rf node_modules package-lock.json
npm install

# Start backend
npm run server

# In another terminal, start frontend
npm run dev

# Open browser to http://localhost:3000
```

---

## Environment Setup

### Required Software
- Node.js 18+ (check: `node --version`)
- npm 9+ (check: `npm --version`)
- SQL Server (accessible from your machine)

### Required Files
- `.env` (database configuration)
- `Resource_Booking_Template.xlsx` (in public folder)
- All files in `server/` directory
- All files in `src/` directory

---

## Contact & Support

For POC-specific issues:
1. Check this troubleshooting guide
2. Review the README.md for setup instructions
3. Check the USER_GUIDE.md for usage instructions
4. Verify all prerequisites are met

---

**Last Updated**: 2025-11-21
**Version**: 1.0
