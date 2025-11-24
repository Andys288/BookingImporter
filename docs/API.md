# 📡 API Documentation

> Complete reference for the Booking Importer REST API

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Base URL](#base-url)
3. [Authentication](#authentication)
4. [Endpoints](#endpoints)
5. [Request/Response Formats](#requestresponse-formats)
6. [Error Handling](#error-handling)
7. [Examples](#examples)

---

## 🎯 Overview

The Booking Importer API is a RESTful API built with Express.js that handles:
- Excel file uploads and processing
- Template downloads
- Database connection testing
- Stored procedure information retrieval

**Technology Stack:**
- **Framework:** Express 5
- **File Upload:** Multer
- **Excel Parsing:** ExcelJS
- **Database:** MSSQL (SQL Server)

---

## 🌐 Base URL

### Development
```
http://localhost:5000/api
```

### Production
```
https://your-domain.com/api
```

**Note:** All endpoints are prefixed with `/api`

---

## 🔐 Authentication

Currently, the API uses **Windows Authentication** for database access. No API key or token is required for HTTP requests.

**Database Authentication:**
- Type: Windows Authentication
- Configured in: `.env` file
- Connection: Automatic via Windows credentials

---

## 📍 Endpoints

### 1. Health Check

Check if the API server is running.

**Endpoint:** `GET /api/health`

**Description:** Returns the health status of the API server.

**Request:**
```http
GET /api/health HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "status": "OK",
  "message": "Booking Import API is running",
  "timestamp": "2025-01-24T12:00:00.000Z"
}
```

**Status Codes:**
- `200 OK` - Server is running

---

### 2. Test Database Connection

Test the connection to SQL Server database.

**Endpoint:** `GET /api/bookings/test-connection`

**Description:** Verifies database connectivity and returns connection status.

**Request:**
```http
GET /api/bookings/test-connection HTTP/1.1
Host: localhost:5000
```

**Success Response:**
```json
{
  "success": true,
  "message": "Database connection successful",
  "server": "YOUR_SERVER_NAME",
  "database": "YOUR_DATABASE_NAME",
  "timestamp": "2025-01-24T12:00:00.000Z"
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Connection test failed",
  "error": "Login failed for user..."
}
```

**Status Codes:**
- `200 OK` - Connection successful
- `500 Internal Server Error` - Connection failed

---

### 3. Get Stored Procedure Info

Retrieve information about the stored procedure used for booking operations.

**Endpoint:** `GET /api/bookings/procedure-info`

**Description:** Returns metadata about the `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS` stored procedure.

**Request:**
```http
GET /api/bookings/procedure-info HTTP/1.1
Host: localhost:5000
```

**Success Response:**
```json
{
  "success": true,
  "procedure": {
    "name": "TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS",
    "parameters": [
      {
        "name": "@BookingID",
        "type": "INT",
        "required": false
      },
      {
        "name": "@ProjectID",
        "type": "INT",
        "required": true
      },
      // ... more parameters
    ]
  }
}
```

**Status Codes:**
- `200 OK` - Information retrieved
- `500 Internal Server Error` - Failed to retrieve info

---

### 4. Upload and Process Bookings

Upload an Excel file and process booking records.

**Endpoint:** `POST /api/bookings/upload`

**Description:** Accepts an Excel file, validates the structure, and processes booking records through the stored procedure.

**Request:**
```http
POST /api/bookings/upload HTTP/1.1
Host: localhost:5000
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="file"; filename="bookings.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

[Binary Excel file data]
------WebKitFormBoundary--
```

**Form Data:**
- `file` (required): Excel file (.xlsx or .xls)

**Success Response:**
```json
{
  "success": true,
  "message": "File processed successfully",
  "results": {
    "fileName": "bookings.xlsx",
    "sheetName": "Sheet1",
    "totalRecords": 50,
    "successCount": 45,
    "failureCount": 3,
    "warningCount": 2,
    "validationErrors": [
      {
        "row": 5,
        "field": "StartDate",
        "message": "Invalid date format"
      }
    ],
    "processingErrors": [
      {
        "row": 12,
        "message": "Duplicate booking ID"
      }
    ],
    "warnings": [
      {
        "row": 8,
        "message": "End date is in the past"
      }
    ],
    "duplicates": []
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Invalid Excel structure",
  "missingColumns": ["ResourceName", "ProjectCode"],
  "foundColumns": ["Name", "Project", "StartDate", "EndDate", "Hours"]
}
```

**Status Codes:**
- `200 OK` - File processed successfully
- `400 Bad Request` - Invalid file or structure
- `500 Internal Server Error` - Processing error

**Validation Rules:**
- File must be .xlsx or .xls format
- File size must be under 10MB (configurable)
- Required columns must be present
- Data types must match expected format

---

### 5. Preview Excel File

Preview the contents of an Excel file without processing.

**Endpoint:** `POST /api/bookings/preview`

**Description:** Uploads and parses an Excel file, returning the first 10 rows for preview.

**Request:**
```http
POST /api/bookings/preview HTTP/1.1
Host: localhost:5000
Content-Type: multipart/form-data

[Same as upload endpoint]
```

**Success Response:**
```json
{
  "success": true,
  "fileName": "bookings.xlsx",
  "sheetName": "Sheet1",
  "totalRows": 50,
  "headers": [
    "ResourceName",
    "ProjectCode",
    "StartDate",
    "EndDate",
    "Hours"
  ],
  "preview": [
    {
      "ResourceName": "John Doe",
      "ProjectCode": "PRJ001",
      "StartDate": "2025-01-01",
      "EndDate": "2025-03-31",
      "Hours": 160
    },
    // ... up to 10 rows
  ]
}
```

**Status Codes:**
- `200 OK` - Preview generated
- `400 Bad Request` - Invalid file
- `500 Internal Server Error` - Processing error

---

### 6. Download Template

Download an Excel template for booking imports.

**Endpoint:** `GET /api/bookings/template/:type`

**Description:** Downloads a pre-formatted Excel template.

**Parameters:**
- `type` (optional): Template type
  - `minimum` - 18 columns (default)
  - `complete` - 47 columns

**Request:**
```http
GET /api/bookings/template/minimum HTTP/1.1
Host: localhost:5000
```

**Response:**
- Binary Excel file download
- Content-Type: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- Content-Disposition: `attachment; filename="Booking_Template_Minimum.xlsx"`

**Status Codes:**
- `200 OK` - File download started
- `404 Not Found` - Template file not found
- `500 Internal Server Error` - Download error

**Alternative Endpoint:**
```http
GET /api/bookings/template HTTP/1.1
```
(Defaults to minimum template)

---

## 📝 Request/Response Formats

### Content Types

**Request:**
- `multipart/form-data` - For file uploads
- `application/json` - For JSON data (future)

**Response:**
- `application/json` - For API responses
- `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` - For Excel downloads

### Standard Response Structure

**Success:**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* response data */ }
}
```

**Error:**
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

---

## ⚠️ Error Handling

### Error Response Format

```json
{
  "success": false,
  "message": "User-friendly error message",
  "error": "Technical error details",
  "code": "ERROR_CODE" // Optional
}
```

### Common Error Codes

| Status Code | Meaning | Common Causes |
|-------------|---------|---------------|
| `400` | Bad Request | Invalid file, missing fields, wrong format |
| `404` | Not Found | Template file missing, endpoint not found |
| `413` | Payload Too Large | File size exceeds limit |
| `415` | Unsupported Media Type | Wrong file type |
| `500` | Internal Server Error | Database error, processing error |

### Validation Errors

**Structure Validation:**
```json
{
  "success": false,
  "message": "Invalid Excel structure",
  "missingColumns": ["ResourceName", "ProjectCode"],
  "foundColumns": ["Name", "Project", "Date"]
}
```

**Data Validation:**
```json
{
  "success": false,
  "message": "Validation errors found",
  "validationErrors": [
    {
      "row": 5,
      "field": "StartDate",
      "value": "invalid-date",
      "message": "Invalid date format. Expected: YYYY-MM-DD"
    }
  ]
}
```

---

## 💡 Examples

### Example 1: Upload File with cURL

```bash
curl -X POST http://localhost:5000/api/bookings/upload \
  -F "file=@bookings.xlsx" \
  -H "Content-Type: multipart/form-data"
```

### Example 2: Upload File with JavaScript (Axios)

```javascript
import axios from 'axios';

const uploadFile = async (file) => {
  const formData = new FormData();
  formData.append('file', file);

  try {
    const response = await axios.post(
      'http://localhost:5000/api/bookings/upload',
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }
    );
    
    console.log('Success:', response.data);
    return response.data;
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
    throw error;
  }
};
```

### Example 3: Download Template with JavaScript

```javascript
const downloadTemplate = async (type = 'minimum') => {
  try {
    const response = await axios.get(
      `http://localhost:5000/api/bookings/template/${type}`,
      {
        responseType: 'blob'
      }
    );
    
    // Create download link
    const url = window.URL.createObjectURL(new Blob([response.data]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `Booking_Template_${type}.xlsx`);
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.URL.revokeObjectURL(url);
  } catch (error) {
    console.error('Download failed:', error);
  }
};
```

### Example 4: Test Connection

```javascript
const testConnection = async () => {
  try {
    const response = await axios.get(
      'http://localhost:5000/api/bookings/test-connection'
    );
    
    if (response.data.success) {
      console.log('✅ Connected to:', response.data.database);
    } else {
      console.error('❌ Connection failed:', response.data.error);
    }
  } catch (error) {
    console.error('❌ Request failed:', error.message);
  }
};
```

### Example 5: Preview File

```javascript
const previewFile = async (file) => {
  const formData = new FormData();
  formData.append('file', file);

  try {
    const response = await axios.post(
      'http://localhost:5000/api/bookings/preview',
      formData
    );
    
    console.log('File:', response.data.fileName);
    console.log('Rows:', response.data.totalRows);
    console.log('Headers:', response.data.headers);
    console.log('Preview:', response.data.preview);
    
    return response.data;
  } catch (error) {
    console.error('Preview failed:', error.response?.data);
    throw error;
  }
};
```

---

## 🔧 Configuration

### Environment Variables

Configure these in your `.env` file:

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Database Configuration
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# Upload Configuration
MAX_FILE_SIZE=10485760          # 10MB in bytes
ALLOWED_FILE_TYPES=.xlsx,.xls   # Comma-separated
```

### File Upload Limits

**Default Limits:**
- Max file size: 10MB
- Allowed types: .xlsx, .xls
- Max files per request: 1

**To change limits:**
Edit `server/middleware/upload.js`:
```javascript
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB
  },
  fileFilter: (req, file, cb) => {
    // Custom file filter logic
  }
});
```

---

## 🧪 Testing the API

### Using Postman

1. **Import Collection:**
   - Create a new collection
   - Add endpoints from this documentation

2. **Set Environment:**
   ```
   BASE_URL = http://localhost:5000
   ```

3. **Test Endpoints:**
   - Health Check: `{{BASE_URL}}/api/health`
   - Connection Test: `{{BASE_URL}}/api/bookings/test-connection`
   - Upload: `{{BASE_URL}}/api/bookings/upload` (with file)

### Using cURL

**Health Check:**
```bash
curl http://localhost:5000/api/health
```

**Connection Test:**
```bash
curl http://localhost:5000/api/bookings/test-connection
```

**Upload File:**
```bash
curl -X POST http://localhost:5000/api/bookings/upload \
  -F "file=@path/to/bookings.xlsx"
```

**Download Template:**
```bash
curl -O http://localhost:5000/api/bookings/template/minimum
```

---

## 📚 Related Documentation

- [Project Structure](./STRUCTURE.md) - Code organization
- [Contributing Guide](./CONTRIBUTING.md) - Development guidelines
- [Troubleshooting](./TROUBLESHOOTING.md) - Common issues

---

## 🔄 API Versioning

**Current Version:** v1 (implicit)

**Future Versioning:**
When breaking changes are introduced, we'll use URL versioning:
```
/api/v1/bookings/upload
/api/v2/bookings/upload
```

---

## 📞 Support

**Issues with the API?**
1. Check this documentation
2. Review [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
3. Check server logs
4. Open an issue on GitHub

---

**Last Updated:** January 2025  
**API Version:** 1.0.0  
**Maintained By:** Development Team
