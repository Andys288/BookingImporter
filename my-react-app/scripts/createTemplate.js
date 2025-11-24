const XLSX = require('xlsx');
const path = require('path');
const fs = require('fs');

// Sample data for the template
const sampleData = [
  {
    ResourceName: 'John Doe',
    ProjectCode: 'PRJ-001',
    StartDate: '01/15/2024',
    EndDate: '01/19/2024',
    Hours: 40,
    BookingType: 'Development',
    Description: 'Backend development work',
    Status: 'Active'
  },
  {
    ResourceName: 'Jane Smith',
    ProjectCode: 'PRJ-002',
    StartDate: '01/20/2024',
    EndDate: '01/26/2024',
    Hours: 35,
    BookingType: 'Testing',
    Description: 'QA Testing activities',
    Status: 'Active'
  },
  {
    ResourceName: 'Bob Johnson',
    ProjectCode: 'PRJ-001',
    StartDate: '02/01/2024',
    EndDate: '02/05/2024',
    Hours: 30,
    BookingType: 'Design',
    Description: 'UI/UX Design work',
    Status: 'Active'
  }
];

// Create a new workbook
const wb = XLSX.utils.book_new();

// Convert data to worksheet
const ws = XLSX.utils.json_to_sheet(sampleData);

// Set column widths
ws['!cols'] = [
  { wch: 20 }, // ResourceName
  { wch: 15 }, // ProjectCode
  { wch: 12 }, // StartDate
  { wch: 12 }, // EndDate
  { wch: 10 }, // Hours
  { wch: 15 }, // BookingType
  { wch: 30 }, // Description
  { wch: 10 }  // Status
];

// Add worksheet to workbook
XLSX.utils.book_append_sheet(wb, ws, 'Bookings');

// Ensure public directory exists
const publicDir = path.join(__dirname, '../public');
if (!fs.existsSync(publicDir)) {
  fs.mkdirSync(publicDir, { recursive: true });
}

// Write to file
const filePath = path.join(publicDir, 'sample-template.xlsx');
XLSX.writeFile(wb, filePath);

console.log('✅ Sample template created successfully at:', filePath);
