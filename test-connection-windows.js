/**
 * Test SQL Server Connection with Windows Authentication
 * 
 * This script tests the database connection using the same configuration
 * as the main application. Run this to verify your setup before starting
 * the full application.
 * 
 * Usage: node test-connection-windows.js
 */

const sql = require('mssql');
require('dotenv').config();

console.log('╔══════════════════════════════════════════════════════════════════╗');
console.log('║     SQL Server Connection Test - Windows Authentication         ║');
console.log('╚══════════════════════════════════════════════════════════════════╝');
console.log('');

// Check if Windows Auth is enabled
const useWindowsAuth = process.env.USE_WINDOWS_AUTH === 'true';

if (!useWindowsAuth) {
  console.log('⚠️  USE_WINDOWS_AUTH is set to false in .env file');
  console.log('   This test is for Windows Authentication only.');
  console.log('   To test SQL Authentication, use: node test-connection.js');
  console.log('');
  process.exit(1);
}

// Extract server name without port for ODBC connection string
const serverName = process.env.DB_SERVER.split(':')[0];
const port = process.env.DB_PORT || '1433';
const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';

// Build connection string for msnodesqlv8
const connectionString = `Server=${serverName},${port};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={${driver}};TrustServerCertificate=yes;`;

const config = {
  driver: 'msnodesqlv8',
  connectionString: connectionString,
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

console.log('📋 Configuration Details:');
console.log('─────────────────────────────────────────────────────────────────');
console.log(`   Driver:          msnodesqlv8`);
console.log(`   ODBC Driver:     ${driver}`);
console.log(`   Server:          ${serverName}`);
console.log(`   Port:            ${port}`);
console.log(`   Database:        ${process.env.DB_DATABASE}`);
console.log(`   Authentication:  Windows Integrated Security`);
console.log(`   User:            (current Windows user)`);
console.log('');
console.log('   Connection String:');
console.log(`   ${connectionString}`);
console.log('─────────────────────────────────────────────────────────────────');
console.log('');

async function testConnection() {
  let pool = null;
  
  try {
    console.log('🔌 Attempting to connect...');
    console.log('');
    
    // Attempt connection
    pool = await sql.connect(config);
    
    console.log('✅ Connection successful!');
    console.log('');
    
    // Test query
    console.log('📊 Running test query...');
    const result = await pool.request().query('SELECT @@VERSION as Version, DB_NAME() as DatabaseName, SYSTEM_USER as SystemUser, USER_NAME() as UserName');
    
    console.log('');
    console.log('╔══════════════════════════════════════════════════════════════════╗');
    console.log('║                     Connection Details                           ║');
    console.log('╚══════════════════════════════════════════════════════════════════╝');
    console.log('');
    console.log('Database Name:  ', result.recordset[0].DatabaseName);
    console.log('System User:    ', result.recordset[0].SystemUser);
    console.log('Database User:  ', result.recordset[0].UserName);
    console.log('');
    console.log('SQL Server Version:');
    console.log(result.recordset[0].Version.split('\n')[0]);
    console.log('');
    
    // Test stored procedure existence
    console.log('🔍 Checking for stored procedure...');
    const spCheck = await pool.request().query(`
      SELECT COUNT(*) as SPExists 
      FROM sys.objects 
      WHERE type = 'P' 
      AND name = 'TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS'
    `);
    
    if (spCheck.recordset[0].SPExists > 0) {
      console.log('✅ Stored procedure TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS found!');
    } else {
      console.log('⚠️  Stored procedure TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS NOT found!');
      console.log('   You may need to create it before importing data.');
    }
    console.log('');
    
    console.log('╔══════════════════════════════════════════════════════════════════╗');
    console.log('║                    ✅ ALL TESTS PASSED! ✅                       ║');
    console.log('╚══════════════════════════════════════════════════════════════════╝');
    console.log('');
    console.log('Your database connection is working correctly!');
    console.log('You can now start the application with: npm run server');
    console.log('');
    
  } catch (error) {
    console.log('❌ Connection failed!');
    console.log('');
    console.log('Error Message:');
    console.log('  ', error.message);
    console.log('');
    
    if (error.code) {
      console.log('Error Code:', error.code);
      console.log('');
    }
    
    console.log('╔══════════════════════════════════════════════════════════════════╗');
    console.log('║                    Troubleshooting Tips                          ║');
    console.log('╚══════════════════════════════════════════════════════════════════╝');
    console.log('');
    
    if (error.message.includes('config.server')) {
      console.log('❌ Configuration Error:');
      console.log('   The server configuration is not being set correctly.');
      console.log('');
      console.log('   Solutions:');
      console.log('   1. Check your .env file exists and has correct values');
      console.log('   2. Verify DB_SERVER is set (without port in the value)');
      console.log('   3. Verify DB_DATABASE is set');
      console.log('   4. Make sure USE_WINDOWS_AUTH=true');
      console.log('');
    } else if (error.message.includes('msnodesqlv8')) {
      console.log('❌ Driver Error:');
      console.log('   The msnodesqlv8 package is not installed or not working.');
      console.log('');
      console.log('   Solutions:');
      console.log('   1. Install the package: npm install msnodesqlv8');
      console.log('   2. Make sure you have Visual C++ Redistributable installed');
      console.log('   3. Check that ODBC Driver 18 for SQL Server is installed');
      console.log('');
    } else if (error.message.includes('Login failed') || error.message.includes('Cannot open database')) {
      console.log('❌ Authentication/Database Error:');
      console.log('');
      console.log('   Solutions:');
      console.log('   1. Verify your Windows user has access to the database');
      console.log('   2. Check the database name is correct');
      console.log('   3. Test with sqlcmd: sqlcmd -S ' + serverName + ',' + port + ' -E -d ' + process.env.DB_DATABASE);
      console.log('   4. Grant access: USE [' + process.env.DB_DATABASE + ']; CREATE USER [DOMAIN\\User] FOR LOGIN [DOMAIN\\User];');
      console.log('');
    } else if (error.message.includes('ODBC Driver')) {
      console.log('❌ ODBC Driver Error:');
      console.log('');
      console.log('   Solutions:');
      console.log('   1. Install ODBC Driver 18 for SQL Server');
      console.log('      Download: https://go.microsoft.com/fwlink/?linkid=2249004');
      console.log('   2. Or try ODBC Driver 17: Set ODBC_DRIVER=ODBC Driver 17 for SQL Server in .env');
      console.log('   3. Or try older driver: Set ODBC_DRIVER=SQL Server in .env');
      console.log('');
    } else if (error.message.includes('timeout') || error.message.includes('ETIMEDOUT')) {
      console.log('❌ Connection Timeout:');
      console.log('');
      console.log('   Solutions:');
      console.log('   1. Check SQL Server is running: services.msc');
      console.log('   2. Verify server name: ' + serverName);
      console.log('   3. Check firewall allows connection on port ' + port);
      console.log('   4. Verify SQL Server is configured to allow remote connections');
      console.log('   5. Test with: sqlcmd -S ' + serverName + ',' + port + ' -E');
      console.log('');
    } else {
      console.log('General troubleshooting steps:');
      console.log('');
      console.log('   1. Verify SQL Server is running:');
      console.log('      - Open services.msc');
      console.log('      - Check "SQL Server (MSSQLSERVER)" is running');
      console.log('');
      console.log('   2. Test with sqlcmd:');
      console.log('      sqlcmd -S ' + serverName + ',' + port + ' -E -d ' + process.env.DB_DATABASE);
      console.log('');
      console.log('   3. Check your .env file:');
      console.log('      - USE_WINDOWS_AUTH=true');
      console.log('      - DB_SERVER=' + serverName + ' (without port)');
      console.log('      - DB_PORT=' + port);
      console.log('      - DB_DATABASE=' + process.env.DB_DATABASE);
      console.log('      - ODBC_DRIVER=' + driver);
      console.log('');
      console.log('   4. Verify ODBC drivers installed:');
      console.log('      - Open "ODBC Data Sources (64-bit)"');
      console.log('      - Check "Drivers" tab for "ODBC Driver 18 for SQL Server"');
      console.log('');
    }
    
    console.log('Full Error Details:');
    console.log(error);
    console.log('');
    
    process.exit(1);
  } finally {
    if (pool) {
      await pool.close();
      console.log('Connection closed.');
    }
  }
}

// Run the test
testConnection().catch(err => {
  console.error('Unexpected error:', err);
  process.exit(1);
});
