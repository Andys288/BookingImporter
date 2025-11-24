# 📝 Changelog

All notable changes to the Booking Importer project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-01-XX

### 🎉 Major Release - Project Restructure

This release represents a complete reorganization of the project for better maintainability and developer onboarding.

### ✨ Added
- **Comprehensive Documentation System**
  - Created `docs/` directory with all documentation
  - Added `STRUCTURE.md` - Complete project organization guide
  - Added `CONTRIBUTING.md` - Development guidelines
  - Added `CHANGELOG.md` - This file
  - Reorganized README.md for better clarity

- **Improved Project Structure**
  - Component folder pattern for React components
  - Separated templates into `public/templates/`
  - Created `database/` directory for SQL files
  - Created `scripts/dev/` and `scripts/install/` subdirectories
  - Added `archive/` directory for legacy code

- **Archive System**
  - Moved POC version to `archive/poc-version/`
  - Moved legacy tools to `archive/legacy-tools/`
  - Added `archive/README.md` with documentation

### 🔄 Changed
- **File Organization**
  - Moved SQL files to `database/schema/`
  - Moved templates to `public/templates/`
  - Moved scripts to organized subdirectories
  - Reorganized components into individual folders

- **Import Paths**
  - Updated component imports to use full paths
  - Updated template paths in backend controller

- **Documentation**
  - Completely rewrote main README.md
  - Consolidated documentation into `docs/` folder
  - Improved setup instructions

### 🗑️ Removed
- Deleted test/development files from production code:
  - `src/App-minimal.jsx`
  - `src/App-simple.jsx`
  - `src/App-test.jsx`
  - `src/TestComponent.jsx`
  - `src/components/ConnectionTest-simple.jsx`
  - `public/test.html`
  - Root `test.html`

- Removed duplicate `my-react-app/` folder (archived)

### 🐛 Fixed
- Fixed template download paths after reorganization
- Fixed component import paths after restructure

### 📚 Documentation
- Added comprehensive structure documentation
- Added contributing guidelines
- Added changelog (this file)
- Improved README with better organization
- Added archive documentation

---

## [0.3.0] - 2024-11-XX

### ✨ Added
- Dual template system (Minimum and Complete)
- Template download functionality in UI
- Comprehensive local setup guide
- Windows Authentication setup documentation

### 🔄 Changed
- Improved UI with template selection
- Enhanced error messages
- Better file upload feedback

---

## [0.2.0] - 2024-11-XX

### 🔒 Security
- **Critical:** Replaced vulnerable `xlsx` package with secure `exceljs`
- Fixed 2 high severity vulnerabilities
- Zero breaking changes in the migration

### ✨ Added
- Security fix summary documentation
- Improved Excel parsing capabilities

### 📚 Documentation
- Added `SECURITY_FIX_SUMMARY.md`
- Updated dependencies documentation

---

## [0.1.0] - 2023-11-XX

### 🎉 Initial Release - Proof of Concept

### ✨ Added
- Basic React frontend with file upload
- Express backend with API endpoints
- Excel file parsing functionality
- SQL Server integration with Windows Authentication
- Database connection testing
- Results display component
- Basic error handling
- Sample Excel template

### 🏗️ Architecture
- Frontend: React + Vite
- Backend: Express + MSSQL
- Database: SQL Server with stored procedures

### 📚 Documentation
- Initial README
- Basic setup instructions
- POC summary documentation

---

## Version History Summary

| Version | Date | Type | Description |
|---------|------|------|-------------|
| 1.0.0 | 2025-01 | Major | Complete project restructure |
| 0.3.0 | 2024-11 | Minor | Dual template system |
| 0.2.0 | 2024-11 | Patch | Security fixes |
| 0.1.0 | 2023-11 | Initial | POC release |

---

## Upgrade Guide

### From 0.3.0 to 1.0.0

#### Breaking Changes
None - This is a structural reorganization with no functional changes.

#### Migration Steps

1. **Pull latest changes:**
   ```bash
   git pull origin main
   ```

2. **Update imports (if you have custom code):**
   ```javascript
   // Old
   import FileUpload from './components/FileUpload'
   
   // New
   import FileUpload from './components/FileUpload/FileUpload'
   ```

3. **Update documentation references:**
   - Documentation is now in `docs/` folder
   - Check `docs/STRUCTURE.md` for new organization

4. **No database changes required**

5. **No configuration changes required**

#### What Changed
- File locations (see `docs/STRUCTURE.md`)
- Documentation organization
- Component folder structure
- Test files removed

#### What Stayed the Same
- All functionality
- API endpoints
- Database schema
- Environment variables
- npm scripts

---

## Contributing

When adding entries to this changelog:

1. **Use the format above**
2. **Group changes by type:**
   - ✨ Added - New features
   - 🔄 Changed - Changes to existing functionality
   - 🗑️ Removed - Removed features
   - 🐛 Fixed - Bug fixes
   - 🔒 Security - Security fixes
   - 📚 Documentation - Documentation changes

3. **Be specific and clear:**
   ```markdown
   # ✅ Good
   - Added drag and drop support for file upload
   
   # ❌ Bad
   - Improved upload
   ```

4. **Link to issues/PRs when relevant:**
   ```markdown
   - Fixed template download error (#123)
   ```

5. **Update version and date:**
   ```markdown
   ## [X.Y.Z] - YYYY-MM-DD
   ```

---

## Semantic Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0) - Breaking changes
- **MINOR** (0.X.0) - New features (backward compatible)
- **PATCH** (0.0.X) - Bug fixes (backward compatible)

### Examples

```
1.0.0 → 2.0.0  # Breaking change (e.g., API redesign)
1.0.0 → 1.1.0  # New feature (e.g., new template type)
1.0.0 → 1.0.1  # Bug fix (e.g., fix upload error)
```

---

## Release Process

1. **Update version in package.json**
2. **Update this CHANGELOG.md**
3. **Create git tag:**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```
4. **Create GitHub release**
5. **Notify team**

---

## Links

- [Project Repository](https://github.com/Andys288/BookingImporter)
- [Issue Tracker](https://github.com/Andys288/BookingImporter/issues)
- [Documentation](./README.md)

---

**Note:** This changelog started with version 1.0.0. Earlier versions are documented retroactively based on git history and commit messages.
