# Resource Booking Import POC

## Overview
This POC solution enables project managers to import resource booking data from Excel files and transfer it to the scheduling system using the existing SQL stored procedure `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`.

## 🚀 Quick Start

### Prerequisites
- Node.js (v14 or higher)
- SQL Server database access
- Excel file with booking data

### Installation & Setup

1. **Install dependencies:**
   ```bash
   cd my-react-app
   npm install
   ```

2. **Configure database connection:**
   Edit the `.env` file with your database credentials:
   ```env
   DB_SERVER=your-server-name
   DB_DATABASE=your-database-name
   DB_USER=your-username
   DB_PASSWORD=your-password
   DB_PORT=1433
   ```

3. **Start the application:**
   
   **Terminal 1 - Backend Server:**
   ```bash
   npm run server
   ```
   Backend runs on: http://localhost:5000

   **Terminal 2 - Frontend:**
   ```bash
   npm run dev
   ```
   Frontend runs on: http://localhost:3000

4. **Access the application:**
   Open your browser to: http://localhost:3000

## 📊 Excel File Format

### Required Columns
The Excel file should contain the following columns (column names are case-insensitive):

| Column Name | Type | Required | Description | Example |
|-------------|------|----------|-------------|---------|
| **BookingID** | Integer | No | Unique booking identifier (leave empty for new bookings) | 12345 |
| **ProjectID** | Integer | Yes | Project identifier | 1001 |
| **ResourceID** | Integer | Yes | Resource/Employee identifier | 5001 |
| **StartDate** | Date | Yes | Booking start date | 2024-01-15 |
| **EndDate** | Date | Yes | Booking end date | 2024-03-15 |
| **AllocationPercentage** | Decimal | Yes | Percentage of time allocated (0-100) | 75.5 |
| **Role** | Text | No | Role/Position for this booking | Developer |
| **Notes** | Text | No | Additional notes or comments | Part-time allocation |
| **Action** | Text | No | Operation to perform: INSERT, UPDATE, or DELETE | INSERT |

### Sample Excel Template
A sample template file is available at: `public/sample-booking-template.xlsx`

You can download it from the application interface or generate a new one using:
```bash
node scripts/generateTemplate.cjs
```

### Example Data

| BookingID | ProjectID | ResourceID | StartDate | EndDate | AllocationPercentage | Role | Notes | Action |
|-----------|-----------|------------|-----------|---------|---------------------|------|-------|--------|
| | 1001 | 5001 | 2024-01-15 | 2024-03-15 | 75 | Developer | New booking | INSERT |
| 12345 | 1001 | 5002 | 2024-02-01 | 2024-04-30 | 100 | Lead | Updated dates | UPDATE |
| 12346 | | | | | | | | DELETE |

## 🔄 How It Works

### 1. Upload Process
1. User selects an Excel file (.xlsx or .xls)
2. File is uploaded to the backend server
3. Server parses the Excel file using the `xlsx` library

### 2. Validation
The system validates each row for:
- **Required fields**: ProjectID, ResourceID, StartDate, EndDate, AllocationPercentage
- **Data types**: Numeric fields are numbers, dates are valid dates
- **Date logic**: EndDate must be after StartDate
- **Allocation range**: AllocationPercentage must be between 0 and 100
- **Action validity**: Action must be INSERT, UPDATE, or DELETE (if provided)

### 3. Processing
For each valid row:
- Data is transformed into the format required by the stored procedure
- The stored procedure `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` is called with parameters:
  - `@BookingID` (INT)
  - `@ProjectID` (INT)
  - `@ResourceID` (INT)
  - `@StartDate` (DATETIME)
  - `@EndDate` (DATETIME)
  - `@AllocationPercentage` (DECIMAL)
  - `@Role` (NVARCHAR)
  - `@Notes` (NVARCHAR)
  - `@Action` (VARCHAR) - 'INSERT', 'UPDATE', or 'DELETE'

### 4. Results
The application provides:
- ✅ **Success count**: Number of records processed successfully
- ❌ **Error count**: Number of records that failed
- ⚠️ **Warnings**: Data quality issues that didn't prevent processing
- 📋 **Detailed log**: Row-by-row results with specific error messages

## 🎯 Features

### Current Features
- ✅ Excel file upload and parsing (.xlsx, .xls)
- ✅ Comprehensive data validation
- ✅ Real-time progress feedback
- ✅ Detailed error reporting with row numbers
- ✅ Support for INSERT, UPDATE, and DELETE operations
- ✅ Download sample template
- ✅ Responsive UI with drag-and-drop upload
- ✅ Transaction support (rollback on errors)

