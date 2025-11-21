const ExcelJS = require('exceljs');

/**
 * Parse Excel file buffer and extract data
 * @param {Buffer} fileBuffer - Excel file buffer
 * @returns {Object} - Parsed data with metadata
 */
async function parseExcelFile(fileBuffer) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);

    // Get the first worksheet
    const worksheet = workbook.worksheets[0];
    
    if (!worksheet) {
      throw new Error('No worksheet found in Excel file');
    }

    const data = [];
    const headers = [];
    let headerRow = null;

    // Get headers from first row
    worksheet.getRow(1).eachCell((cell, colNumber) => {
      headers.push(cell.value ? String(cell.value).trim() : `Column${colNumber}`);
    });

    // Parse data rows (skip header row)
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber === 1) {
        headerRow = row;
        return; // Skip header row
      }

      const rowData = {};
      row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
        const header = headers[colNumber - 1];
        
        // Handle different cell types
        let value = cell.value;
        
        if (value && typeof value === 'object') {
          // Handle date objects
          if (value instanceof Date) {
            value = value.toISOString().split('T')[0]; // Format as YYYY-MM-DD
          }
          // Handle rich text
          else if (value.richText) {
            value = value.richText.map(t => t.text).join('');
          }
          // Handle hyperlinks
          else if (value.text) {
            value = value.text;
          }
          // Handle formulas
          else if (value.result !== undefined) {
            value = value.result;
          }
        }
        
        rowData[header] = value;
      });

      // Only add rows that have at least one non-empty value
      if (Object.values(rowData).some(val => val !== null && val !== undefined && val !== '')) {
        data.push(rowData);
      }
    });

    return {
      data,
      totalRows: data.length,
      sheetName: worksheet.name,
      headers
    };
  } catch (error) {
    throw new Error(`Failed to parse Excel file: ${error.message}`);
  }
}

/**
 * Get headers from Excel file
 * @param {Buffer} fileBuffer - Excel file buffer
 * @returns {Array} - Array of header names
 */
async function getExcelHeaders(fileBuffer) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);

    const worksheet = workbook.worksheets[0];
    
    if (!worksheet) {
      throw new Error('No worksheet found in Excel file');
    }

    const headers = [];
    worksheet.getRow(1).eachCell((cell, colNumber) => {
      headers.push(cell.value ? String(cell.value).trim() : `Column${colNumber}`);
    });

    return headers;
  } catch (error) {
    throw new Error(`Failed to read Excel headers: ${error.message}`);
  }
}

/**
 * Validate Excel file structure
 * @param {Array} headers - Array of header names from Excel
 * @param {Array} requiredColumns - Array of required column names
 * @returns {Object} - Validation result
 */
function validateExcelStructure(headers, requiredColumns) {
  const normalizedHeaders = headers.map(h => h.toLowerCase().trim());
  const normalizedRequired = requiredColumns.map(c => c.toLowerCase().trim());
  
  const missingColumns = normalizedRequired.filter(
    col => !normalizedHeaders.includes(col)
  );

  return {
    isValid: missingColumns.length === 0,
    missingColumns: missingColumns,
    foundColumns: headers,
    requiredColumns: requiredColumns
  };
}

/**
 * Convert Excel date serial number to JavaScript Date
 * @param {Number} serial - Excel date serial number
 * @returns {Date} - JavaScript Date object
 */
function excelDateToJSDate(serial) {
  const utc_days = Math.floor(serial - 25569);
  const utc_value = utc_days * 86400;
  const date_info = new Date(utc_value * 1000);

  const fractional_day = serial - Math.floor(serial) + 0.0000001;
  let total_seconds = Math.floor(86400 * fractional_day);

  const seconds = total_seconds % 60;
  total_seconds -= seconds;

  const hours = Math.floor(total_seconds / (60 * 60));
  const minutes = Math.floor(total_seconds / 60) % 60;

  return new Date(
    date_info.getFullYear(),
    date_info.getMonth(),
    date_info.getDate(),
    hours,
    minutes,
    seconds
  );
}

/**
 * Format date to YYYY-MM-DD
 * @param {Date|String|Number} date - Date to format
 * @returns {String} - Formatted date string
 */
function formatDate(date) {
  if (!date) return null;
  
  let dateObj;
  
  if (typeof date === 'number') {
    // Excel serial date
    dateObj = excelDateToJSDate(date);
  } else if (typeof date === 'string') {
    dateObj = new Date(date);
  } else if (date instanceof Date) {
    dateObj = date;
  } else {
    return null;
  }

  if (isNaN(dateObj.getTime())) {
    return null;
  }

  const year = dateObj.getFullYear();
  const month = String(dateObj.getMonth() + 1).padStart(2, '0');
  const day = String(dateObj.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
}

/**
 * Get worksheet names from Excel file
 * @param {Buffer} fileBuffer - Excel file buffer
 * @returns {Array} - Array of worksheet names
 */
async function getWorksheetNames(fileBuffer) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);

    return workbook.worksheets.map(ws => ws.name);
  } catch (error) {
    throw new Error(`Failed to read worksheet names: ${error.message}`);
  }
}

/**
 * Parse specific worksheet by name
 * @param {Buffer} fileBuffer - Excel file buffer
 * @param {String} sheetName - Name of worksheet to parse
 * @returns {Object} - Parsed data with metadata
 */
async function parseWorksheet(fileBuffer, sheetName) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);

    const worksheet = workbook.getWorksheet(sheetName);
    
    if (!worksheet) {
      throw new Error(`Worksheet "${sheetName}" not found`);
    }

    const data = [];
    const headers = [];

    // Get headers from first row
    worksheet.getRow(1).eachCell((cell, colNumber) => {
      headers.push(cell.value ? String(cell.value).trim() : `Column${colNumber}`);
    });

    // Parse data rows (skip header row)
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber === 1) return; // Skip header row

      const rowData = {};
      row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
        const header = headers[colNumber - 1];
        
        let value = cell.value;
        
        if (value && typeof value === 'object') {
          if (value instanceof Date) {
            value = value.toISOString().split('T')[0];
          } else if (value.richText) {
            value = value.richText.map(t => t.text).join('');
          } else if (value.text) {
            value = value.text;
          } else if (value.result !== undefined) {
            value = value.result;
          }
        }
        
        rowData[header] = value;
      });

      if (Object.values(rowData).some(val => val !== null && val !== undefined && val !== '')) {
        data.push(rowData);
      }
    });

    return {
      data,
      totalRows: data.length,
      sheetName: worksheet.name,
      headers
    };
  } catch (error) {
    throw new Error(`Failed to parse worksheet: ${error.message}`);
  }
}

module.exports = {
  parseExcelFile,
  getExcelHeaders,
  validateExcelStructure,
  excelDateToJSDate,
  formatDate,
  getWorksheetNames,
  parseWorksheet
};
