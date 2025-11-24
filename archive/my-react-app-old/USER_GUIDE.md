# User Guide - Resource Booking Import System

## 👋 Welcome!

This guide will help you import resource booking data from Excel files into the scheduling system.

---

## 🎯 Quick Start (5 Minutes)

### Step 1: Open the Application
Navigate to: **http://localhost:3000**

You'll see the Resource Booking Import interface.

### Step 2: Download the Template
Click the **"Download Sample Template"** button to get the Excel template.

### Step 3: Fill in Your Data
Open the downloaded Excel file and enter your booking data.

### Step 4: Upload the File
- Click **"Choose File"** or drag-and-drop your Excel file
- Click **"Upload and Process"**
- Wait for the results

### Step 5: Review Results
Check the summary and detailed results to see what was imported successfully.

---

## 📊 Understanding the Excel Template

### Required Columns (Must Have Data)

| Column | What to Enter | Example |
|--------|---------------|---------|
| **ProjectID** | The project number | 1001 |
| **ResourceID** | The employee/resource ID | 5001 |
| **StartDate** | When the booking starts | 2024-01-15 |
| **EndDate** | When the booking ends | 2024-03-15 |
| **AllocationPercentage** | How much time (0-100%) | 75 |

### Optional Columns (Nice to Have)

| Column | What to Enter | Example |
|--------|---------------|---------|
| **BookingID** | Leave empty for new bookings, fill for updates | 12345 |
| **Role** | The person's role | Developer |
| **Notes** | Any additional information | Part-time allocation |
| **Action** | INSERT, UPDATE, or DELETE | INSERT |

---

## 📝 How to Fill the Excel File

### For New Bookings (INSERT)
```
BookingID: [Leave Empty]
ProjectID: 1001
ResourceID: 5001
StartDate: 2024-01-15
EndDate: 2024-03-15
AllocationPercentage: 75
Role: Developer
Notes: New project assignment
Action: INSERT (or leave empty)
```

### For Updating Existing Bookings (UPDATE)
```
BookingID: 12345 [Must have the existing ID]
ProjectID: 1001
ResourceID: 5001
StartDate: 2024-01-15
EndDate: 2024-06-30 [Changed date]
AllocationPercentage: 100 [Changed percentage]
Role: Senior Developer [Changed role]
Notes: Extended assignment
Action: UPDATE
```

### For Deleting Bookings (DELETE)
```
BookingID: 12345 [Must have the ID to delete]
ProjectID: [Can leave empty]
ResourceID: [Can leave empty]
StartDate: [Can leave empty]
EndDate: [Can leave empty]
AllocationPercentage: [Can leave empty]
Role: [Can leave empty]
Notes: [Can leave empty]
Action: DELETE
```

---

## ✅ Data Entry Tips

### Dates
- **Format**: YYYY-MM-DD (e.g., 2024-01-15)
- **Also Accepts**: MM/DD/YYYY, DD/MM/YYYY
- **Rule**: End date must be after start date

### Allocation Percentage
- **Range**: 0 to 100
- **Decimals**: Allowed (e.g., 75.5)
- **Meaning**: 100 = full-time, 50 = half-time

### IDs (ProjectID, ResourceID, BookingID)
- **Type**: Whole numbers only
- **No Decimals**: 1001 ✅, 1001.5 ❌

### Text Fields (Role, Notes)
- **Length**: Up to 255 characters
- **Special Characters**: Allowed

---

## 🎨 Using the Interface

### Upload Area
```
┌─────────────────────────────────────┐
│  📁 Drag and drop your Excel file   │
│         here or click to browse     │
│                                     │
│  Supported: .xlsx, .xls             │
│  Max size: 10MB                     │
└─────────────────────────────────────┘
```

### After Selecting a File
```
┌─────────────────────────────────────┐
│  ✅ bookings.xlsx                   │
│  Size: 15 KB                        │
│                                     │
│  [Upload and Process]  [Cancel]     │
└─────────────────────────────────────┘
```

### Processing
```
┌─────────────────────────────────────┐
│  ⏳ Processing your file...         │
│  ████████████░░░░░░░░ 60%          │
└─────────────────────────────────────┘
```

### Results Summary
```
┌─────────────────────────────────────┐
│  ✅ Import Completed Successfully!  │
│                                     │
│  📊 Summary:                        │
│  • Total Rows: 10                   │
│  • Successful: 8                    │
│  • Failed: 2                        │
│  • Warnings: 1                      │
└─────────────────────────────────────┘
```

### Detailed Results
```
Row 2: ✅ Success - Booking created
Row 3: ✅ Success - Booking created
Row 4: ❌ Error - Missing required field: ProjectID
Row 5: ✅ Success - Booking updated
Row 6: ⚠️ Warning - Allocation is 0%
```

---

## ❌ Common Errors and How to Fix Them

### "Missing required field: ProjectID"
**Problem**: The ProjectID column is empty  
**Fix**: Enter a valid project ID number

### "Missing required field: ResourceID"
**Problem**: The ResourceID column is empty  
**Fix**: Enter a valid resource/employee ID

### "Missing required field: StartDate"
**Problem**: The StartDate column is empty  
**Fix**: Enter a valid start date

### "Missing required field: EndDate"
**Problem**: The EndDate column is empty  
**Fix**: Enter a valid end date

