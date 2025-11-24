/**
 * Validate a single booking record
 * @param {Object} record - Booking record to validate
 * @param {number} rowNumber - Row number for error reporting
 * @returns {Object} - Validation result with errors
 */
function validateBookingRecord(record, rowNumber) {
  const errors = [];
  const warnings = [];

  // Example validation rules (customize based on your requirements)
  
  // Required fields validation
  const requiredFields = ['ResourceName', 'ProjectCode', 'StartDate', 'EndDate', 'Hours'];
  
  requiredFields.forEach(field => {
    if (!record[field] || record[field].toString().trim() === '') {
      errors.push(`Row ${rowNumber}: Missing required field '${field}'`);
    }
  });

  // Date validation
  if (record.StartDate && record.EndDate) {
    const startDate = parseDate(record.StartDate);
    const endDate = parseDate(record.EndDate);
    
    if (!startDate) {
      errors.push(`Row ${rowNumber}: Invalid StartDate format '${record.StartDate}'`);
    }
    if (!endDate) {
      errors.push(`Row ${rowNumber}: Invalid EndDate format '${record.EndDate}'`);
    }
    
    if (startDate && endDate && startDate > endDate) {
      errors.push(`Row ${rowNumber}: StartDate cannot be after EndDate`);
    }
  }

  // Numeric validation
  if (record.Hours !== null && record.Hours !== undefined) {
    const hours = parseFloat(record.Hours);
    if (isNaN(hours)) {
      errors.push(`Row ${rowNumber}: Hours must be a valid number`);
    } else if (hours < 0) {
      errors.push(`Row ${rowNumber}: Hours cannot be negative`);
    } else if (hours > 24) {
      warnings.push(`Row ${rowNumber}: Hours value (${hours}) exceeds 24 hours per day`);
    }
  }

  // Email validation (if email field exists)
  if (record.Email && !isValidEmail(record.Email)) {
    errors.push(`Row ${rowNumber}: Invalid email format '${record.Email}'`);
  }

  return {
    isValid: errors.length === 0,
    errors,
    warnings,
    rowNumber
  };
}

/**
 * Parse date from various formats
 * @param {string} dateString - Date string to parse
 * @returns {Date|null} - Parsed date or null if invalid
 */
function parseDate(dateString) {
  if (!dateString) return null;
  
  // Try parsing as ISO date
  const date = new Date(dateString);
  if (!isNaN(date.getTime())) {
    return date;
  }
  
  // Try parsing common formats (MM/DD/YYYY, DD/MM/YYYY, etc.)
  const formats = [
    /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/, // MM/DD/YYYY or DD/MM/YYYY
    /^(\d{4})-(\d{1,2})-(\d{1,2})$/,   // YYYY-MM-DD
  ];
  
  for (const format of formats) {
    const match = dateString.match(format);
    if (match) {
      const parsedDate = new Date(dateString);
      if (!isNaN(parsedDate.getTime())) {
        return parsedDate;
      }
    }
  }
  
  return null;
}

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} - True if valid
 */
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Check for duplicate records
 * @param {Array} records - Array of booking records
 * @returns {Array} - Array of duplicate groups
 */
function findDuplicates(records) {
  const duplicates = [];
  const seen = new Map();
  
  records.forEach((record, index) => {
    // Create a unique key based on critical fields
    const key = `${record.ResourceName}-${record.ProjectCode}-${record.StartDate}-${record.EndDate}`;
    
    if (seen.has(key)) {
      duplicates.push({
        rows: [seen.get(key), index + 2], // +2 because of 0-index and header row
        record: record
      });
    } else {
      seen.set(key, index + 2);
    }
  });
  
  return duplicates;
}

/**
 * Sanitize record data
 * @param {Object} record - Record to sanitize
 * @returns {Object} - Sanitized record
 */
function sanitizeRecord(record) {
  const sanitized = {};
  
  for (const [key, value] of Object.entries(record)) {
    if (value === null || value === undefined) {
      sanitized[key] = null;
    } else if (typeof value === 'string') {
      sanitized[key] = value.trim();
    } else {
      sanitized[key] = value;
    }
  }
  
  return sanitized;
}

module.exports = {
  validateBookingRecord,
  parseDate,
  isValidEmail,
  findDuplicates,
  sanitizeRecord
};
