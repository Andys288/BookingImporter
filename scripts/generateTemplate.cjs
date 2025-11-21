const ExcelJS = require('exceljs');
const path = require('path');

async function generateTemplate() {
  // Create a new workbook
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('Resource Bookings');

  // Set up column headers with styling
  worksheet.columns = [
    { header: 'ProjectID', key: 'ProjectID', width: 15 },
    { header: 'ResourceID', key: 'ResourceID', width: 15 },
    { header: 'StartDate', key: 'StartDate', width: 15 },
    { header: 'EndDate', key: 'EndDate', width: 15 },
    { header: 'AllocationPercentage', key: 'AllocationPercentage', width: 20 },
    { header: 'BookingID', key: 'BookingID', width: 15 },
    { header: 'Role', key: 'Role', width: 20 },
    { header: 'Notes', key: 'Notes', width: 30 },
    { header: 'Action', key: 'Action', width: 15 }
  ];

  // Style the header row
  const headerRow = worksheet.getRow(1);
  headerRow.font = { bold: true, color: { argb: 'FFFFFFFF' } };
  headerRow.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FF0066CC' }
  };
  headerRow.alignment = { vertical: 'middle', horizontal: 'center' };
  headerRow.height = 20;

  // Add sample data
  const sampleData = [
    {
      ProjectID: 1001,
      ResourceID: 2001,
      StartDate: new Date('2024-01-15'),
      EndDate: new Date('2024-03-15'),
      AllocationPercentage: 100,
      BookingID: null,
      Role: 'Developer',
      Notes: 'Full-time allocation',
      Action: 'INSERT'
    },
    {
      ProjectID: 1001,
      ResourceID: 2002,
      StartDate: new Date('2024-02-01'),
      EndDate: new Date('2024-04-30'),
      AllocationPercentage: 50,
      BookingID: null,
      Role: 'Designer',
      Notes: 'Part-time allocation',
      Action: 'INSERT'
    },
    {
      ProjectID: 1002,
      ResourceID: 2003,
      StartDate: new Date('2024-01-01'),
      EndDate: new Date('2024-12-31'),
      AllocationPercentage: 75,
      BookingID: null,
      Role: 'Project Manager',
      Notes: 'Year-long project',
      Action: 'INSERT'
    }
  ];

  // Add data rows
  sampleData.forEach((data, index) => {
    const row = worksheet.addRow(data);
    
    // Format date cells
    row.getCell('StartDate').numFmt = 'yyyy-mm-dd';
    row.getCell('EndDate').numFmt = 'yyyy-mm-dd';
    
    // Alternate row colors for better readability
    if (index % 2 === 0) {
      row.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FFF5F5F5' }
      };
    }
  });

  // Add data validation for Action column
  worksheet.getColumn('Action').eachCell({ includeEmpty: false }, (cell, rowNumber) => {
    if (rowNumber > 1) { // Skip header
      cell.dataValidation = {
        type: 'list',
        allowBlank: true,
        formulae: ['"INSERT,UPDATE,DELETE"']
      };
    }
  });

  // Add data validation for AllocationPercentage (0-100)
  worksheet.getColumn('AllocationPercentage').eachCell({ includeEmpty: false }, (cell, rowNumber) => {
    if (rowNumber > 1) { // Skip header
      cell.dataValidation = {
        type: 'whole',
        operator: 'between',
        showErrorMessage: true,
        formulae: [0, 100],
        errorTitle: 'Invalid Percentage',
        error: 'Allocation percentage must be between 0 and 100'
      };
    }
  });

  // Add instructions sheet
  const instructionsSheet = workbook.addWorksheet('Instructions');
  instructionsSheet.columns = [
    { header: 'Field', key: 'field', width: 25 },
    { header: 'Required', key: 'required', width: 12 },
    { header: 'Type', key: 'type', width: 15 },
    { header: 'Description', key: 'description', width: 60 }
  ];

  // Style instructions header
  const instructionsHeader = instructionsSheet.getRow(1);
  instructionsHeader.font = { bold: true, color: { argb: 'FFFFFFFF' } };
  instructionsHeader.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FF28A745' }
  };
  instructionsHeader.alignment = { vertical: 'middle', horizontal: 'center' };
  instructionsHeader.height = 20;

  // Add field descriptions
  const fieldDescriptions = [
    { field: 'ProjectID', required: 'Yes', type: 'Integer', description: 'Unique identifier for the project (e.g., 1001)' },
    { field: 'ResourceID', required: 'Yes', type: 'Integer', description: 'Unique identifier for the resource (e.g., 2001)' },
    { field: 'StartDate', required: 'Yes', type: 'Date', description: 'Booking start date in YYYY-MM-DD format' },
    { field: 'EndDate', required: 'Yes', type: 'Date', description: 'Booking end date in YYYY-MM-DD format (must be >= StartDate)' },
    { field: 'AllocationPercentage', required: 'Yes', type: 'Number', description: 'Resource allocation percentage (0-100)' },
    { field: 'BookingID', required: 'No', type: 'Integer', description: 'Required for UPDATE/DELETE operations. Leave blank for INSERT.' },
    { field: 'Role', required: 'No', type: 'Text', description: 'Role of the resource (e.g., Developer, Designer, PM)' },
    { field: 'Notes', required: 'No', type: 'Text', description: 'Additional notes or comments about the booking' },
    { field: 'Action', required: 'No', type: 'Text', description: 'Action to perform: INSERT (default), UPDATE, or DELETE' }
  ];

  fieldDescriptions.forEach((desc, index) => {
    const row = instructionsSheet.addRow(desc);
    if (index % 2 === 0) {
      row.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FFF5F5F5' }
      };
    }
  });

  // Add notes section
  instructionsSheet.addRow([]);
  const notesHeaderRow = instructionsSheet.addRow(['Important Notes']);
  notesHeaderRow.font = { bold: true, size: 14 };
  notesHeaderRow.getCell(1).fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFFFC107' }
  };

  const notes = [
    '1. All required fields must be filled in for successful import',
    '2. Dates must be in YYYY-MM-DD format',
    '3. AllocationPercentage must be between 0 and 100',
    '4. BookingID is only required for UPDATE and DELETE operations',
    '5. Action defaults to INSERT if not specified',
    '6. Ensure ProjectID and ResourceID exist in the system before importing',
    '7. EndDate must be greater than or equal to StartDate',
    '8. Remove sample data before importing your actual bookings'
  ];

  notes.forEach(note => {
    const row = instructionsSheet.addRow([note]);
    row.getCell(1).alignment = { wrapText: true };
  });

  // Save the workbook
  const outputPath = path.join(__dirname, '..', 'public', 'Resource_Booking_Template.xlsx');
  
  try {
    await workbook.xlsx.writeFile(outputPath);
    console.log(`✅ Template generated successfully: ${outputPath}`);
    console.log(`📊 File size: ${require('fs').statSync(outputPath).size} bytes`);
  } catch (error) {
    console.error('❌ Error generating template:', error);
    process.exit(1);
  }
}

// Run the generator
generateTemplate();
