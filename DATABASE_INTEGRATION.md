# Database Integration Documentation

## Overview
This document describes how the Resource Booking Import Tool integrates with the SQL Server database and the `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` stored procedure.

## Stored Procedure Location
The complete SQL script for the stored procedure is located in:
```
database/TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql
```

## Stored Procedure Details

### Name
`TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`

### Database
`ACCOUNTS`

### Purpose
Insert, update, or delete booking records in the TS_BOOKINGS table with comprehensive validation and transaction support.

### Version
v3.2 (Andy Smith, 21/11/2025)
- Fixed issue with hourly bookings setting bkg_qty =0.5

## Key Parameters Used by POC

The POC application maps Excel columns to the following stored procedure parameters:

| Excel Column | SP Parameter | Type | Description |
|--------------|--------------|------|-------------|
| BookingID | @BKG_PRIMARY | FLOAT | Primary key (0 for new bookings) |
| - | @BKG_TYPE | VARCHAR(20) | Booking type (configured in app) |
| - | @BKG_USER | VARCHAR(4) | User ID (from configuration) |
| - | @BKG_STATUS | TINYINT | Status (0=Pending by default) |
| ProjectID | @BKG_PROJECT | VARCHAR(10) | Project code |
| ResourceID | @BKG_RESOURCE | VARCHAR(16) | Resource code |
| StartDate | @BKG_START | DATETIME | Start date |
| EndDate | @BKG_END | DATETIME | End date |
| Role | @BKG_ROLE | VARCHAR(20) | Role/position |
| Notes | @BKG_NOTES | VARCHAR(1000) | Notes/comments |
| Action | @ACTION | TINYINT | 0=Insert, 1=Update, 2=Delete |
| - | @Type | TINYINT | 1 (Validate and Post) |
| - | @BKG_ALL_DAY | TINYINT | 1 (All day booking) |

## Validation Performed by Stored Procedure

The stored procedure performs extensive validation:

### 1. Required Field Validation
- @BKG_TYPE must exist in TS_BOOKING_TYPES
- @BKG_USER must exist in TS_USERS
- @BKG_START and @BKG_END are required
- Compulsory fields based on booking type configuration

### 2. Data Integrity Validation
- Customer code exists in SL_ACCOUNTS (if provided)
- Project code exists in CST_COSTHEADER (if provided)
- Cost centre exists in CST_COSTCENTRE (if provided)
- Resource exists in PRC_PRICE_RECS (if provided)
- Role exists in TS_ROLES (if provided)
- Product exists in TS_BOOKING_PRODUCTS (if provided)
- Currency exists in SYS_CURRENCY (if provided)
- SOW code exists in TS_PROJECT_SOW_HEADER (if provided)

### 3. Business Rule Validation
- End date must be >= Start date
- Hourly bookings cannot span multiple days
- Status must be 0-7 (Pending to Invoiced)
- Allocation percentage must be 0-100
- Custom field validation based on TS_LOOKUP

### 4. Transaction Management
- Uses BEGIN TRANSACTION / COMMIT / ROLLBACK
- Maintains data integrity
- Creates audit trail in TS_BOOKING_HISTORY

## Database Tables Affected

### Primary Tables
- **TS_BOOKINGS** - Main booking records
- **TS_BOOKING_RESOURCES** - Resource allocations
- **TS_BOOKING_HISTORY** - Audit trail of changes

### Lookup/Reference Tables
- TS_BOOKING_TYPES
- TS_BOOKING_TYPES_SETUP_DETAIL
- TS_ROLES
- TS_USERS
- PRC_PRICE_RECS
- CST_COSTHEADER
- CST_COSTCENTRE
- SL_ACCOUNTS
- TS_PROJECT_SOW_HEADER
- TS_LOOKUP
- SYS_CURRENCY

## Error Handling

### Stored Procedure Errors
The stored procedure returns errors via RAISERROR with:
- Error number: 16 (severity)
- State: 1
- Error message describing the issue

### POC Error Handling
The POC application catches these errors and:
1. Logs the error message
2. Associates it with the specific row number
3. Displays it to the user in the results panel
4. Continues processing remaining rows (if configured)

## Example Stored Procedure Call

```javascript
// From bookingService.js
const request = pool.request();

request.input('Type', sql.TinyInt, 1); // Validate and Post
request.input('ACTION', sql.TinyInt, action); // 0=Insert, 1=Update, 2=Delete
request.input('BKG_PRIMARY', sql.Float, bookingId || 0);
request.input('BKG_TYPE', sql.VarChar(20), 'RESOURCE'); // Configurable
request.input('BKG_USER', sql.VarChar(4), userId); // From config
request.input('BKG_STATUS', sql.TinyInt, 0); // Pending
request.input('BKG_PROJECT', sql.VarChar(10), data.ProjectID);
request.input('BKG_RESOURCE', sql.VarChar(16), data.ResourceID);
request.input('BKG_START', sql.DateTime, data.StartDate);
request.input('BKG_END', sql.DateTime, data.EndDate);
request.input('BKG_ROLE', sql.VarChar(20), data.Role);
request.input('BKG_NOTES', sql.VarChar(1000), data.Notes);
request.input('BKG_ALL_DAY', sql.TinyInt, 1);

const result = await request.execute('TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS');
```

