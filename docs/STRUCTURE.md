# 📁 Project Structure Guide

> **Last Updated:** January 2025  
> **Purpose:** This document explains the organization of the Booking Importer project and provides guidelines for maintaining a clean, scalable codebase.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Frontend Organization](#frontend-organization)
4. [Backend Organization](#backend-organization)
5. [File Naming Conventions](#file-naming-conventions)
6. [Where to Add New Files](#where-to-add-new-files)
7. [Import Path Guidelines](#import-path-guidelines)
8. [Maintenance Guidelines](#maintenance-guidelines)

---

## 🎯 Overview

The Booking Importer follows a **monorepo structure** with clear separation between:
- **Frontend** (React + Vite) - User interface
- **Backend** (Express) - API and business logic
- **Database** - SQL Server schemas and procedures
- **Documentation** - All project documentation
- **Archive** - Legacy code and reference materials

### Design Principles

✅ **Single Source of Truth** - No duplicate code  
✅ **Separation of Concerns** - Clear boundaries between layers  
✅ **Self-Documenting** - Folder names explain their purpose  
✅ **Scalable** - Easy to add features without restructuring  
✅ **Onboarding-Friendly** - New developers can navigate quickly  

---

## 📂 Directory Structure

```
BookingImporter/
│
├── 📁 docs/                          # 📚 All Documentation
│   ├── README.md                     # Main project overview
│   ├── STRUCTURE.md                  # This file - project organization
│   ├── SETUP.md                      # Setup & installation guide
│   ├── WINDOWS_AUTH_SETUP.md         # Windows authentication setup
│   ├── API.md                        # API documentation
│   ├── TROUBLESHOOTING.md            # Common issues & solutions
│   ├── CONTRIBUTING.md               # Development guidelines
│   └── CHANGELOG.md                  # Version history
│
├── 📁 src/                           # 🎨 Frontend Source Code
│   ├── main.jsx                      # Application entry point
│   ├── App.jsx                       # Root React component
│   ├── App.css                       # Global application styles
│   ├── index.css                     # Base CSS reset & variables
│   │
│   ├── 📁 components/                # React UI components
│   │   ├── FileUpload/               # File upload component
│   │   │   ├── FileUpload.jsx
│   │   │   └── FileUpload.css
│   │   ├── ResultsDisplay/           # Results display component
│   │   │   ├── ResultsDisplay.jsx
│   │   │   └── ResultsDisplay.css
│   │   └── ConnectionTest/           # DB connection test component
│   │       ├── ConnectionTest.jsx
│   │       └── ConnectionTest.css
│   │
│   ├── 📁 hooks/                     # Custom React hooks (future)
│   ├── 📁 utils/                     # Frontend utility functions (future)
│   ├── 📁 constants/                 # Constants & configuration (future)
│   └── 📁 assets/                    # Static assets (images, fonts)
│
├── 📁 server/                        # 🔧 Backend Source Code
│   ├── server.js                     # Express server entry point
│   │
│   ├── 📁 config/                    # Configuration files
│   │   ├── database.js               # Standard SQL auth config
│   │   └── database-windows-auth.js  # Windows auth config
│   │
│   ├── 📁 routes/                    # API route definitions
│   │   └── bookingRoutes.js          # Booking-related routes
│   │
│   ├── 📁 controllers/               # Request handlers
│   │   └── bookingController.js      # Booking operations controller
│   │
│   ├── 📁 services/                  # Business logic layer
│   │   └── bookingService.js         # Booking business logic
│   │
│   ├── 📁 middleware/                # Express middleware
│   │   └── upload.js                 # File upload middleware (Multer)
│   │
│   └── 📁 utils/                     # Backend utility functions
│       ├── excelParser.js            # Excel file parsing
│       └── validator.js              # Data validation
│
├── 📁 public/                        # 🌐 Static Files (Served by Frontend)
│   ├── templates/                    # Excel templates for download
│   │   ├── Booking_Template_Complete.xlsx
│   │   └── Booking_Template_Minimum.xlsx
│   └── vite.svg                      # Favicon
│
├── 📁 database/                      # 🗄️ Database Files
│   ├── schema/                       # Database schema definitions
│   │   └── Scheduler_SQL_tables.sql
│   ├── stored-procedures/            # SQL stored procedures
│   │   └── TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql
│   └── migrations/                   # Database migration scripts (future)
│
├── 📁 scripts/                       # 🛠️ Development & Deployment Scripts
│   ├── dev/                          # Development utilities
│   │   ├── generateBookingTemplates.js
│   │   └── createTemplate.js
│   └── install/                      # Installation scripts
│       ├── install-windows-auth.bat
│       └── install-windows-auth.ps1
│
├── 📁 archive/                       # 📦 Legacy & Reference Files
│   ├── poc-version/                  # Original POC implementation
│   ├── legacy-tools/                 # Old VBA tools & examples
│   │   ├── BookingUpdater_v502.xla
│   │   └── Booking_Updates_example.xlsx
│   └── README.md                     # Explains archived content
│
├── 📁 tests/                         # 🧪 Test Files (Future)
│   ├── unit/                         # Unit tests
│   ├── integration/                  # Integration tests
│   └── e2e/                          # End-to-end tests
│
├── 📁 .vscode/                       # VS Code workspace settings
├── 📁 node_modules/                  # npm dependencies (gitignored)
│
├── .env                              # Environment variables (gitignored)
├── .env.example                      # Environment template
├── .gitignore                        # Git ignore rules
├── package.json                      # Project dependencies & scripts
├── package-lock.json                 # Locked dependency versions
├── vite.config.js                    # Vite bundler configuration
├── eslint.config.js                  # ESLint linting rules
├── index.html                        # HTML entry point
│
└── README.md                         # Quick start guide (links to docs/)
```

---

## 🎨 Frontend Organization

### Component Structure

Each component follows the **component folder pattern**:

```
src/components/ComponentName/
├── ComponentName.jsx     # Component logic
└── ComponentName.css     # Component styles
```

**Benefits:**
- ✅ Co-located styles with components
- ✅ Easy to find related files
- ✅ Simple to move or delete components
- ✅ Scales well as components grow

### Import Paths

```javascript
// ✅ Correct - Full path to component file
import FileUpload from './components/FileUpload/FileUpload'

// ❌ Incorrect - Missing filename
import FileUpload from './components/FileUpload'
```

### Future Directories

As the project grows, add these directories:

- **`src/hooks/`** - Custom React hooks (e.g., `useBookingUpload.js`)
- **`src/utils/`** - Frontend utilities (e.g., `formatDate.js`, `validators.js`)
- **`src/constants/`** - Constants (e.g., `apiEndpoints.js`, `errorMessages.js`)
- **`src/contexts/`** - React Context providers (e.g., `AuthContext.jsx`)
- **`src/pages/`** - If adding routing, page-level components

---

## 🔧 Backend Organization

### Layered Architecture

The backend follows a **3-layer architecture**:

```
Routes → Controllers → Services → Database
  ↓          ↓            ↓
Define    Handle      Business
endpoints requests     logic
```

#### 1. **Routes** (`server/routes/`)
- Define API endpoints
- Apply middleware
- Map URLs to controller functions

```javascript
// Example: bookingRoutes.js
router.post('/upload', upload.single('file'), uploadBookings);
```

#### 2. **Controllers** (`server/controllers/`)
- Handle HTTP requests/responses
- Validate input
- Call service layer
- Format responses

```javascript
// Example: bookingController.js
async function uploadBookings(req, res) {
  // Validate request
  // Call service
  // Return response
}
```

#### 3. **Services** (`server/services/`)
- Business logic
- Database operations
- Data transformations
- No HTTP concerns

```javascript
// Example: bookingService.js
async function processBookings(data) {
  // Business logic here
  // Database calls
  // Return results
}
```

#### 4. **Utils** (`server/utils/`)
- Reusable helper functions
- Parsing, validation, formatting
- No business logic

```javascript
// Example: excelParser.js
function parseExcelFile(buffer) {
  // Parse Excel file
  // Return structured data
}
```

---

## 📝 File Naming Conventions

### General Rules

| Type | Convention | Example |
|------|------------|---------|
| **React Components** | PascalCase | `FileUpload.jsx` |
| **JavaScript Files** | camelCase | `bookingService.js` |
| **CSS Files** | Match component | `FileUpload.css` |
| **Config Files** | kebab-case | `database-windows-auth.js` |
| **SQL Files** | PascalCase_snake_case | `Scheduler_SQL_tables.sql` |
| **Documentation** | UPPERCASE | `README.md`, `SETUP.md` |
| **Folders** | kebab-case | `stored-procedures/`, `legacy-tools/` |

### Examples

```
✅ GOOD
src/components/FileUpload/FileUpload.jsx
server/services/bookingService.js
docs/WINDOWS_AUTH_SETUP.md
database/stored-procedures/

❌ BAD
src/components/file-upload.jsx
server/services/BookingService.js
docs/windows-auth-setup.md
database/StoredProcedures/
```

---

## ➕ Where to Add New Files

### Adding a New React Component

```bash
# 1. Create component folder
mkdir src/components/NewComponent

# 2. Create component files
touch src/components/NewComponent/NewComponent.jsx
touch src/components/NewComponent/NewComponent.css

# 3. Import in parent component
# src/App.jsx
import NewComponent from './components/NewComponent/NewComponent'
```

### Adding a New API Endpoint

```bash
# 1. Add route in routes file
# server/routes/bookingRoutes.js
router.post('/new-endpoint', controllerFunction);

# 2. Add controller function
# server/controllers/bookingController.js
async function controllerFunction(req, res) { ... }

# 3. Add business logic
# server/services/bookingService.js
async function serviceFunction(data) { ... }
```

### Adding Documentation

```bash
# Add to docs/ folder with UPPERCASE name
touch docs/NEW_FEATURE.md

# Update main README.md to link to it
```

### Adding Database Changes

```bash
# Schema changes
touch database/schema/NewTable.sql

# Stored procedures
touch database/stored-procedures/NewProcedure.sql

# Migrations (future)
touch database/migrations/001_add_new_table.sql
```

### Adding Utility Scripts

```bash
# Development scripts
touch scripts/dev/newDevScript.js

# Installation scripts
touch scripts/install/newInstaller.sh
```

---

## 🔗 Import Path Guidelines

### Frontend Imports

```javascript
// Relative imports for local files
import FileUpload from './components/FileUpload/FileUpload'
import './App.css'

// Absolute imports for node_modules
import { useState } from 'react'
import axios from 'axios'
```

### Backend Imports

```javascript
// Relative imports for local modules
const bookingService = require('../services/bookingService');
const { parseExcel } = require('../utils/excelParser');

// Absolute imports for node_modules
const express = require('express');
const path = require('path');
```

### Path Aliases (Future Enhancement)

Consider adding path aliases in `vite.config.js`:

```javascript
export default defineConfig({
  resolve: {
    alias: {
      '@components': '/src/components',
      '@utils': '/src/utils',
      '@hooks': '/src/hooks'
    }
  }
})

// Then import like:
import FileUpload from '@components/FileUpload/FileUpload'
```

---

## 🧹 Maintenance Guidelines

### Regular Cleanup Tasks

#### 1. **Remove Unused Files**
```bash
# Search for unused imports
npm run lint

# Remove test files from production code
# Keep tests in tests/ folder only
```

#### 2. **Update Documentation**
- Update `CHANGELOG.md` with each release
- Keep `README.md` accurate and concise
- Document new features in `docs/`

#### 3. **Archive Old Code**
```bash
# Don't delete - archive it
mv old-feature/ archive/deprecated-features/
```

#### 4. **Dependency Management**
```bash
# Check for outdated packages
npm outdated

# Update dependencies
npm update

# Audit security
npm audit
```

### Code Organization Checklist

Before committing code, verify:

- [ ] Files are in the correct directory
- [ ] Naming conventions are followed
- [ ] No duplicate code exists
- [ ] Imports use correct paths
- [ ] No test files in production code
- [ ] Documentation is updated
- [ ] No console.log statements (use proper logging)

### When to Refactor Structure

Consider restructuring when:

1. **A folder has >10 files** - Create subfolders
2. **Duplicate code appears** - Extract to utils/
3. **Components become complex** - Split into smaller components
4. **Business logic in controllers** - Move to services/
5. **Hard-coded values** - Move to constants/

---

## 🎓 Learning Resources

### Project-Specific Docs
- [Setup Guide](./SETUP.md) - How to set up the project
- [API Documentation](./API.md) - API endpoints reference
- [Troubleshooting](./TROUBLESHOOTING.md) - Common issues

### External Resources
- [React Best Practices](https://react.dev/learn)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [Node.js Project Structure](https://github.com/goldbergyoni/nodebestpractices)

---

## 📞 Questions?

If you're unsure where a file should go:

1. Check this document first
2. Look at similar existing files
3. Ask the team in code review
4. When in doubt, follow the principle: **"Files that change together, live together"**

---

**Remember:** A well-organized codebase is a joy to work with. Take the time to put files in the right place! 🎯
