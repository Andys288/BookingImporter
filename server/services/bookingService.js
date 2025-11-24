/**
 * Booking Service
 * 
 * UPDATED FOR WINDOWS INTEGRATED SECURITY:
 * All database connections in this file now use Windows Integrated Security.
 * No username/password credentials are used - authentication is handled by Windows.
 * 
 * All stored procedure calls (insertBooking, testConnection, getStoredProcedureInfo)
 * automatically use the Windows-authenticated connection pool from getConnection().
 * 
 * No code changes were required in this file - only the underlying connection
 * configuration was updated to use Windows Authentication.
 */
const { getConnection, sql } = require('../config/database');
const { validateBookingRecord, findDuplicates, sanitizeRecord } = require('../utils/validator');

/**
 * Process and import booking records
 * @param {Array} records - Array of booking records from Excel
 * @returns {Object} - Processing results
 */
async function processBookings(records) {
  const results = {
    totalRecords: records.length,
    successCount: 0,
    failureCount: 0,
    warningCount: 0,
    validationErrors: [],
    processingErrors: [],
    warnings: [],
    duplicates: []
  };

  // Check for duplicates
  const duplicates = findDuplicates(records);
  if (duplicates.length > 0) {
    results.duplicates = duplicates;
    results.warnings.push(`Found ${duplicates.length} potential duplicate record(s)`);
  }

  // Validate all records first
  const validatedRecords = [];
  records.forEach((record, index) => {
    const rowNumber = index + 2; // +2 for 0-index and header row
    const sanitized = sanitizeRecord(record);
    const validation = validateBookingRecord(sanitized, rowNumber);
    
    if (!validation.isValid) {
      results.validationErrors.push(...validation.errors);
      results.failureCount++;
    } else {
      validatedRecords.push({ record: sanitized, rowNumber });
      if (validation.warnings.length > 0) {
        results.warnings.push(...validation.warnings);
        results.warningCount++;
      }
    }
  });

  // Process valid records
  if (validatedRecords.length > 0) {
    try {
      const pool = await getConnection();
      
      for (const { record, rowNumber } of validatedRecords) {
        try {
          await insertBooking(pool, record);
          results.successCount++;
        } catch (error) {
          results.failureCount++;
          results.processingErrors.push({
            row: rowNumber,
            error: error.message,
            record: record
          });
        }
      }
    } catch (error) {
      throw new Error(`Database connection error: ${error.message}`);
    }
  }

  return results;
}

/**
 * Insert or update booking using stored procedure
 * 
 * VERIFIED: Uses Windows Integrated Security connection
 * The pool parameter is obtained from getConnection() which now uses Windows Authentication
 * No changes needed - stored procedure execution remains the same
 * 
 * @param {Object} pool - Database connection pool (authenticated via Windows Integrated Security)
 * @param {Object} record - Booking record
 * @returns {Object} - Result from stored procedure
 */
async function insertBooking(pool, record) {
  try {
    // VERIFIED: request uses the Windows-authenticated connection pool
    const request = pool.request();
    
    // Map Excel columns to stored procedure parameters
    // Adjust these parameters based on your actual stored procedure signature
    request.input('ResourceName', sql.NVarChar(255), record.ResourceName || null);
    request.input('ProjectCode', sql.NVarChar(50), record.ProjectCode || null);
    request.input('StartDate', sql.DateTime, record.StartDate ? new Date(record.StartDate) : null);
    request.input('EndDate', sql.DateTime, record.EndDate ? new Date(record.EndDate) : null);
    request.input('Hours', sql.Decimal(10, 2), record.Hours ? parseFloat(record.Hours) : null);
    request.input('BookingType', sql.NVarChar(50), record.BookingType || null);
    request.input('Description', sql.NVarChar(500), record.Description || null);
    request.input('Status', sql.NVarChar(50), record.Status || 'Active');
    request.input('Action', sql.NVarChar(10), 'INSERT'); // INSERT, UPDATE, or DELETE
    
    // Add any additional parameters your stored procedure requires
    // request.input('ParameterName', sql.DataType, value);

    const result = await request.execute('TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS');
    
    return result;
  } catch (error) {
    throw new Error(`Failed to execute stored procedure: ${error.message}`);
  }
}

/**
 * Test database connection
 * @returns {Object} - Connection test result
 */
async function testConnection() {
  try {
    const pool = await getConnection();
    const result = await pool.request().query('SELECT 1 as test');
    return {
      success: true,
      message: 'Database connection successful',
      data: result.recordset
    };
  } catch (error) {
    return {
      success: false,
      message: 'Database connection failed',
      error: error.message
    };
  }
}

/**
 * Get stored procedure metadata (for documentation)
 * @returns {Object} - Stored procedure information
 */
async function getStoredProcedureInfo() {
  try {
    const pool = await getConnection();
    const result = await pool.request().query(`
      SELECT 
        PARAMETER_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        PARAMETER_MODE
      FROM INFORMATION_SCHEMA.PARAMETERS
      WHERE SPECIFIC_NAME = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'
      ORDER BY ORDINAL_POSITION
    `);
    
    return {
      success: true,
      parameters: result.recordset
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = {
  processBookings,
  insertBooking,
  testConnection,
  getStoredProcedureInfo
};
