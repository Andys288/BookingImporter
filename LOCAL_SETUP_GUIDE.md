# Local Development Setup Guide

## Prerequisites

1. **Node.js** (v16 or higher) - [Download here](https://nodejs.org/)
2. **SQL Server** with Windows Authentication enabled
3. **Git** - Already installed since you cloned the repo

## Step-by-Step Setup

### 1. Clone and Install Dependencies

```bash
# You've already done this, but for reference:
git clone https://github.com/Andys288/BookingImporter.git
cd BookingImporter
npm install
```

### 2. Configure Database Connection

Create a `.env` file in the root directory (copy from `.env.example`):

```bash
# On Windows Command Prompt:
copy .env.example .env

# On Windows PowerShell:
Copy-Item .env.example .env

# On Mac/Linux:
cp .env.example .env
```

Edit the `.env` file with your database details:

```env
# ============================================
# Database Configuration
# ============================================
DB_SERVER=YOUR_SQL_SERVER_NAME
DB_DATABASE=YOUR_DATABASE_NAME
DB_PORT=1433

# Optional: If using SQL Server Express
# DB_INSTANCE_NAME=SQLEXPRESS

# Connection Options
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# ============================================
# Server Configuration
# ============================================
PORT=5000
NODE_ENV=development

# ============================================
# Upload Configuration
# ============================================
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

#### Finding Your SQL Server Name:

**Option 1: SQL Server Management Studio (SSMS)**
- Open SSMS
- The server name is shown in the "Connect to Server" dialog
- Common formats:
  - `localhost` or `127.0.0.1` (local default instance)
  - `localhost\SQLEXPRESS` (local SQL Express)
  - `YOUR-COMPUTER-NAME\SQLEXPRESS`
  - `YOUR-COMPUTER-NAME` (default instance)

**Option 2: Command Line**
```cmd
sqlcmd -L
```
This lists all SQL Server instances on your network.

**Option 3: Check SQL Server Configuration Manager**
- Search for "SQL Server Configuration Manager" in Windows
- Look under "SQL Server Services"

### 3. Verify Database Access

Make sure your Windows user has access to the database:

```sql
-- Run this in SQL Server Management Studio
-- Replace YOUR_WINDOWS_USERNAME with your actual username

USE [YOUR_DATABASE_NAME];
GOn

-- Check if you have access
SELECT SUSER_NAME() AS CurrentUser;
GO

-- If needed, grant access (run as admin)
CREATE USER [DOMAIN\YOUR_USERNAME] FOR LOGIN [DOMAIN\YOUR_USERNAME];
GO

ALTER ROLE db_owner ADD MEMBER [DOMAIN\YOUR_USERNAME];
GO
```

### 4. Verify Stored Procedure Exists

The application uses this stored procedure:

```sql
-- Check if it exists
SELECT * 
FROM sys.procedures 
WHERE name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS';
```

If it doesn't exist, you'll need to create it or update the stored procedure name in:
- `server/services/bookingService.js` (line ~95)

### 5. Start the Application

You need to run **TWO separate terminals**:

#### Terminal 1: Start the Backend Server

```bash
npm run server
```

You should see:
```
Server running on port 5000
Database connected successfully
```

If you see connection errors, check your `.env` file settings.

#### Terminal 2: Start the Frontend (Vite Dev Server)

```bash
npm run dev
```

You should see:
```
VITE v7.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

### 6. Access the Application

Open your browser and go to:
```
http://localhost:5173
```

The frontend (React) runs on port **5173**
The backend (Express) runs on port **5000**

## Common Issues and Solutions

### Issue 1: "Cannot connect to database"

**Solution:**
1. Check your SQL Server is running:
   - Open "Services" (services.msc)
   - Look for "SQL Server (MSSQLSERVER)" or "SQL Server (SQLEXPRESS)"
   - Make sure it's "Running"

2. Verify your `.env` settings:
   ```env
   DB_SERVER=localhost\SQLEXPRESS
   DB_DATABASE=YourDatabaseName
   DB_TRUST_SERVER_CERTIFICATE=true
   ```

3. Test connection with sqlcmd:
   ```cmd
   sqlcmd -S localhost\SQLEXPRESS -E
   ```
   (The `-E` flag uses Windows Authentication)

### Issue 2: "Login failed for user"

**Solution:**
- Your Windows user doesn't have database access
- Run the SQL commands in Step 3 above
- Or ask your DBA to grant you access

### Issue 3: "Stored procedure not found"

**Solution:**
- The stored procedure `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` doesn't exist
- Check the stored procedure name in your database
- Update `server/services/bookingService.js` if needed

### Issue 4: Backend starts but frontend can't connect

**Solution:**
- Make sure backend is running on port 5000
- Check `src/components/FileUpload.jsx` - API URL should be:
  ```javascript
  const API_URL = 'http://localhost:5000/api';
  ```

### Issue 5: "Port 5000 already in use"

**Solution:**
- Another application is using port 5000
- Change the port in `.env`:
  ```env
  PORT=5001
  ```
- Also update the API URL in `src/components/FileUpload.jsx`

### Issue 6: Excel upload fails with "Failed to parse Excel file"

**Solution:**
- Make sure you're using the correct template format
- Download a fresh template from the app
- Check that all required columns are present

## Development Workflow

### Normal Development:

1. **Start backend** (Terminal 1):
   ```bash
   npm run server
   ```

2. **Start frontend** (Terminal 2):
   ```bash
   npm run dev
   ```

3. Make your changes - both will auto-reload

### To Stop:

- Press `Ctrl+C` in each terminal

### To Restart:

- Just run the commands again

## Testing the Application

### 1. Test Database Connection

Visit: `http://localhost:5173` and check the browser console for any errors.

### 2. Download Template

Click "Download Minimum Template" or "Download Complete Template"

### 3. Upload Test File

- Fill in the template with test data
- Drag and drop or click to upload
- Check the results

## Project Structure

```
BookingImporter/
├── server/                 # Backend (Express)
│   ├── server.js          # Main server file
│   ├── config/
│   │   └── database.js    # Database connection
│   ├── controllers/
│   │   └── bookingController.js
│   ├── routes/
│   │   └── bookingRoutes.js
│   ├── services/
│   │   └── bookingService.js
│   └── utils/
│       ├── excelParser.js # Excel file parsing
│       └── validator.js   # Data validation
├── src/                   # Frontend (React)
│   ├── App.jsx
│   └── components/
│       └── FileUpload.jsx # Main upload component
├── public/                # Static files
│   ├── Booking_Template_Minimum.xlsx
│   └── Booking_Template_Complete.xlsx
├── .env                   # Your local config (create this)
├── .env.example          # Example config
└── package.json          # Dependencies and scripts
```

## Available NPM Scripts

```bash
npm run dev      # Start frontend dev server (Vite)
npm run server   # Start backend server (Express)
npm run build    # Build frontend for production
npm run preview  # Preview production build
npm run lint     # Run ESLint
```

## Database Schema Requirements

Your database should have:

1. **Stored Procedure**: `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`
2. **Required Parameters** (adjust based on your actual SP):
   - @ResourceName
   - @ProjectCode
   - @StartDate
   - @EndDate
   - @Hours
   - @BookingType
   - @Description
   - @Status
   - @Action

Check `server/services/bookingService.js` for the exact parameters used.

## Need Help?

1. Check the console output in both terminals
2. Check browser console (F12) for frontend errors
3. Review the error messages - they usually indicate the issue
4. Check the `SECURITY_FIX_SUMMARY.md` for recent changes
5. Review `STORED_PROCEDURE_ANALYSIS.md` for database details

## Quick Reference

| What | Command | Port |
|------|---------|------|
| Backend | `npm run server` | 5000 |
| Frontend | `npm run dev` | 5173 |
| Access App | Browser | http://localhost:5173 |
| API Endpoint | - | http://localhost:5000/api |

---

**Ready to start?**

1. Create your `.env` file
2. Open two terminals
3. Run `npm run server` in terminal 1
4. Run `npm run dev` in terminal 2
5. Open http://localhost:5173 in your browser

🎉 You're all set!
