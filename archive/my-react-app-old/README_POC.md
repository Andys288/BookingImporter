# Resource Booking Import Tool - POC Documentation

## Overview
This Proof-of-Concept (POC) solution enables project managers to import resource booking data from Excel files into a scheduling system using the existing SQL stored procedure `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`.

## Features

### ✅ Core Functionality
- **Excel File Upload**: Drag-and-drop or click-to-select interface for Excel files (.xlsx, .xls)
- **File Preview**: Preview Excel data before processing
- **Data Validation**: Comprehensive validation of booking records
- **Batch Processing**: Process multiple records efficiently
- **Error Reporting**: Detailed error messages with row-level information
- **Database Integration**: Direct integration with SQL Server stored procedure
- **Connection Testing**: Test database connectivity before importing

### 📊 Validation Rules
The system validates the following:
- **Required Fields**: ResourceName, ProjectCode, StartDate, EndDate, Hours
- **Date Validation**: Proper date formats and logical date ranges
- **Numeric Validation**: Hours must be valid numbers (non-negative)
- **Duplicate Detection**: Identifies potential duplicate records
- **Data Type Validation**: Ensures correct data types for all fields

## Installation & Setup

### Prerequisites
- Node.js (v16 or higher)
- SQL Server database with `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` stored procedure
- Database credentials

### Step 1: Install Dependencies
```bash
cd my-react-app
npm install
```

### Step 2: Configure Database Connection
Create a `.env` file in the root directory:

