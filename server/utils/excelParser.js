const XLSX = require('xlsx');

/**
 * Parse Excel file and return data as JSON
 * @param {Buffer} fileBuffer - The Excel file buffer
 * @returns {Object} - Parsed data with sheets
 */
function parseExcelFile(fileBuffer) {
  try {
    const workbook = XLSX.read(fileBuffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0]; // Get first sheet
    const worksheet = workbook.Sheets[sheetName];
    
    // Convert to JSON with header row
    const data = XLSX.utils.sheet_to_json(worksheet, {
      raw: false, // Format dates and numbers as strings
      defval: null // Use null for empty cells
    });

    return {
      sheetName,
      data,
      totalRows: data.length
    };
  } catch (error) {
    throw new Error(`Failed to parse Excel file: ${error.message}`);
  }
}

/**
 * Get column headers from Excel file
 * @param {Buffer} fileBuffer - The Excel file buffer
 * @returns {Array} - Array of column headers
 */
function getExcelHeaders(fileBuffer) {
  try {
    const workbook = XLSX.read(fileBuffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    const data = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
    return data[0] || [];
  } catch (error) {
    throw new Error(`Failed to read Excel headers: ${error.message}`);
  }
}

/**
 * Validate Excel file structure
 * @param {Array} headers - Column headers from Excel
 * @param {Array} requiredColumns - Required column names
 * @returns {Object} - Validation result
 */
function validateExcelStructure(headers, requiredColumns) {
  const missingColumns = [];
  const normalizedHeaders = headers.map(h => h?.toString().trim().toLowerCase());
  
  requiredColumns.forEach(col => {
    const normalizedCol = col.toLowerCase();
    if (!normalizedHeaders.includes(normalizedCol)) {
      missingColumns.push(col);
    }
  });

  return {
    isValid: missingColumns.length === 0,
    missingColumns,
    foundColumns: headers
  };
}

module.exports = {
  parseExcelFile,
  getExcelHeaders,
  validateExcelStructure
};
