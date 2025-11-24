# 📦 Archive Directory

This directory contains legacy code, deprecated features, and reference materials that are no longer actively used in the project but are preserved for historical reference.

## 📂 Contents

### `my-react-app-old/`
**Original Project Structure (Pre-Reorganization)**

This folder contains the complete original project structure before the January 2025 reorganization. It was previously the main `my-react-app/` directory.

- **Archived:** January 2025
- **Status:** Superseded by root-level structure
- **Purpose:** Reference for project history
- **Contains:** Complete duplicate of old structure with all documentation

### `poc-version/`
**Original Proof of Concept Implementation**

This folder contains the complete original POC version of the Booking Importer that was located in the `my-react-app/` directory.

- **Created:** November 2023
- **Status:** Superseded by current implementation
- **Purpose:** Reference for understanding project evolution
- **Key Differences from Current:**
  - Used `xlsx` library (now replaced with `exceljs` for security)
  - Different component structure
  - Older documentation
  - Single template system (now dual template)

**Files Included:**
- Complete source code (`src/`, `server/`)
- Original documentation (10+ markdown files)
- Old templates and scripts
- Original package.json with dependencies

### `legacy-tools/`
**Pre-Web Application Tools**

This folder contains the original VBA-based Excel tools that were used before the web application was developed.

#### `BookingUpdater_v502.xla`
- **Type:** Excel Add-in (VBA Macro)
- **Version:** 5.02
- **Purpose:** Original Excel-based booking updater
- **Status:** Replaced by web application
- **Use Case:** Reference for understanding original workflow

#### `Booking_Updates_example.xlsx`
- **Type:** Excel Workbook
- **Purpose:** Example data file showing the old format
- **Status:** Reference only
- **Use Case:** Understanding data migration from old system

### `test.html`
**Legacy Test File**

- Simple HTML test file from early development
- No longer needed with proper testing framework

## 🚫 Important Notes

### Do NOT Use These Files For:
- ❌ Active development
- ❌ Production deployments
- ❌ New feature reference
- ❌ Dependency management

### DO Use These Files For:
- ✅ Understanding project history
- ✅ Comparing old vs new implementations
- ✅ Recovering lost documentation
- ✅ Training/onboarding context
- ✅ Audit trail

## 🗑️ Deletion Policy

**These files are preserved indefinitely** unless:
1. Storage becomes an issue
2. Legal/compliance requires deletion
3. Team consensus agrees they're no longer valuable

Before deleting anything:
- Document what was removed
- Update this README
- Notify the team
- Consider creating a backup

## 📝 Adding to Archive

When archiving code:

1. **Create a descriptive subfolder:**
   ```bash
   mkdir archive/feature-name-YYYY-MM/
   ```

2. **Move the files:**
   ```bash
   mv path/to/old/code archive/feature-name-YYYY-MM/
   ```

3. **Document it:**
   - Add entry to this README
   - Include date, reason, and what replaced it
   - Note any important context

4. **Update .gitignore if needed:**
   - Archive is tracked in git
   - But large binaries might need exclusion

## 📊 Archive History

| Date | Item | Reason | Replaced By |
|------|------|--------|-------------|
| Jan 2025 | `my-react-app/` → `my-react-app-old/` | Duplicate structure cleanup | Root-level `src/`, `server/`, etc. |
| Jan 2025 | POC files → `poc-version/` | Project restructure | Current implementation |
| Jan 2025 | `BookingUpdater v502.xla` | Superseded by web app | Current application |
| Jan 2025 | `Booking Updates example.xlsx` | Old format | New template system |
| Jan 2025 | `test.html` | Moved to proper tests | `tests/` directory (future) |

## 🔍 Finding Archived Code

### Search by Feature
```bash
# Find all files related to a feature
find archive/ -name "*feature-name*"
```

### Search by Date
```bash
# Find folders from a specific year
ls -la archive/ | grep 2023
```

### Search Content
```bash
# Search for specific code or text
grep -r "search term" archive/
```

## 📞 Questions?

If you need to:
- **Restore archived code** - Contact the tech lead
- **Understand archived features** - Check the documentation in the archived folder
- **Delete archived items** - Requires team approval

---

**Remember:** Archive is not a dumping ground. Only archive code that has historical value! 🎯