```env
# Database Configuration
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=false

# Server Configuration
PORT=5000
NODE_ENV=development

# Upload Configuration
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

### Step 3: Start the Application

**Terminal 1 - Backend Server:**
```bash
npm run server
```

**Terminal 2 - Frontend Development Server:**
```bash
npm run dev
```

The application will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000/api

## Excel File Structure

### Required Columns
The Excel file must contain the following columns (case-insensitive):

| Column Name | Data Type | Required | Description |
|------------|-----------|----------|-------------|
| ResourceName | Text | Yes | Name of the resource/person |
| ProjectCode | Text | Yes | Project identifier code |
| StartDate | Date | Yes | Booking start date (MM/DD/YYYY or YYYY-MM-DD) |
| EndDate | Date | Yes | Booking end date (MM/DD/YYYY or YYYY-MM-DD) |
| Hours | Number | Yes | Number of hours booked |
| BookingType | Text | No | Type of booking (optional) |
| Description | Text | No | Additional description (optional) |
| Status | Text | No | Booking status (defaults to 'Active') |

### Sample Excel Data

| ResourceName | ProjectCode | StartDate | EndDate | Hours | BookingType | Description | Status |
|-------------|-------------|-----------|---------|-------|-------------|-------------|--------|
| John Doe | PRJ-001 | 01/15/2024 | 01/19/2024 | 40 | Development | Backend work | Active |
| Jane Smith | PRJ-002 | 01/20/2024 | 01/26/2024 | 35 | Testing | QA Testing | Active |
| Bob Johnson | PRJ-001 | 02/01/2024 | 02/05/2024 | 30 | Design | UI Design | Active |

### Download Template
Click the "📥 Download Sample Template" button in the application to get a pre-formatted Excel template.

## How to Use

### Step 1: Test Database Connection
1. Open the application in your browser
2. Click "🔄 Test Connection" to verify database connectivity
3. Ensure you see a success message before proceeding

### Step 2: Prepare Your Excel File
1. Use the sample template or create your own Excel file
2. Ensure all required columns are present
3. Fill in the booking data
4. Save the file

### Step 3: Upload and Preview
1. Drag and drop your Excel file into the upload area, or click to select
2. Click "👁️ Preview" to see the first 10 rows of data
3. Verify the data looks correct

### Step 4: Process the Import
1. Click "🚀 Upload & Process" to start the import
2. Wait for processing to complete
3. Review the results

### Step 5: Review Results
The results page shows:
- **Summary**: Total records, successful imports, failures, warnings
- **Validation Errors**: Records that failed validation with specific reasons
- **Processing Errors**: Records that failed during database insertion
- **Warnings**: Non-critical issues (e.g., unusual values)
- **Duplicates**: Potential duplicate records detected

## Stored Procedure Integration

### Current Implementation
The system calls the stored procedure with the following parameters:

```javascript
request.input('ResourceName', sql.NVarChar(255), record.ResourceName);
request.input('ProjectCode', sql.NVarChar(50), record.ProjectCode);
request.input('StartDate', sql.DateTime, new Date(record.StartDate));
request.input('EndDate', sql.DateTime, new Date(record.EndDate));
request.input('Hours', sql.Decimal(10, 2), parseFloat(record.Hours));
request.input('BookingType', sql.NVarChar(50), record.BookingType);
request.input('Description', sql.NVarChar(500), record.Description);
request.input('Status', sql.NVarChar(50), record.Status || 'Active');
request.input('Action', sql.NVarChar(10), 'INSERT');
```

### Customization
To add or modify parameters:

1. **Update Validation** (`server/utils/validator.js`):
   - Add new fields to `requiredFields` array
   - Add custom validation logic

2. **Update Stored Procedure Call** (`server/services/bookingService.js`):
   - Add new `request.input()` statements with appropriate SQL data types

3. **Update Excel Structure** (Documentation):
   - Update the required columns table
   - Update the sample template

## API Endpoints

### POST /api/bookings/upload
Upload and process Excel file
- **Body**: FormData with 'file' field
- **Response**: Processing results with success/error details

### POST /api/bookings/preview
Preview Excel file without processing
- **Body**: FormData with 'file' field
- **Response**: First 10 rows and file metadata

### GET /api/bookings/test-connection
Test database connection
- **Response**: Connection status

### GET /api/bookings/procedure-info
Get stored procedure metadata
- **Response**: Parameter information

### GET /api/bookings/template
Download sample Excel template
- **Response**: Excel file download

## Error Handling

### Validation Errors
- Missing required fields
- Invalid date formats
- Invalid numeric values
- Date range issues (StartDate > EndDate)

### Processing Errors
- Database connection failures
- Stored procedure execution errors
- Data type mismatches
- Constraint violations

### User-Friendly Messages
All errors include:
- Row number where the error occurred
- Specific field causing the issue
- Clear description of the problem
- Suggested resolution

## Extensibility

### Adding New Columns

1. **Update Validator** (`server/utils/validator.js`):
```javascript
const requiredFields = ['ResourceName', 'ProjectCode', 'StartDate', 'EndDate', 'Hours', 'NewField'];
```

2. **Update Service** (`server/services/bookingService.js`):
```javascript
request.input('NewField', sql.NVarChar(100), record.NewField || null);
```

3. **Update Documentation**: Add the new column to the Excel structure table

### Custom Validation Rules
Add custom validation in `server/utils/validator.js`:

```javascript
// Example: Validate project code format
if (record.ProjectCode && !/^PRJ-\d{3}$/.test(record.ProjectCode)) {
  errors.push(`Row ${rowNumber}: ProjectCode must be in format PRJ-XXX`);
}
```

## Security Considerations

### Current Implementation
- File type validation (only .xlsx, .xls)
- File size limits (10MB default)
- SQL injection prevention (parameterized queries)
- CORS enabled for development

### Production Recommendations
- Add authentication/authorization
- Implement rate limiting
- Add audit logging
- Use HTTPS
- Validate file content (not just extension)
- Implement virus scanning
- Add user session management

## Troubleshooting

### Database Connection Issues
1. Verify `.env` file configuration
2. Check SQL Server is running and accessible
3. Verify firewall rules allow connection
4. Test credentials with SQL Server Management Studio

### Excel Parsing Errors
1. Ensure file is valid Excel format
2. Check for merged cells (not supported)
3. Verify column headers match expected names
4. Remove any special formatting

### Import Failures
1. Check validation errors in results
2. Verify stored procedure exists and is accessible
3. Check database user permissions
4. Review SQL Server logs for errors

## Performance Considerations

### Current Limitations
- Processes records sequentially (one at a time)
- No transaction management
- Limited to 10MB file size

### Optimization Opportunities
- Batch processing with transactions
- Parallel processing for large files
- Progress indicators for long-running imports
- Background job processing
- Caching database connections

## Future Enhancements

### Planned Features
- [ ] Bulk update/delete operations
- [ ] Import history and audit trail
- [ ] Scheduled imports
- [ ] Email notifications
- [ ] Data transformation rules
- [ ] Multi-sheet support
- [ ] CSV file support
- [ ] Export functionality
- [ ] User role management
- [ ] Advanced filtering and search

## Support

### Common Questions

**Q: Can I import multiple sheets?**
A: Currently, only the first sheet is processed. Multi-sheet support is planned.

**Q: What happens if some records fail?**
A: Successful records are imported, failed records are reported with details.

**Q: Can I undo an import?**
A: Not currently. Implement a soft-delete or versioning strategy in your database.

**Q: How do I handle updates vs inserts?**
A: Modify the 'Action' parameter in the stored procedure call based on your logic.

## Technical Stack

- **Frontend**: React 19, Vite, Axios, React Dropzone
- **Backend**: Node.js, Express, Multer, MSSQL
- **Excel Parsing**: SheetJS (xlsx)
- **Database**: SQL Server

## License
POC - Internal Use Only

## Version History
- **v1.0.0** (2024) - Initial POC release
  - Basic Excel import functionality
  - Validation and error reporting
  - Database integration
  - Preview functionality

---

**Note**: This is a Proof-of-Concept solution. Before deploying to production, implement proper security measures, error handling, logging, and testing.
