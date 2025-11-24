const express = require('express');
const router = express.Router();
const upload = require('../middleware/upload');
const {
  uploadBookings,
  previewFile,
  testDatabaseConnection,
  getProcedureInfo,
  downloadTemplate
} = require('../controllers/bookingController');

// Upload and process bookings
router.post('/upload', upload.single('file'), uploadBookings);

// Preview file without processing
router.post('/preview', upload.single('file'), previewFile);

// Test database connection
router.get('/test-connection', testDatabaseConnection);

// Get stored procedure information
router.get('/procedure-info', getProcedureInfo);

// Download sample template
router.get('/template/:type', downloadTemplate);
router.get('/template', downloadTemplate);

module.exports = router;
