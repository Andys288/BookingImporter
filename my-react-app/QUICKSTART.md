# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### 1. Configure Database
Edit the `.env` file with your database credentials:
```env
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
```

### 2. Generate Sample Template
```bash
node scripts/createTemplate.js
```

### 3. Start Backend Server
Open a terminal and run:
```bash
npm run server
```

You should see:
```
🚀 Server running on port 5000
📊 API available at http://localhost:5000/api
💚 Health check: http://localhost:5000/api/health
```

### 4. Start Frontend (Already Running)
The frontend is already running on port 3000!
Open your browser to: http://localhost:3000

### 5. Test the Application

#### Test Database Connection
1. Click "🔄 Test Connection" button
2. If it fails, verify your `.env` database settings

#### Upload Sample File
1. Click "📥 Download Sample Template" to get the template
2. Open the template in Excel and review the data
3. Drag and drop the file into the upload area
4. Click "👁️ Preview" to see the data
5. Click "🚀 Upload & Process" to import

## 📋 Expected Excel Format

Your Excel file should have these columns:

| Column | Required | Example |
|--------|----------|---------|
| ResourceName | Yes | John Doe |
| ProjectCode | Yes | PRJ-001 |
| StartDate | Yes | 01/15/2024 |
| EndDate | Yes | 01/19/2024 |
| Hours | Yes | 40 |
| BookingType | No | Development |
| Description | No | Backend work |
| Status | No | Active |

## 🔧 Troubleshooting

### Backend won't start
- Check if port 5000 is already in use
- Verify all npm packages are installed: `npm install`

### Database connection fails
- Verify SQL Server is running
- Check firewall allows connection on port 1433
- Test credentials with SQL Server Management Studio
- Ensure stored procedure `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` exists

### Excel upload fails
- Ensure file is .xlsx or .xls format
- Check all required columns are present
- Verify column names match exactly (case-insensitive)

## 📚 Next Steps

1. Read the full documentation: `README_POC.md`
2. Customize validation rules in `server/utils/validator.js`
3. Adjust stored procedure parameters in `server/services/bookingService.js`
4. Add your own Excel columns as needed

## 🎯 Key Features to Try

- ✅ Drag and drop Excel files
- ✅ Preview data before importing
- ✅ See detailed validation errors
- ✅ View import results with statistics
- ✅ Download sample template
- ✅ Test database connection

## 💡 Tips

- Always test database connection first
- Use the preview feature to verify data
- Review validation errors carefully
- Keep Excel files under 10MB
- Use the sample template as a starting point

---

**Need Help?** Check `README_POC.md` for detailed documentation.