## Configuration Requirements

### Database Connection
Configure in `.env` file:
```env
DB_SERVER=your-sql-server
DB_DATABASE=ACCOUNTS
DB_USER=your-username
DB_PASSWORD=your-password
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_CERT=false
```

### Application Configuration
Configure in `server/config/database.js`:
```javascript
const config = {
  server: process.env.DB_SERVER,
  database: process.env.DB_DATABASE,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: parseInt(process.env.DB_PORT || '1433'),
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_CERT === 'true',
    enableArithAbort: true
  }
};
```

## Installation Steps

### 1. Install Stored Procedure
```sql
-- Connect to SQL Server Management Studio
-- Select ACCOUNTS database
USE [ACCOUNTS]
GO

-- Run the script
-- database/TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql
```

### 2. Verify Installation
```sql
-- Check if stored procedure exists
SELECT * 
FROM sys.procedures 
WHERE name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'

-- Check version
EXEC sp_helptext 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'
```

### 3. Grant Permissions
```sql
-- Grant execute permission to application user
GRANT EXECUTE ON TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS TO [your-app-user]
```

### 4. Test Connection
Use the POC application's "Test Connection" button to verify:
- Database connectivity
- Stored procedure existence
- User permissions

## Extensibility

### Adding New Fields

To add new fields to the import:

1. **Update Excel Template** (`scripts/generateTemplate.cjs`):
   ```javascript
   const headers = [
     'BookingID', 'ProjectID', 'ResourceID', 
     'StartDate', 'EndDate', 'AllocationPercentage',
     'Role', 'Notes', 'Action',
     'NewField' // Add here
   ];
   ```

2. **Update Parser** (`server/services/bookingService.js`):
   ```javascript
   const booking = {
     BookingID: row.BookingID,
     ProjectID: row.ProjectID,
     // ... existing fields
     NewField: row.NewField // Add here
   };
   ```

3. **Update Stored Procedure Call**:
   ```javascript
   request.input('BKG_NEW_FIELD', sql.VarChar(50), data.NewField);
   ```

4. **Update Stored Procedure** (if needed):
   - Add parameter to stored procedure
   - Add validation logic
   - Update INSERT/UPDATE statements

## Troubleshooting

### Common Issues

**Issue**: "Stored procedure not found"
- **Solution**: Verify stored procedure is installed in ACCOUNTS database
- **Check**: `SELECT * FROM sys.procedures WHERE name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'`

**Issue**: "Permission denied"
- **Solution**: Grant EXECUTE permission to application user
- **Check**: User has appropriate database role

**Issue**: "Invalid column name"
- **Solution**: Verify stored procedure version matches POC expectations
- **Check**: Review stored procedure parameters

**Issue**: "Transaction deadlock"
- **Solution**: Reduce batch size or implement retry logic
- **Check**: Database transaction isolation level

## Performance Considerations

### Batch Processing
- Process records in batches of 100-500 for optimal performance
- Use transactions to maintain data integrity
- Implement retry logic for transient errors

### Indexing
Ensure appropriate indexes exist on:
- TS_BOOKINGS.BKG_PRIMARY
- TS_BOOKINGS.BKG_PROJECT
- TS_BOOKINGS.BKG_RESOURCE
- TS_BOOKING_RESOURCES.BKRE_BKG_PRIMARY

### Connection Pooling
The POC uses connection pooling:
```javascript
const pool = new sql.ConnectionPool(config);
await pool.connect();
```

## Monitoring

### Logging
The POC logs:
- Database connection status
- Stored procedure execution time
- Validation errors
- Transaction outcomes

### Audit Trail
The stored procedure maintains:
- TS_BOOKING_HISTORY records for all changes
- User who made the change
- Timestamp of change
- Before/after values

## Security

### SQL Injection Prevention
- All parameters are properly typed
- Uses parameterized queries
- No dynamic SQL in POC code

### Authentication
- Database credentials in environment variables
- Not committed to source control
- Encrypted connection (optional)

### Authorization
- Stored procedure enforces business rules
- User validation in TS_USERS table
- Role-based access control (future enhancement)

## Support

For database-related issues:
1. Check stored procedure version (v3.2 or later)
2. Verify database connectivity
3. Review SQL Server error logs
4. Check application logs in `server/logs/`
5. Consult database administrator

## References

- **Stored Procedure**: `database/TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql`
- **Database Config**: `server/config/database.js`
- **Service Layer**: `server/services/bookingService.js`
- **API Routes**: `server/routes/bookingRoutes.js`
- **Database README**: `database/README.md`

---

**Last Updated**: 21/11/2025  
**Stored Procedure Version**: v3.2  
**POC Version**: 1.0.0
