# Excel Booking Templates - Summary

## ✅ Templates Successfully Created!

Two professional Excel templates have been generated and are ready for download and use.

---

## 📄 Template 1: Booking_Template_Minimum.xlsx

### Overview
- **Location**: `public/Booking_Template_Minimum.xlsx`
- **File Size**: 22 KB
- **Columns**: 18 essential fields
- **Sheets**: 2 (Template + Instructions)

### Included Fields
1. **Cust Code** - Customer code
2. **Resource Code** - Resource identifier (required)
3. **Start Date** - Booking start date (YYYY-MM-DD format)
4. **Unit Type** - "Day" or "Hour"
5. **Units** - Number of days/hours
6. **Booking Type** - Booking type code (required)
7. **Status** - Current status (Provisional, Submitted, etc.)
8. **Description** - Brief description
9. **Location** - Booking location
10. **Detail** - Detailed information
11. **Product** - Product/service code
12. **Offsite** - "Onsite" or "Offsite"
13. **SOW** - Statement of Work reference
14. **Role** - Role code (required before Units)
15. **RoleName** - Role description
16. **Booking Value** - Financial value
17. **Contact** - Contact person
18. **Email** - Contact email

### Features
✅ Clean, minimal design with only essential fields  
✅ Sample data row with realistic examples  
✅ Comprehensive instructions sheet  
✅ Properly formatted columns with appropriate widths  
✅ Date format: YYYY-MM-DD (e.g., 2024-01-15)  
✅ Ready for bulk import  

### Use Case
Perfect for:
- Quick booking creation
- Users who only need core fields
- Simplified data entry
- Training and onboarding

---

## 📄 Template 2: Booking_Template_Complete.xlsx

### Overview
- **Location**: `public/Booking_Template_Complete.xlsx`
- **File Size**: 26 KB
- **Columns**: 47 comprehensive fields
- **Sheets**: 2 (Template + Instructions)

### Field Categories

#### Core Fields (Columns 1-10)
- Primary, Cust Code, Customer, Resource Code, Resource Name
- Start Date, End Date, Unit Type, Units, Booking Type

#### Booking Details (Columns 11-14)
- Status, Description, Location, Detail

#### Product & SOW (Columns 15-23)
- Product, Flex Points Product, Offsite
- SOW, SOW Type, SOW Detail Select, SOW Detail
- Role, RoleName, Booking Value

#### Project Planning (Columns 25-29)
- Phase, Stage, Sub Stage
- Work Packet Code, Internal Notes

#### Visibility Controls (Columns 30-34)
- Suppress on Plan, Go Live
- Client Facing, Client Facing Notes, Client Resource

#### Project & Financial (Columns 35-40)
- ProjectCode, Activity Report
- Invoice No, Inv. Nett, PO No

#### Contact Information (Columns 41-42)
- Contact, Email

#### Additional Information (Columns 44-47)
- Pre-Contract PM, Pre-Contract Chargeable
- Requested By/Reason, Type/Outcome

### Features
✅ All 47 available fields for comprehensive data  
✅ Sample data row with examples for each field  
✅ Detailed instructions with field categories  
✅ Intelligent column widths based on content type  
✅ Supports advanced booking scenarios  
✅ Complete project planning integration  

### Use Case
Perfect for:
- Comprehensive booking management
- Advanced users needing all fields
- Complex project scenarios
- Full integration with project planning
- Complete audit trail requirements

---

## 📋 Common Features (Both Templates)

### Instructions Sheet
Both templates include a dedicated "Instructions" sheet with:
- Step-by-step usage guide
- Field descriptions and requirements
- Validation rules
- Tips and best practices
- Format examples

### Data Validation
- **Date Format**: YYYY-MM-DD (e.g., 2024-01-15)
- **Status Values**: Provisional, Submitted, Cancelled, Confirmed, Completed, Invoiced
- **Unit Type**: Day or Hour
- **Offsite**: Onsite or Offsite
- **Yes/No Fields**: Yes or No

### Critical Rules
⚠️ **Role Requirement**: Role MUST be populated before entering Units  
⚠️ **SOW Capacity**: Bookings cannot exceed available SOW capacity  
⚠️ **Role Lock**: Role cannot be changed once SOW is assigned  
⚠️ **End Date**: Auto-calculated based on Start Date + Units (do not edit manually)  

