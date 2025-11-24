const ExcelJS = require('exceljs');

/**
 * Parse Excel file and return data as JSON
 * @param {Buffer} fileBuffer - The Excel file buffer
 * @returns {Object} - Parsed data with sheets
 */
async function parseExcelFile(fileBuffer) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);
    
    const worksheet = workbook.worksheets[0]; // Get first sheet
    const sheetName = worksheet.name;
    
    // Get headers from first row
    const headers = [];
    const firstRow = worksheet.getRow(1);
    firstRow.eachCell((cell, colNumber) => {
      headers[colNumber - 1] = cell.value?.toString() || `Column${colNumber}`;
    });
    
    // Convert rows to JSON objects
    const data = [];
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber === 1) return; // Skip header row
      
      const rowData = {};
      row.eachCell((cell, colNumber) => {
        const header = headers[colNumber - 1];
        if (header) {
          // Handle different cell types
          let value = cell.value;
          
          // Handle dates
          if (cell.type === ExcelJS.ValueType.Date) {
            value = cell.value;
          }
          // Handle formulas - get the result
          else if (cell.type === ExcelJS.ValueType.Formula) {
            value = cell.result;
          }
          // Handle rich text
          else if (cell.value && typeof cell.value === 'object' && cell.value.richText) {
            value = cell.value.richText.map(t => t.text).join('');
          }
          // Handle hyperlinks
          else if (cell.value && typeof cell.value === 'object' && cell.value.text) {
            value = cell.value.text;
          }
          
          rowData[header] = value !== undefined && value !== null ? value : null;
        }
      });
      
      // Only add row if it has at least one non-null value
      if (Object.values(rowData).some(v => v !== null)) {
        data.push(rowData);
      }
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
async function getExcelHeaders(fileBuffer) {
  try {
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.load(fileBuffer);
    
    const worksheet = workbook.worksheets[0];
    const headers = [];
    
    const firstRow = worksheet.getRow(1);
    firstRow.eachCell((cell, colNumber) => {
      headers.push(cell.value?.toString() || `Column${colNumber}`);
    });
    
    return headers;
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
