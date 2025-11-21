const fs = require('fs').promises;
const path = require('path');
const { parseExcelFile, getExcelHeaders, validateExcelStructure } = require('../utils/excelParser');
const { processBookings, testConnection, getStoredProcedureInfo } = require('../services/bookingService');

/**
 * Upload and process Excel file
 */
async function uploadBookings(req, res) {
  let filePath = null;
  
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    filePath = req.file.path;
    const fileBuffer = await fs.readFile(filePath);

    // Parse Excel file
    const { data, totalRows, sheetName } = parseExcelFile(fileBuffer);

    if (totalRows === 0) {
      return res.status(400).json({
        success: false,
        message: 'Excel file is empty'
      });
    }

    // Get headers for validation
    const headers = getExcelHeaders(fileBuffer);
    
    // Define required columns (customize based on your needs)
    const requiredColumns = ['ResourceName', 'ProjectCode', 'StartDate', 'EndDate', 'Hours'];
    const structureValidation = validateExcelStructure(headers, requiredColumns);

    if (!structureValidation.isValid) {
      return res.status(400).json({
        success: false,
        message: 'Invalid Excel structure',
        missingColumns: structureValidation.missingColumns,
        foundColumns: structureValidation.foundColumns
      });
    }

    // Process bookings
    const results = await processBookings(data);

    // Clean up uploaded file
    await fs.unlink(filePath);

    return res.status(200).json({
      success: true,
      message: 'File processed successfully',
      results: {
        fileName: req.file.originalname,
        sheetName: sheetName,
        totalRecords: results.totalRecords,
        successCount: results.successCount,
        failureCount: results.failureCount,
        warningCount: results.warningCount,
        validationErrors: results.validationErrors,
        processingErrors: results.processingErrors,
        warnings: results.warnings,
        duplicates: results.duplicates
      }
    });

  } catch (error) {
    // Clean up file on error
    if (filePath) {
      try {
        await fs.unlink(filePath);
      } catch (unlinkError) {
        console.error('Error deleting file:', unlinkError);
      }
    }

    console.error('Upload error:', error);
    return res.status(500).json({
      success: false,
      message: 'Error processing file',
      error: error.message
    });
  }
}

/**
 * Preview Excel file without processing
 */
async function previewFile(req, res) {
  let filePath = null;
  
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No file uploaded'
      });
    }

    filePath = req.file.path;
    const fileBuffer = await fs.readFile(filePath);

    // Parse Excel file
    const { data, totalRows, sheetName } = parseExcelFile(fileBuffer);
    const headers = getExcelHeaders(fileBuffer);

    // Get first 10 rows for preview
    const preview = data.slice(0, 10);

    // Clean up uploaded file
    await fs.unlink(filePath);

    return res.status(200).json({
      success: true,
      fileName: req.file.originalname,
      sheetName: sheetName,
      totalRows: totalRows,
      headers: headers,
      preview: preview
    });

  } catch (error) {
    // Clean up file on error
    if (filePath) {
      try {
        await fs.unlink(filePath);
      } catch (unlinkError) {
        console.error('Error deleting file:', unlinkError);
      }
    }

    console.error('Preview error:', error);
    return res.status(500).json({
      success: false,
      message: 'Error previewing file',
      error: error.message
    });
  }
}

/**
 * Test database connection
 */
async function testDatabaseConnection(req, res) {
  try {
    const result = await testConnection();
    return res.status(result.success ? 200 : 500).json(result);
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Connection test failed',
      error: error.message
    });
  }
}

/**
 * Get stored procedure information
 */
async function getProcedureInfo(req, res) {
  try {
    const result = await getStoredProcedureInfo();
    return res.status(result.success ? 200 : 500).json(result);
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve procedure information',
      error: error.message
    });
  }
}

/**
 * Download sample Excel template
 */
async function downloadTemplate(req, res) {
  try {
    const templatePath = path.join(__dirname, '../../public/sample-template.xlsx');
    
    // Check if template exists
    try {
      await fs.access(templatePath);
      return res.download(templatePath, 'booking-template.xlsx');
    } catch (error) {
      return res.status(404).json({
        success: false,
        message: 'Template file not found'
      });
    }
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Error downloading template',
      error: error.message
    });
  }
}

module.exports = {
  uploadBookings,
  previewFile,
  testDatabaseConnection,
  getProcedureInfo,
  downloadTemplate
};