### Sample Data
Both templates include a complete sample row with realistic data:
- Customer: ACCESS UK / Access UK Ltd
- Resource: FP AS04 / Andy Smith
- Date: 2024-01-15
- Type: Day booking (1 unit)
- Status: Provisional
- Location: Colchester
- Product: FocalPoint
- SOW: 433148
- Role: 00 (Consultancy)

---

## 🚀 How to Use

### Download Templates
Templates are located in the `public/` directory:
```
public/Booking_Template_Minimum.xlsx
public/Booking_Template_Complete.xlsx
```

### Quick Start
1. **Download** the appropriate template
2. **Open** in Microsoft Excel or compatible software
3. **Read** the Instructions sheet
4. **Fill in** your booking data (row 2 onwards)
5. **Save** and upload to the booking import system

### Bulk Import
- Add multiple rows for bulk import
- Keep the header row unchanged
- Ensure all required fields are populated
- Validate data before upload

### Field Requirements
**Always Required:**
- Resource Code
- Start Date
- Unit Type
- Units
- Booking Type
- Status
- Role (must be set before Units)

**Conditionally Required:**
- Based on booking type configuration
- SOW fields (if using SOW)
- Custom fields (as configured in system)

---

## 📊 Template Comparison

| Feature | Minimum Template | Complete Template |
|---------|-----------------|-------------------|
| **Columns** | 18 | 47 |
| **File Size** | 22 KB | 26 KB |
| **Complexity** | Simple | Comprehensive |
| **Use Case** | Quick bookings | Full project integration |
| **Learning Curve** | Easy | Moderate |
| **Data Completeness** | Essential only | Complete |
| **Best For** | New users, simple bookings | Advanced users, complex projects |

---

## 🔧 Technical Details

### File Format
- **Format**: Excel 2007+ (.xlsx)
- **Compatibility**: Microsoft Excel, LibreOffice Calc, Google Sheets
- **Encoding**: UTF-8
- **Date Format**: ISO 8601 (YYYY-MM-DD)

### Column Widths
Automatically optimized based on content:
- Short codes: 8-12 characters
- Names: 15-18 characters
- Descriptions: 20-25 characters
- Notes/Details: 30 characters
- Email addresses: 25 characters

### Sheets Structure
1. **Main Template Sheet**: Data entry area with headers and sample
2. **Instructions Sheet**: Comprehensive usage guide

---

## ✅ Validation Checklist

Before uploading your completed template:

- [ ] Header row is unchanged
- [ ] All required fields are populated
- [ ] Dates are in YYYY-MM-DD format
- [ ] Role is populated before Units
- [ ] Status values are valid
- [ ] Unit Type is "Day" or "Hour"
- [ ] Offsite is "Onsite" or "Offsite"
- [ ] Email addresses are valid format
- [ ] No empty rows between data
- [ ] Sample row removed or updated

---

## 🆘 Support

### Common Issues

**Problem**: Date not recognized  
**Solution**: Use YYYY-MM-DD format (e.g., 2024-01-15)

**Problem**: "Invalid record: Role is Null!"  
**Solution**: Populate Role field before entering Units

**Problem**: SOW capacity exceeded  
**Solution**: Reduce units or select different SOW

**Problem**: Cannot change Role  
**Solution**: Role is locked when SOW is assigned - remove SOW first

### Getting Help
- Review the Instructions sheet in each template
- Check TROUBLESHOOTING.md in the project
- Refer to STORED_PROCEDURE_ANALYSIS.md for field details
- Contact FinSys team for technical support

---

## 📝 Version History

**Version 1.0** - November 23, 2024
- Initial release
- Minimum template (18 fields)
- Complete template (47 fields)
- Instructions sheets added
- Sample data included
- Professional formatting applied

---

## 🎯 Next Steps

1. **Download** the template that suits your needs
2. **Review** the Instructions sheet
3. **Fill in** your booking data
4. **Validate** your data against the checklist
5. **Upload** to the booking import system
6. **Monitor** the import results

---

**Templates are ready for immediate use!** 🎉

For questions or issues, refer to the project documentation or contact the support team.
