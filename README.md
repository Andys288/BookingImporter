# 📊 Booking Importer

> A modern web application for importing resource booking data from Excel files into SQL Server database.

[![Status](https://img.shields.io/badge/status-production%20ready-brightgreen)]()
[![Security](https://img.shields.io/badge/vulnerabilities-0-brightgreen)]()
[![Node](https://img.shields.io/badge/node-%3E%3D16.0.0-brightgreen)]()
[![License](https://img.shields.io/badge/license-private-red)]()

---

## 🚀 Quick Start

### Prerequisites
- Node.js v16 or higher
- SQL Server (any edition)
- Windows Authentication enabled on SQL Server

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Andys288/BookingImporter.git
cd BookingImporter

# 2. Install dependencies
npm install

# 3. For Windows Authentication (REQUIRED)
npm install msnodesqlv8
# Or run the automated installer:
# Windows: scripts/install/install-windows-auth.bat
# PowerShell: scripts/install/install-windows-auth.ps1

# 4. Configure environment
cp .env.example .env
# Edit .env with your database details

# 5. Start the application
# Terminal 1 - Backend:
npm run server

# Terminal 2 - Frontend:
npm run dev

# 6. Open your browser
# Navigate to: http://localhost:3000
```

**⚠️ First Time Setup?** See the [Complete Setup Guide](docs/SETUP.md) for detailed instructions.

---

## ✨ Features

- 📤 **Drag & Drop Upload** - Easy Excel file upload interface
- 📥 **Dual Templates** - Minimum (18 cols) and Complete (47 cols) options
- ✅ **Real-time Validation** - Instant feedback on data quality
- 🔄 **Bulk Processing** - Handle multiple bookings at once
- 🔒 **Windows Authentication** - Secure database access
- 🛡️ **Zero Vulnerabilities** - Uses secure ExcelJS library
- 📊 **Detailed Results** - Success/failure breakdown with error details
- 🔌 **Connection Testing** - Built-in database connectivity check

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[Setup Guide](docs/SETUP.md)** | Complete installation and configuration |
| **[Windows Auth Setup](docs/WINDOWS_AUTH_SETUP.md)** | ⚠️ Required for Windows Authentication |
| **[Project Structure](docs/STRUCTURE.md)** | Understanding the codebase organization |
| **[API Documentation](docs/API.md)** | Backend API reference |
| **[Troubleshooting](docs/TROUBLESHOOTING.md)** | Common issues and solutions |
| **[Contributing Guide](docs/CONTRIBUTING.md)** | Development guidelines |

---

## 🏗️ Architecture

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   Frontend      │      │    Backend      │      │   SQL Server    │
│  React + Vite   │ ←──→ │    Express      │ ←──→ │   Database      │
│  Port 3000      │      │    Port 5000    │      │   Port 1433     │
└─────────────────┘      └─────────────────┘      └─────────────────┘
```

### Tech Stack

**Frontend:**
- React 19 - UI framework
- Vite - Build tool & dev server
- Axios - HTTP client
- React Dropzone - File upload

**Backend:**
- Express 5 - Web framework
- ExcelJS - Secure Excel parsing
- MSSQL - SQL Server driver
- Multer - File upload handling

**Database:**
- SQL Server with Windows Authentication
- Stored Procedure: `TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS`

---

## 📋 Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start frontend development server (port 3000) |
| `npm run server` | Start backend API server (port 5000) |
| `npm run build` | Build frontend for production |
| `npm run preview` | Preview production build |
| `npm run lint` | Run ESLint code linting |

---

## 📁 Project Structure

```
BookingImporter/
├── docs/                   # 📚 All documentation
├── src/                    # 🎨 Frontend source (React)
│   ├── components/         # React components
│   └── assets/             # Static assets
├── server/                 # 🔧 Backend source (Express)
│   ├── config/             # Configuration
│   ├── routes/             # API routes
│   ├── controllers/        # Request handlers
│   ├── services/           # Business logic
│   ├── middleware/         # Express middleware
│   └── utils/              # Utilities
├── public/                 # 🌐 Static files
│   └── templates/          # Excel templates
├── database/               # 🗄️ Database files
│   ├── schema/             # SQL schemas
│   └── stored-procedures/  # SQL procedures
├── scripts/                # 🛠️ Utility scripts
│   ├── dev/                # Development tools
│   └── install/            # Installation scripts
├── archive/                # 📦 Legacy code
└── tests/                  # 🧪 Test files (future)
```

**📖 Detailed structure explanation:** [docs/STRUCTURE.md](docs/STRUCTURE.md)

---

## 🔐 Security

- ✅ **Zero npm vulnerabilities** (regularly audited)
- ✅ **Secure Excel parsing** (ExcelJS, not vulnerable xlsx)
- ✅ **Windows Authentication** (no credentials in code)
- ✅ **Input validation** (server-side validation)
- ✅ **File restrictions** (type and size limits)
- ✅ **SQL injection protection** (parameterized queries)

---

## 📊 Excel Templates

Two template options available for download in the application:

### 1. Minimum Template (18 columns)
- Essential fields only
- Quick data entry
- Ideal for simple bookings

### 2. Complete Template (47 columns)
- All available fields
- Comprehensive booking data
- Full feature support

Both templates include:
- Pre-formatted headers
- Sample data row
- Field descriptions
- Instructions sheet

---

## 🔧 Configuration

Create a `.env` file in the root directory:

```env
# Database Configuration
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_SERVER_CERTIFICATE=true

# Server Configuration
PORT=5000
NODE_ENV=development

# Upload Configuration
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=.xlsx,.xls
```

See [.env.example](.env.example) for all available options.

---

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check SQL Server is running
# Verify .env configuration
# Ensure Windows user has database access
```

### Frontend can't connect
```bash
# Ensure backend is running on port 5000
# Check browser console for CORS errors
# Verify API proxy in vite.config.js
```

### Excel upload fails
```bash
# Use the provided templates
# Check all required columns are present
# Verify data format matches requirements
```

**📖 More solutions:** [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 🔄 Recent Updates

### v1.0.0 (January 2025)
- ✨ Complete project restructure for better organization
- 📚 Comprehensive documentation overhaul
- 🔒 Security improvements (ExcelJS migration)
- 🎨 Dual template system
- 🧹 Removed duplicate code and test files
- 📁 Archived legacy POC version

### Previous Updates
- **Security Fix:** Replaced vulnerable `xlsx` with `exceljs`
- **Template System:** Added minimum and complete templates
- **Windows Auth:** Improved authentication setup

**📖 Full history:** [docs/CHANGELOG.md](docs/CHANGELOG.md)

---

## 🤝 Contributing

This is a private project. For development guidelines, see [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

### Development Workflow

1. Create a feature branch
2. Make your changes
3. Follow the [structure guidelines](docs/STRUCTURE.md)
4. Test thoroughly
5. Submit for review

---

## 📄 License

Private - All rights reserved

---

## 🆘 Need Help?

1. **Check the docs:** Start with [docs/SETUP.md](docs/SETUP.md)
2. **Search issues:** Look for similar problems
3. **Check logs:** 
   - Backend: Terminal running `npm run server`
   - Frontend: Browser console (F12)
4. **Review troubleshooting:** [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 📞 Support

For support, please contact the development team or repository owner.

---

## 🎯 Project Status

**Current Version:** 1.0.0  
**Status:** ✅ Production Ready  
**Security:** 🔒 Zero Vulnerabilities  
**Maintenance:** 🔄 Actively Maintained  

---

**Made with ❤️ by the Development Team**

Last Updated: January 2025
