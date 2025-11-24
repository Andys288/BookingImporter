const ExcelJS = require('exceljs');
const path = require('path');

// Helper function to format date as YYYY-MM-DD
function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

async function generateTemplates() {
  console.log('Creating Booking Templates...\n');

  // ============================================
  // TEMPLATE 1: MINIMUM FIELDS TEMPLATE
  // ============================================
  console.log('Creating Template 1: Minimum Fields...');

  const minimumHeaders = [
    'Cust Code',
    'Resource Code', 
    'Start Date',
    'Unit Type',
    'Units',
    'Booking Type',
    'Status',
    'Description',
    'Location',
    'Detail',
    'Product',
    'Offsite',
    'SOW',
    'Role',
    'RoleName',
    'Booking Value',
    'Contact',
    'Email'
  ];

  // Sample data for minimum template
  const sampleDate = new Date('2024-01-15');
  const minimumSampleData = [
    'ACCESS UK',           // Cust Code
    'FP AS04',            // Resource Code
    formatDate(sampleDate), // Start Date (YYYY-MM-DD)
    'Day',                // Unit Type (Day or Hour)
    1,                    // Units
    'INT_PRJ',            // Booking Type
    'Provisional',        // Status
    'New EVO Testing',    // Description
    'Colchester',         // Location
    'Testing new features', // Detail
    'FocalPoint',         // Product
    'Onsite',             // Offsite (Onsite or Offsite)
    '433148',             // SOW
    '00',                 // Role
    'Consultancy',        // RoleName
    0,                    // Booking Value
    'John Smith',         // Contact
    'john.smith@example.com' // Email
  ];

  // Create workbook for minimum template
  const minWb = new ExcelJS.Workbook();
  const minWs = minWb.addWorksheet('Minimum Template');

  // Add headers
  minWs.addRow(minimumHeaders);
  
  // Style header row
  const minHeaderRow = minWs.getRow(1);
  minHeaderRow.font = { bold: true };
  minHeaderRow.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFD3D3D3' }
  };

  // Add sample data
  minWs.addRow(minimumSampleData);

  // Set column widths
  minWs.columns = [
    { width: 12 },  // Cust Code
    { width: 15 },  // Resource Code
    { width: 12 },  // Start Date
    { width: 10 },  // Unit Type
    { width: 8 },   // Units
    { width: 12 },  // Booking Type
    { width: 12 },  // Status
    { width: 20 },  // Description
    { width: 15 },  // Location
    { width: 25 },  // Detail
    { width: 12 },  // Product
    { width: 10 },  // Offsite
    { width: 10 },  // SOW
    { width: 8 },   // Role
    { width: 15 },  // RoleName
    { width: 12 },  // Booking Value
    { width: 15 },  // Contact
    { width: 25 }   // Email
  ];

  // Add instructions sheet
  const minInstrWs = minWb.addWorksheet('Instructions');
  const minInstructions = [
    ['BOOKING TEMPLATE - MINIMUM FIELDS'],
    [''],
    ['INSTRUCTIONS:'],
    ['1. Fill in the required fields in the row below the headers'],
    ['2. You can add multiple rows for bulk import'],
    ['3. Do not modify the header row'],
    ['4. Date format: YYYY-MM-DD (e.g., 2024-01-15)'],
    ['5. Unit Type: Use "Day" or "Hour"'],
    ['6. Status: Provisional, Submitted, Cancelled, Confirmed, Completed, Invoiced'],
    ['7. Offsite: Use "Onsite" or "Offsite"'],
    [''],
    ['REQUIRED FIELDS:'],
    ['- Resource Code: Must exist in the system'],
    ['- Start Date: Booking start date'],
    ['- Unit Type: Day or Hour'],
    ['- Units: Number of days/hours'],
    ['- Booking Type: Must be valid booking type code'],
    ['- Status: Current booking status'],
    ['- Role: Role code (required before entering Units)'],
    [''],
    ['OPTIONAL FIELDS:'],
    ['- All other fields are optional but recommended for complete booking information'],
    [''],
    ['TIPS:'],
    ['- Leave Primary field empty for new bookings'],
    ['- Role must be populated before entering Units'],
    ['- SOW capacity is validated automatically'],
    ['- End Date is auto-calculated based on Start Date + Units']
  ];

  minInstructions.forEach(row => minInstrWs.addRow(row));
  minInstrWs.getColumn(1).width = 80;

  // Save minimum template
  const minTemplatePath = path.join(__dirname, '../public/Booking_Template_Minimum.xlsx');
  await minWb.xlsx.writeFile(minTemplatePath);
  console.log('✓ Minimum template created:', minTemplatePath);

  // ============================================
  // TEMPLATE 2: COMPLETE FIELDS TEMPLATE
  // ============================================
  console.log('\nCreating Template 2: Complete Fields...');

  const completeHeaders = [
    'Primary',
    'Cust Code',
    'Customer',
    'Resource Code',
    'Resource Name',
    'Start Date',
    'End Date',
    'Unit Type',
    'Units',
    'Booking Type',
    'Status',
    'Description',
    'Location',
    'Detail',
    'Product',
    'Flex Points Product',
    'Offsite',
    'SOW',
    'SOW Type',
    'SOW Detail Select',
    'SOW Detail',
    'Role',
    'RoleName',
    'Booking Value',
    'Project Plan fields-->',
    'Phase',
    'Stage',
    'Sub Stage',
    'Work Packet Code',
    'Internal Notes',
    'Suppress on Plan',
    'Go Live',
    'Client Facing',
    'Client Facing Notes',
    'Client Resource',
    'ProjectCode',
    'Activity Report',
    'Invoice No',
    'Inv. Nett',
    'PO No',
    'Contact',
    'Email',
    'Additional Info-->',
    'Pre-Contract PM',
    'Pre-Contract Chargeable',
    'Requested By/Reason',
    'Type/Outcome'
  ];

  // Sample data for complete template
  const completeSampleData = [
    '',                   // Primary (leave empty for new bookings)
    'ACCESS UK',          // Cust Code
    'Access UK Ltd',      // Customer
    'FP AS04',           // Resource Code
    'Andy Smith',        // Resource Name
    formatDate(sampleDate), // Start Date
    formatDate(new Date(sampleDate.getTime() + 86400000)), // End Date (next day)
    'Day',               // Unit Type
    1,                   // Units
    'INT_PRJ',           // Booking Type
    'Provisional',       // Status
    'New EVO Testing',   // Description
    'Colchester',        // Location
    'Testing new features and functionality', // Detail
    'FocalPoint',        // Product
    '',                  // Flex Points Product
    'Onsite',            // Offsite
    '433148',            // SOW
    'Internal Projects', // SOW Type
    '',                  // SOW Detail Select
    462343,              // SOW Detail
    '00',                // Role
    'Consultancy',       // RoleName
    0,                   // Booking Value
    '',                  // Project Plan fields-->
    'Implementation',    // Phase
    'Development',       // Stage
    'Testing',           // Sub Stage
    'WP001',            // Work Packet Code
    'Internal team notes here', // Internal Notes
    'No',                // Suppress on Plan
    'No',                // Go Live
    'No',                // Client Facing
    '',                  // Client Facing Notes
    '',                  // Client Resource
    '_INT101',           // ProjectCode
    '',                  // Activity Report
    '',                  // Invoice No
    '',                  // Inv. Nett
    'PO12345',          // PO No
    'John Smith',        // Contact
    'john.smith@example.com', // Email
    '',                  // Additional Info-->
    'Jane Doe',          // Pre-Contract PM
    'No',                // Pre-Contract Chargeable
    'Requested by PM for testing', // Requested By/Reason
    'Development/Testing' // Type/Outcome
  ];

  // Create workbook for complete template
  const completeWb = new ExcelJS.Workbook();
  const completeWs = completeWb.addWorksheet('Complete Template');

  // Add headers
  completeWs.addRow(completeHeaders);
  
  // Style header row
  const completeHeaderRow = completeWs.getRow(1);
  completeHeaderRow.font = { bold: true };
  completeHeaderRow.fill = {
    type: 'pattern',
    pattern: 'solid',
    fgColor: { argb: 'FFD3D3D3' }
  };

  // Add sample data
  completeWs.addRow(completeSampleData);

  // Set column widths for complete template
  completeWs.columns = completeHeaders.map((header) => {
    // Specific widths for certain columns
    if (header.includes('Notes') || header === 'Detail') return { width: 30 };
    if (header.includes('Email')) return { width: 25 };
    if (header.includes('Date')) return { width: 12 };
    if (header.includes('Code') || header.includes('Primary')) return { width: 12 };
    if (header.includes('Name')) return { width: 18 };
    if (header.includes('-->')) return { width: 5 };
    return { width: 15 }; // Default width
  });

  // Add instructions sheet to complete template
  const completeInstrWs = completeWb.addWorksheet('Instructions');
  const completeInstructions = [
    ['BOOKING TEMPLATE - COMPLETE FIELDS (47 COLUMNS)'],
    [''],
    ['INSTRUCTIONS:'],
    ['1. This template includes all 47 available fields for comprehensive booking data'],
    ['2. Fill in as many fields as needed - not all fields are required'],
    ['3. Do not modify the header row'],
    ['4. Date format: YYYY-MM-DD (e.g., 2024-01-15)'],
    ['5. See the Minimum Template for required fields only'],
    [''],
    ['FIELD CATEGORIES:'],
    [''],
    ['CORE FIELDS (Columns A-J):'],
    ['- Primary, Customer info, Resource info, Dates, Unit Type, Units, Booking Type'],
    [''],
    ['BOOKING DETAILS (Columns K-N):'],
    ['- Status, Description, Location, Detail'],
    [''],
    ['PRODUCT & SOW (Columns O-U):'],
    ['- Product, Flex Points Product, Offsite, SOW, SOW Type, SOW Detail, Role'],
    [''],
    ['PROJECT PLANNING (Columns Y-AC):'],
    ['- Phase, Stage, Sub Stage, Work Packet Code, Internal Notes'],
    [''],
    ['CLIENT VISIBILITY (Columns AE-AI):'],
    ['- Suppress on Plan, Go Live, Client Facing, Client Facing Notes, Client Resource'],
    [''],
    ['FINANCIAL (Columns X, AM-AN):'],
    ['- Booking Value, Invoice No, Inv. Nett, PO No'],
    [''],
    ['CONTACT INFO (Columns AO-AP):'],
    ['- Contact, Email'],
    [''],
    ['ADDITIONAL INFO (Columns AR-AU):'],
    ['- Pre-Contract PM, Pre-Contract Chargeable, Requested By/Reason, Type/Outcome'],
    [''],
    ['VALIDATION RULES:'],
    ['- Role MUST be populated before entering Units'],
    ['- End Date is auto-calculated (do not edit manually)'],
    ['- SOW capacity is validated automatically'],
    ['- Role cannot be changed once SOW is assigned'],
    ['- Status must be one of: Provisional, Submitted, Cancelled, Confirmed, Completed, Invoiced']
  ];

  completeInstructions.forEach(row => completeInstrWs.addRow(row));
  completeInstrWs.getColumn(1).width = 90;

  // Save complete template
  const completeTemplatePath = path.join(__dirname, '../public/Booking_Template_Complete.xlsx');
  await completeWb.xlsx.writeFile(completeTemplatePath);
  console.log('✓ Complete template created:', completeTemplatePath);

  console.log('\n✓ Instructions added to both templates');

  // ============================================
  // SUMMARY
  // ============================================
  console.log('\n' + '='.repeat(60));
  console.log('TEMPLATE GENERATION COMPLETE!');
  console.log('='.repeat(60));
  console.log('\nFiles created:');
  console.log('1. Booking_Template_Minimum.xlsx (18 columns)');
  console.log('   Location: public/Booking_Template_Minimum.xlsx');
  console.log('   Contains: Essential fields only with instructions');
  console.log('');
  console.log('2. Booking_Template_Complete.xlsx (47 columns)');
  console.log('   Location: public/Booking_Template_Complete.xlsx');
  console.log('   Contains: All available fields with instructions');
  console.log('\nBoth templates include:');
  console.log('- Properly formatted headers');
  console.log('- Sample data row with examples');
  console.log('- Instructions sheet with field descriptions');
  console.log('- Appropriate column widths');
  console.log('- Ready for immediate use');
  console.log('='.repeat(60));
}

// Run the generator
generateTemplates().catch(error => {
  console.error('Error generating templates:', error);
  process.exit(1);
});
