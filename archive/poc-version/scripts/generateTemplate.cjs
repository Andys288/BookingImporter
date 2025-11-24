const XLSX = require('xlsx');
const path = require('path');
const fs = require('fs');

// Sample data structure for the Excel template
const sampleData = [
  {
    'Booking ID': 'BK001',
    'Project Code': 'PROJ-2024-001',
    'Resource Name': 'John Doe',
    'Resource ID': 'RES001',
    'Start Date': '2024-01-15',
    'End Date': '2024-03-15',
    'Hours Per Day': 8,
    'Allocation %': 100,
    'Role': 'Senior Developer',
    'Department': 'Engineering',
    'Cost Center': 'CC-1001',
    'Notes': 'Full-time allocation for Q1'
  },
  {
    'Booking ID': 'BK002',
    'Project Code': 'PROJ-2024-001',
    'Resource Name': 'Jane Smith',
    'Resource ID': 'RES002',
    'Start Date': '2024-02-01',
    'End Date': '2024-04-30',
    'Hours Per Day': 4,
    'Allocation %': 50,
    'Role': 'Project Manager',
    'Department': 'PMO',
    'Cost Center': 'CC-2001',
    'Notes': 'Part-time allocation'
  },
  {
    'Booking ID': 'BK003',
    'Project Code': 'PROJ-2024-002',
    'Resource Name': 'Bob Johnson',
    'Resource ID': 'RES003',
    'Start Date': '2024-01-01',
    'End Date': '2024-06-30',
    'Hours Per Day': 8,
    'Allocation %': 100,
    'Role': 'Business Analyst',
    'Department': 'Business',
    'Cost Center': 'CC-3001',
    'Notes': 'H1 2024 project'
  }
];

// Create workbook
const wb = XLSX.utils.book_new();

// Create worksheet from sample data
const ws = XLSX.utils.json_to_sheet(sampleData);

// Set column widths
const colWidths = [
  { wch: 12 }, // Booking ID
  { wch: 15 }, // Project Code
  { wch: 20 }, // Resource Name
  { wch: 12 }, // Resource ID
  { wch: 12 }, // Start Date
  { wch: 12 }, // End Date
  { wch: 14 }, // Hours Per Day
  { wch: 14 }, // Allocation %
  { wch: 20 }, // Role
  { wch: 15 }, // Department
  { wch: 12 }, // Cost Center
  { wch: 30 }  // Notes
];
ws['!cols'] = colWidths;

// Add worksheet to workbook
XLSX.utils.book_append_sheet(wb, ws, 'Resource Bookings');

// Create instructions sheet
const instructions = [
  { 'Field': 'Booking ID', 'Required': 'Yes', 'Format': 'Text', 'Description': 'Unique identifier for the booking' },
  { 'Field': 'Project Code', 'Required': 'Yes', 'Format': 'Text', 'Description': 'Project identifier code' },
  { 'Field': 'Resource Name', 'Required': 'Yes', 'Format': 'Text', 'Description': 'Full name of the resource' },
  { 'Field': 'Resource ID', 'Required': 'Yes', 'Format': 'Text', 'Description': 'Unique resource identifier' },
  { 'Field': 'Start Date', 'Required': 'Yes', 'Format': 'YYYY-MM-DD', 'Description': 'Booking start date' },
  { 'Field': 'End Date', 'Required': 'Yes', 'Format': 'YYYY-MM-DD', 'Description': 'Booking end date' },
  { 'Field': 'Hours Per Day', 'Required': 'Yes', 'Format': 'Number', 'Description': 'Number of hours per day (0-24)' },
  { 'Field': 'Allocation %', 'Required': 'Yes', 'Format': 'Number', 'Description': 'Allocation percentage (0-100)' },
  { 'Field': 'Role', 'Required': 'No', 'Format': 'Text', 'Description': 'Role or position title' },
  { 'Field': 'Department', 'Required': 'No', 'Format': 'Text', 'Description': 'Department name' },
  { 'Field': 'Cost Center', 'Required': 'No', 'Format': 'Text', 'Description': 'Cost center code' },
  { 'Field': 'Notes', 'Required': 'No', 'Format': 'Text', 'Description': 'Additional notes or comments' }
];

const wsInstructions = XLSX.utils.json_to_sheet(instructions);
wsInstructions['!cols'] = [
  { wch: 20 },
  { wch: 10 },
  { wch: 15 },
  { wch: 50 }
];
XLSX.utils.book_append_sheet(wb, wsInstructions, 'Instructions');

// Ensure public directory exists
const publicDir = path.join(__dirname, '..', 'public');
if (!fs.existsSync(publicDir)) {
  fs.mkdirSync(publicDir, { recursive: true });
}

// Write file
const outputPath = path.join(publicDir, 'Resource_Booking_Template.xlsx');
XLSX.writeFile(wb, outputPath);

console.log('✅ Sample Excel template generated successfully!');
console.log(`📁 Location: ${outputPath}`);
console.log('\nThe template includes:');
console.log('  - Resource Bookings sheet with 3 sample records');
console.log('  - Instructions sheet with field descriptions');
console.log('\nYou can download this template from the application.');
