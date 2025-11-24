const sql = require('mssql');
require('dotenv').config();

/**
 * SQL Server 2022 Windows Authentication Configuration
 * 
 * This configuration uses msnodesqlv8 driver for native Windows Integrated Security.
 * No username or password needed - uses the Windows credentials of the user running the app.
 * 
 * Prerequisites:
 * 1. ODBC Driver 18 for SQL Server installed
 * 2. msnodesqlv8 npm package installed
 * 3. Windows user has SQL Server database access
 * 4. SQL Server TCP/IP protocol enabled
 */

/**
 * Determine the best available ODBC driver
 * Priority: Driver 18 > Driver 17 > Native Client 11.0
 */
function getODBCDriver() {
  // For SQL Server 2022, use ODBC Driver 18
  // This can be made dynamic by querying available drivers
  const preferredDriver = process.env.DB_ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';
  return preferredDriver;
}

/**
 * Build connection string for Windows Authentication
 * Format: Server=server,port;Database=db;Trusted_Connection=Yes;Driver={driver};Encrypt=yes;TrustServerCertificate=yes;
 */
function buildConnectionString() {
  const server = process.env.DB_SERVER || 'localhost';
  const port = process.env.DB_PORT || '1433';
  const database = process.env.DB_DATABASE;
  const driver = getODBCDriver();
  const encrypt = process.env.DB_ENCRYPT === 'true' ? 'yes' : 'no';
  const trustCert = process.env.DB_TRUST_SERVER_CERTIFICATE === 'true' ? 'yes' : 'no';
  
  if (!database) {
    throw new Error('DB_DATABASE environment variable is required');
  }
  
  return `Server=${server},${port};` +
         `Database=${database};` +
         `Trusted_Connection=Yes;` +
         `Driver={${driver}};` +
         `Encrypt=${encrypt};` +
         `TrustServerCertificate=${trustCert};`;
}

// Connection configuration
const config = {
  driver: 'msnodesqlv8',
  connectionString: buildConnectionString(),
  
  options: {
    // SQL Server 2022 specific options
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
    enableArithAbort: true,
    
    // Timeouts (in milliseconds)
    connectionTimeout: 30000,  // 30 seconds
    requestTimeout: 30000      // 30 seconds
  },
  
  pool: {
    max: 10,                      // Maximum number of connections
    min: 0,                       // Minimum number of connections
    idleTimeoutMillis: 30000,     // Close idle connections after 30 seconds
    acquireTimeoutMillis: 30000   // Wait 30 seconds for available connection
  }
};

// Connection pool instance
let pool = null;

/**
 * Get database connection pool
 * Creates a new pool if one doesn't exist or is closed
 * 
 * @returns {Promise<sql.ConnectionPool>} - Active connection pool
 * @throws {Error} - If connection fails
 */