### "Missing required field: AllocationPercentage"
**Problem**: The AllocationPercentage column is empty  
**Fix**: Enter a percentage between 0 and 100

### "EndDate must be after StartDate"
**Problem**: The end date is before or same as start date  
**Fix**: Make sure end date is later than start date

### "AllocationPercentage must be between 0 and 100"
**Problem**: The percentage is negative or over 100  
**Fix**: Enter a value between 0 and 100

### "Invalid date format"
**Problem**: The date is not in a recognized format  
**Fix**: Use format YYYY-MM-DD (e.g., 2024-01-15)

### "ProjectID must be a number"
**Problem**: The ProjectID contains letters or symbols  
**Fix**: Enter only numbers (e.g., 1001)

### "BookingID is required for UPDATE/DELETE"
**Problem**: Trying to update/delete without a BookingID  
**Fix**: Enter the existing BookingID for the record

---

## 💡 Best Practices

### Before Uploading
1. ✅ **Check required fields** - Make sure all required columns have data
2. ✅ **Validate dates** - Ensure dates are in the correct format
3. ✅ **Check percentages** - Verify allocations are between 0-100
4. ✅ **Review IDs** - Confirm ProjectID and ResourceID are correct
5. ✅ **Save your file** - Save the Excel file before uploading

### During Upload
1. ✅ **Wait for completion** - Don't close the browser while processing
2. ✅ **Check progress** - Monitor the progress indicator
3. ✅ **Note any errors** - Pay attention to error messages

### After Upload
1. ✅ **Review summary** - Check how many records succeeded/failed
2. ✅ **Read error details** - Understand what went wrong
3. ✅ **Fix errors** - Correct the data in your Excel file
4. ✅ **Re-upload if needed** - Upload the corrected file
5. ✅ **Verify in system** - Check the scheduling system to confirm

---

## 📋 Sample Data

### Example 1: New Full-Time Booking
```
BookingID: [empty]
ProjectID: 1001
ResourceID: 5001
StartDate: 2024-01-15
EndDate: 2024-12-31
AllocationPercentage: 100
Role: Project Manager
Notes: Full year assignment
Action: INSERT
```

### Example 2: New Part-Time Booking
```
BookingID: [empty]
ProjectID: 1002
ResourceID: 5002
StartDate: 2024-03-01
EndDate: 2024-06-30
AllocationPercentage: 50
Role: Consultant
Notes: Part-time, 3 days per week
Action: INSERT
```

### Example 3: Update Existing Booking
```
BookingID: 12345
ProjectID: 1001
ResourceID: 5001
StartDate: 2024-01-15
EndDate: 2024-12-31
AllocationPercentage: 75
Role: Senior Project Manager
Notes: Reduced to 75% for training duties
Action: UPDATE
```

---

## 🔍 Troubleshooting

### File Won't Upload
- **Check file format**: Must be .xlsx or .xls
- **Check file size**: Must be under 10MB
- **Check file name**: Avoid special characters
- **Try again**: Refresh the page and try again

### All Rows Failed
- **Check column names**: Must match the template exactly
- **Check data format**: Ensure dates and numbers are correct
- **Check required fields**: All required columns must have data

### Some Rows Failed
- **Review error messages**: Each error tells you what's wrong
- **Fix the specific rows**: Correct only the failed rows
- **Re-upload**: Upload the corrected file

### Can't See Results
- **Wait for processing**: Large files take time
- **Check browser console**: Press F12 to see technical errors
- **Refresh the page**: Try reloading the application

---

## 📞 Getting Help

### Error Messages
The system provides clear error messages. Read them carefully - they tell you exactly what's wrong and which row has the problem.

### Example Error Message
```
Row 5: Missing required field: ProjectID
```
This means: In row 5 of your Excel file, the ProjectID column is empty.

### Technical Support
If you encounter issues:
1. Note the error message
2. Check which row has the problem
3. Verify your data against this guide
4. Contact your system administrator if the problem persists

---

## 🎓 Training Checklist

Before using the system independently, make sure you can:

- [ ] Download the sample template
- [ ] Open and edit the Excel file
- [ ] Fill in all required columns correctly
- [ ] Format dates properly (YYYY-MM-DD)
- [ ] Enter allocation percentages (0-100)
- [ ] Upload a file successfully
- [ ] Read and understand the results
- [ ] Fix errors based on error messages
- [ ] Re-upload corrected files

---

## 📈 Tips for Large Imports

### Planning
- **Break into batches**: Upload 100-200 rows at a time
- **Test first**: Upload a small sample to verify data format
- **Keep backups**: Save original files before making changes

### Processing
- **Be patient**: Large files take longer to process
- **Don't refresh**: Wait for the upload to complete
- **Monitor results**: Check the progress indicator

### Error Handling
- **Export errors**: Copy error messages to a separate file
- **Fix systematically**: Correct all errors of one type first
- **Verify fixes**: Double-check corrections before re-uploading

---

## ✨ Success Tips

1. **Use the template** - Always start with the provided template
2. **Fill carefully** - Double-check data before uploading
3. **Test small** - Try a few rows first before bulk upload
4. **Read errors** - Error messages are your friend
5. **Ask questions** - Don't hesitate to ask for help

---

**Happy Importing! 🚀**

If you follow this guide, you'll be importing resource bookings like a pro in no time!
