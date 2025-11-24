# Quick Setup Guide

## ✅ Current Status

Both servers are **RUNNING**:
- ✅ **Backend API**: http://localhost:5000
- ✅ **Frontend UI**: http://localhost:3000

## 🎯 Next Steps

### 1. Configure Database Connection

Edit the `.env` file with your SQL Server credentials:

```bash
DB_SERVER=your-sql-server-address
DB_DATABASE=your-database-name
DB_USER=your-username
DB_PASSWORD=your-password
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true
```

**Important:** After updating `.env`, restart the backend server:
```bash
# Stop the current server (Ctrl+C in the terminal running npm run server)
# Then restart:
npm run server
```

### 2. Test the Application

1. **Open the frontend**: http://localhost:3000
2. **Download the sample template** using the button in the UI
3. **Fill in the Excel file** with test data
4. **Upload the file** and see the results

### 3. Verify Database Connection

Test the health endpoint:
```bash
curl http://localhost:5000/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## 📋 Sample Data for Testing

Use this data in your Excel file:

| BookingID | ProjectID | ResourceID | StartDate | EndDate | AllocationPercentage | Role | Notes | Action |
|-----------|-----------|------------|-----------|---------|---------------------|------|-------|--------|
| | 1001 | 5001 | 2024-01-15 | 2024-03-15 | 75 | Developer | New booking | INSERT |
| | 1001 | 5002 | 2024-02-01 | 2024-04-30 | 100 | Lead | Full time | INSERT |
| | 1002 | 5003 | 2024-03-01 | 2024-06-30 | 50 | Analyst | Part time | INSERT |

## 🔧 Troubleshooting

### Backend won't start
- Check if port 5000 is already in use
- Verify all dependencies are installed: `npm install`
- Check for syntax errors in server files

### Frontend won't start
- Check if port 3000 is already in use
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`

### Database connection fails
- Verify SQL Server is accessible
- Check firewall settings
- Ensure SQL Server authentication is enabled
- Test connection using SQL Server Management Studio first

### File upload fails
- Check file format (.xlsx or .xls)
- Verify file size (max 10MB)
- Ensure all required columns are present
- Check browser console for errors

## 📁 Important Files

- **`.env`** - Database configuration (UPDATE THIS FIRST!)
- **`server/server.js`** - Backend server entry point
- **`server/services/bookingService.js`** - Core business logic
- **`src/components/BookingImporter.jsx`** - Frontend UI component
- **`public/sample-booking-template.xlsx`** - Sample Excel template

## 🎨 Customization

### Add New Columns

1. **Update the template generator** (`scripts/generateTemplate.cjs`):
   ```javascript
   const headers = ['BookingID', 'ProjectID', 'ResourceID', 'YourNewColumn', ...];
   ```

2. **Update the parser** (`server/services/bookingService.js`):
   ```javascript
   const booking = {
     // ... existing fields
     yourNewColumn: row['YourNewColumn'] || null
   };
   ```

3. **Update validation** (if required):
   ```javascript
   if (!booking.yourNewColumn) {
     errors.push('YourNewColumn is required');
   }
   ```

4. **Update stored procedure call** with new parameter

5. **Regenerate template**:
   ```bash
   node scripts/generateTemplate.cjs
   ```

## 🚀 Production Deployment

Before deploying to production:

1. ✅ Add authentication/authorization
2. ✅ Enable HTTPS
3. ✅ Set up proper logging
4. ✅ Configure CORS properly
5. ✅ Add rate limiting
6. ✅ Set up monitoring
7. ✅ Create backup strategy
8. ✅ Add audit trail
9. ✅ Performance testing
10. ✅ Security audit

## 📞 Need Help?

Check the main README.md for detailed documentation on:
- API endpoints
- Excel file format
- Validation rules
- Error handling
- Architecture details

---

**Ready to use!** Open http://localhost:3000 and start importing! 🎉