async function getConnection() {
  try {
    // Return existing pool if connected
    if (pool && pool.connected) {
      return pool;
    }
    
    // Log connection attempt
    console.log('🔌 Connecting to SQL Server 2022...');
    console.log(`   Driver: msnodesqlv8 (${getODBCDriver()})`);
    console.log(`   Server: ${process.env.DB_SERVER}:${process.env.DB_PORT || 1433}`);
    console.log(`   Database: ${process.env.DB_DATABASE}`);
    console.log(`   Authentication: Windows Integrated Security`);
    console.log(`   Encryption: ${process.env.DB_ENCRYPT || 'true'}`);
    console.log(`   Trust Certificate: ${process.env.DB_TRUST_SERVER_CERTIFICATE || 'true'}`);
    
    // Create new connection pool
    pool = await sql.connect(config);
    
    // Test the connection and get user info
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        @@VERSION AS SQLVersion
    `);
    
    console.log('✅ Database connected successfully!');
    console.log(`   Connected as: ${result.recordset[0].CurrentUser}`);
    console.log(`   SQL Version: ${result.recordset[0].SQLVersion.split('\n')[0]}`);
    
    return pool;
    
  } catch (error) {
    console.error('❌ Database connection failed!');
    console.error('');
    console.error('Error:', error.message);
    console.error('');
    
    // Provide helpful troubleshooting information
    provideTroubleshootingHelp(error);
    
    throw error;
  }
}

/**
 * Provide context-specific troubleshooting help based on error
 * 
 * @param {Error} error - The connection error
 */
function provideTroubleshootingHelp(error) {
  console.error('🔧 Troubleshooting Steps:');
  console.error('');
  
  const errorMsg = error.message.toLowerCase();
  
  if (errorMsg.includes('data source name not found') || errorMsg.includes('odbc')) {
    console.error('❌ ODBC Driver Issue:');
    console.error('   The required ODBC driver is not installed or not found.');
    console.error('');
    console.error('   Solution:');
    console.error('   1. Install ODBC Driver 18 for SQL Server');
    console.error('      Download: https://go.microsoft.com/fwlink/?linkid=2249004');
    console.error('');
    console.error('   2. Verify installation (PowerShell):');
    console.error('      Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}');
    console.error('');
    console.error('   3. Update .env if using different driver:');
    console.error('      DB_ODBC_DRIVER=ODBC Driver 17 for SQL Server');
  }
  
  if (errorMsg.includes('login failed') || errorMsg.includes('cannot open database')) {
    console.error('❌ Authentication/Permission Issue:');
    console.error('   Your Windows user lacks SQL Server database access.');
    console.error('');
    console.error('   Solution (run in SSMS as administrator):');
    console.error('   ----------------------------------------');
    console.error('   USE master;');
    console.error('   GO');
    console.error('');
    console.error(`   -- Create login for your Windows user`);
    console.error(`   CREATE LOGIN [${process.env.USERDOMAIN || 'DOMAIN'}\\${process.env.USERNAME || 'Username'}] FROM WINDOWS;`);
    console.error('   GO');
    console.error('');
    console.error(`   USE [${process.env.DB_DATABASE}];`);
    console.error('   GO');
    console.error('');
    console.error(`   -- Create database user`);
    console.error(`   CREATE USER [${process.env.USERDOMAIN || 'DOMAIN'}\\${process.env.USERNAME || 'Username'}]`);
    console.error(`   FOR LOGIN [${process.env.USERDOMAIN || 'DOMAIN'}\\${process.env.USERNAME || 'Username'}];`);
    console.error('   GO');
    console.error('');
    console.error(`   -- Grant permissions (adjust role as needed)`);
    console.error(`   ALTER ROLE db_owner ADD MEMBER [${process.env.USERDOMAIN || 'DOMAIN'}\\${process.env.USERNAME || 'Username'}];`);
    console.error('   GO');
  }
  
  if (errorMsg.includes('certificate') || errorMsg.includes('ssl') || errorMsg.includes('encryption')) {
    console.error('❌ SSL/Certificate Issue:');
    console.error('   SQL Server 2022 enforces encryption but certificate validation failed.');
    console.error('');
    console.error('   Solution for local development:');
    console.error('   Add to your .env file:');
    console.error('   DB_TRUST_SERVER_CERTIFICATE=true');
    console.error('');
    console.error('   For production, install a proper SSL certificate on SQL Server.');
  }
  
  if (errorMsg.includes('timeout') || errorMsg.includes('connection') && !errorMsg.includes('login')) {
    console.error('❌ Connection Timeout:');
    console.error('   Cannot reach SQL Server (network/firewall issue).');
    console.error('');
    console.error('   Solution:');
    console.error('   1. Verify SQL Server is running:');
    console.error('      PowerShell: Get-Service MSSQLSERVER');
    console.error('');
    console.error('   2. Check server name in .env:');
    console.error(`      DB_SERVER=${process.env.DB_SERVER || 'localhost'}`);
    console.error('');
    console.error('   3. Test with sqlcmd:');
    console.error(`      sqlcmd -S ${process.env.DB_SERVER || 'localhost'} -E -Q "SELECT @@VERSION"`);
    console.error('');
    console.error('   4. Check firewall allows port 1433:');
    console.error(`      PowerShell: Test-NetConnection -ComputerName ${process.env.DB_SERVER || 'localhost'} -Port 1433`);
    console.error('');
    console.error('   5. Enable TCP/IP in SQL Server Configuration Manager');
  }
  
  if (errorMsg.includes('module') || errorMsg.includes('msnodesqlv8')) {
    console.error('❌ Package Issue:');
    console.error('   The msnodesqlv8 package is not installed or failed to build.');
    console.error('');
    console.error('   Solution:');
    console.error('   1. Install the package:');
    console.error('      npm install msnodesqlv8');
    console.error('');
    console.error('   2. If build fails, install Windows Build Tools:');
    console.error('      npm install --global windows-build-tools');
    console.error('');
    console.error('   3. Then retry:');
    console.error('      npm install msnodesqlv8');
  }
  
  console.error('');
  console.error('📚 For detailed help, see: SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md');
  console.error('🧪 Run diagnostic test: node test-connection.js');
  console.error('');
}

/**
 * Close database connection pool
 * Should be called on application shutdown
 */
async function closeConnection() {
  try {
    if (pool) {
      await pool.close();
      pool = null;
      console.log('✅ Database connection closed');
    }
  } catch (error) {
    console.error('❌ Error closing database connection:', error.message);
  }
}

/**
 * Test database connection
 * Returns connection status and details
 * 
 * @returns {Promise<Object>} - { success: boolean, data?: Object, error?: string }
 */
async function testConnection() {
  try {
    const pool = await getConnection();
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        DB_NAME() AS CurrentDatabase,
        @@VERSION AS SQLVersion,
        @@SERVERNAME AS ServerName,
        GETDATE() AS ServerTime
    `);
    
    return {
      success: true,
      data: result.recordset[0]
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Execute a query with automatic connection handling
 * 
 * @param {string} queryString - SQL query to execute
 * @param {Object} params - Query parameters (optional)
 * @returns {Promise<Object>} - Query result
 */
async function executeQuery(queryString, params = {}) {
  const pool = await getConnection();
  const request = pool.request();
  
  // Add parameters if provided
  for (const [key, value] of Object.entries(params)) {
    request.input(key, value);
  }
  
  return await request.query(queryString);
}

/**
 * Execute a stored procedure with automatic connection handling
 * 
 * @param {string} procedureName - Name of stored procedure
 * @param {Object} params - Procedure parameters
 * @returns {Promise<Object>} - Procedure result
 */
async function executeStoredProcedure(procedureName, params = {}) {
  const pool = await getConnection();
  const request = pool.request();
  
  // Add parameters
  for (const [key, config] of Object.entries(params)) {
    if (config.output) {
      request.output(key, config.type, config.value);
    } else {
      request.input(key, config.type, config.value);
    }
  }
  
  return await request.execute(procedureName);
}

// Graceful shutdown handlers
process.on('SIGINT', async () => {
  console.log('\n🛑 Received SIGINT, closing database connection...');
  await closeConnection();
  process.exit(0);
});

process.on('SIGTERM', async () => {
  console.log('\n🛑 Received SIGTERM, closing database connection...');
  await closeConnection();
  process.exit(0);
});

// Handle uncaught errors
process.on('uncaughtException', async (error) => {
  console.error('💥 Uncaught Exception:', error);
  await closeConnection();
  process.exit(1);
});

process.on('unhandledRejection', async (reason, promise) => {
  console.error('💥 Unhandled Rejection at:', promise, 'reason:', reason);
  await closeConnection();
  process.exit(1);
});

// Export functions and sql object
module.exports = {
  sql,
  getConnection,
  closeConnection,
  testConnection,
  executeQuery,
  executeStoredProcedure
};
