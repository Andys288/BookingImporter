# Booking Importer

A React + Express application for importing booking data from Excel files into SQL Server database.

## 🚀 Quick Start

### ⚠️ IMPORTANT: Windows Authentication Users

If using Windows Authentication, you **MUST** install the `msnodesqlv8` package:

```bash
npm install msnodesqlv8
```

**See [WINDOWS_AUTH_SETUP.md](WINDOWS_AUTH_SETUP.md) for complete setup instructions.**

### On Your Local Machine:

1. **Clone and install:**
   ```bash
   git clone https://github.com/Andys288/BookingImporter.git
   cd BookingImporter
   npm install
   ```

2. **For Windows Authentication (REQUIRED):**
   ```bash
   npm install msnodesqlv8
   ```
   
   **Prerequisites:**
   - Visual C++ Redistributable
   - ODBC Driver 18 for SQL Server
   - See [WINDOWS_AUTH_SETUP.md](WINDOWS_AUTH_SETUP.md) for details

3. **Configure database:**
   - Copy `.env.example` to `.env`
   - Update with your SQL Server details
   - See [LOCAL_SETUP_GUIDE.md](LOCAL_SETUP_GUIDE.md) for detailed instructions

3. **Start the application:**
   
   **Terminal 1 - Backend:**
   ```bash
   npm run server
   ```
   
   **Terminal 2 - Frontend:**
   ```bash
   npm run dev
   ```

4. **Access the app:**
   - Open http://localhost:5173 in your browser

## 📚 Documentation

- **[WINDOWS_AUTH_SETUP.md](WINDOWS_AUTH_SETUP.md)** - ⚠️ **REQUIRED** for Windows Authentication setup
- **[LOCAL_SETUP_GUIDE.md](LOCAL_SETUP_GUIDE.md)** - Complete setup instructions for local development
- **[SECURITY_FIX_SUMMARY.md](SECURITY_FIX_SUMMARY.md)** - Recent security improvements (xlsx → exceljs)
- **[STORED_PROCEDURE_ANALYSIS.md](STORED_PROCEDURE_ANALYSIS.md)** - Database stored procedure details

## ✨ Features

- 📤 **Excel File Upload** - Drag & drop or click to upload
- 📥 **Template Download** - Two template options (Minimum & Complete)
- ✅ **Data Validation** - Real-time validation of booking data
- 🔄 **Bulk Import** - Process multiple bookings at once
- 🔒 **Secure** - Uses Windows Authentication for SQL Server
- 🛡️ **No Vulnerabilities** - Replaced vulnerable xlsx with secure exceljs

## 🏗️ Architecture

```
Frontend (React + Vite)  ←→  Backend (Express)  ←→  SQL Server
     Port 5173                   Port 5000            Port 1433
```

### Tech Stack

**Frontend:**
- React 19
- Vite
- Axios
- React Dropzone

**Backend:**
- Express 5
- ExcelJS (secure Excel parsing)
- MSSQL (SQL Server driver)
- Multer (file uploads)

**Database:**
- SQL Server with Windows Authentication
- Stored Procedure: `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`

## 📋 Requirements

- Node.js v16 or higher
- SQL Server (any edition)
- Windows Authentication enabled on SQL Server
- Access to the target database

## 🔧 Configuration

Create a `.env` file in the root directory:

```env
# Database
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# Server
PORT=5000
NODE_ENV=development

# Upload
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

## 📝 Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start frontend development server |
| `npm run server` | Start backend API server |
| `npm run build` | Build frontend for production |
| `npm run preview` | Preview production build |
| `npm run lint` | Run ESLint |

## 🔐 Security

- ✅ **Zero npm vulnerabilities** (as of latest commit)
- ✅ Uses secure ExcelJS library (replaced vulnerable xlsx)
- ✅ Windows Authentication (no credentials in code)
- ✅ Input validation and sanitization
- ✅ File type and size restrictions

## 📊 Excel Templates

Two template options available:

1. **Minimum Template** (18 columns)
   - Essential fields only
   - Quick data entry
   - Download: Click "Download Minimum Template" in the app

2. **Complete Template** (47 columns)
   - All available fields
   - Comprehensive booking data
   - Download: Click "Download Complete Template" in the app

Both templates include:
- Pre-formatted headers
- Sample data row
- Instructions sheet
- Field descriptions

## 🐛 Troubleshooting

### Backend won't start
- Check SQL Server is running
- Verify `.env` configuration
- Ensure Windows user has database access

### Frontend can't connect to backend
- Make sure backend is running on port 5000
- Check for CORS errors in browser console
- Verify API URL in `src/components/FileUpload.jsx`

### Excel upload fails
- Use the provided templates
- Check all required columns are present
- Verify data format matches requirements

See [LOCAL_SETUP_GUIDE.md](LOCAL_SETUP_GUIDE.md) for detailed troubleshooting.

## 📁 Project Structure

```
BookingImporter/
├── server/                 # Backend (Express API)
│   ├── server.js          # Main server entry point
│   ├── config/            # Database configuration
│   ├── controllers/       # Request handlers
│   ├── routes/            # API routes
│   ├── services/          # Business logic
│   └── utils/             # Helper functions
├── src/                   # Frontend (React)
│   ├── App.jsx           # Main React component
│   └── components/        # React components
├── public/                # Static files & templates
├── scripts/               # Utility scripts
├── .env                   # Local configuration (create this)
├── .env.example          # Configuration template
└── package.json          # Dependencies
```

## 🔄 Recent Updates

### Latest (Commit: 568dd1c)
- Added comprehensive local setup guide
- Improved documentation

### Security Fix (Commit: 379021c)
- Replaced vulnerable `xlsx` package with secure `exceljs`
- Fixed 2 high severity vulnerabilities
- Zero breaking changes
- Improved Excel parsing capabilities

### Template System (Commit: bbbbe5f)
- Added dual template download system
- Minimum and Complete template options
- Enhanced UI with download buttons

## 🤝 Contributing

This is a private project. For questions or issues, contact the repository owner.

## 📄 License

Private - All rights reserved

## 🆘 Need Help?

1. Check [LOCAL_SETUP_GUIDE.md](LOCAL_SETUP_GUIDE.md) for setup instructions
2. Review console output for error messages
3. Check browser console (F12) for frontend errors
4. Verify database connection and stored procedure
5. Review [SECURITY_FIX_SUMMARY.md](SECURITY_FIX_SUMMARY.md) for recent changes

## 📞 Support

For support, please contact the development team or repository owner.

---

**Status:** ✅ Production Ready | 🔒 Secure | 📦 Zero Vulnerabilities

Last Updated: January 2024