### Extensibility
The solution is designed to easily accommodate additional columns:

1. **Backend** (`server/services/bookingService.js`):
   - Add new column mapping in `parseExcelFile()` function
   - Add validation rules in `validateBookingData()` function
   - Update stored procedure parameters in `processBooking()` function

2. **Frontend** (`src/components/BookingImporter.jsx`):
   - Update the column list in the UI documentation
   - No code changes needed for basic column additions

3. **Template** (`scripts/generateTemplate.cjs`):
   - Add new columns to the `headers` array
   - Add sample data to the `sampleData` array

## 🛡️ Error Handling

### Validation Errors
- Missing required fields
- Invalid data types
- Date range issues
- Out-of-range values

### Database Errors
- Connection failures
- Stored procedure errors
- Constraint violations
- Transaction rollbacks

### File Errors
- Invalid file format
- Empty files
- Corrupted files
- Missing columns

All errors are logged with:
- Row number
- Field name
- Error description
- Suggested fix (when applicable)

## 📁 Project Structure

```
my-react-app/
├── server/
│   ├── server.js              # Express server setup
│   ├── config/
│   │   └── database.js        # Database configuration
│   ├── services/
│   │   └── bookingService.js  # Business logic for booking import
│   └── routes/
│       └── bookingRoutes.js   # API endpoints
├── src/
│   ├── components/
│   │   └── BookingImporter.jsx # Main React component
│   ├── App.jsx                # Root component
│   └── main.jsx               # Entry point
├── scripts/
│   └── generateTemplate.cjs   # Excel template generator
├── public/
│   └── sample-booking-template.xlsx # Sample template
├── .env                       # Environment variables (not in git)
└── package.json               # Dependencies and scripts
```

## 🔧 API Endpoints

### Health Check
```
GET /api/health
```
Returns server status and database connection status.

### Upload Bookings
```
POST /api/bookings/upload
Content-Type: multipart/form-data
Body: { file: <Excel file> }
```
Uploads and processes an Excel file with booking data.

**Response:**
```json
{
  "success": true,
  "message": "Import completed successfully",
  "summary": {
    "totalRows": 10,
    "successful": 8,
    "failed": 2,
    "warnings": 1
  },
  "results": [
    {
      "row": 2,
      "status": "success",
      "message": "Booking created successfully",
      "data": { ... }
    },
    {
      "row": 3,
      "status": "error",
      "message": "Missing required field: ProjectID"
    }
  ]
}
```

## 🔐 Security Considerations

- Database credentials stored in environment variables
- File upload size limits enforced
- SQL injection prevention through parameterized queries
- Input validation and sanitization
- CORS configuration for production

## 🚧 Known Limitations (POC)

1. **Single file processing**: Processes one file at a time
2. **Synchronous processing**: Large files may take time
3. **Limited batch size**: Recommended max 1000 rows per file
4. **No user authentication**: Add authentication for production
5. **Basic logging**: Enhanced logging needed for production
6. **No audit trail**: Consider adding audit logging

## 🔮 Future Enhancements

- [ ] Batch processing for large files
- [ ] Async processing with progress tracking
- [ ] User authentication and authorization
- [ ] Import history and audit trail
- [ ] Data preview before import
- [ ] Column mapping interface (drag-and-drop)
- [ ] Scheduled imports
- [ ] Email notifications
- [ ] Export validation errors to Excel
- [ ] Undo/rollback functionality

## 🧪 Testing

### Manual Testing
1. Download the sample template
2. Fill in with test data
3. Upload through the UI
4. Verify results in the database

### Test Scenarios
- ✅ Valid data import
- ✅ Missing required fields
- ✅ Invalid data types
- ✅ Date range validation
- ✅ Duplicate bookings
- ✅ UPDATE existing bookings
- ✅ DELETE bookings
- ✅ Mixed operations in one file

## 📞 Support

For issues or questions:
1. Check the error messages in the UI
2. Review the console logs (browser and server)
3. Verify database connection in `.env`
4. Ensure stored procedure exists and has correct permissions

## 📝 License

This is a POC solution. Update license information as needed for your organization.

---

**Version:** 1.0.0 (POC)  
**Last Updated:** 2024  
**Status:** Proof of Concept - Ready for evaluation and feedback
