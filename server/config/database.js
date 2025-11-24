const sql = require('mssql');
require('dotenv').config();

/**
 * Database Configuration
 * 
 * Supports both Windows Authentication (msnodesqlv8) and SQL Authentication (tedious)
 * Uses SQL Authentication by default for cross-platform compatibility
 */

// Determine which driver to use based on environment
const useWindowsAuth = process.env.USE_WINDOWS_AUTH === 'true';

let config;

if (useWindowsAuth) {
  // Windows Authentication using msnodesqlv8 (Windows only)
  // Extract server name without port for ODBC connection string
  const serverName = process.env.DB_SERVER.split(':')[0];
  const port = process.env.DB_PORT || '1433';
  
  // Try ODBC Driver 18 first, fallback to 17 if needed
  const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';
  
  // Build connection string for msnodesqlv8
  // CRITICAL: mssql@12.x requires BOTH server property AND connectionString when using ODBC
  const connectionString = `Driver={${driver}};Server=${serverName};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;TrustServerCertificate=yes;`;
  
  config = {
    server: serverName,  // Required by mssql@12.x even with connectionString
    connectionString: connectionString,
    options: {
      trustedConnection: true,
      enableArithAbort: true,
      trustServerCertificate: true
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000
    }
  };
} else {
  // SQL Authentication using tedious driver (cross-platform)
  config = {
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT || '1433'),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    options: {
      encrypt: process.env.DB_ENCRYPT === 'true',
      trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
      enableArithAbort: true
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000
    }
  };
}

let pool = null;

/**
 * Get database connection using Windows Integrated Security
 * 
 * @returns {Promise<Object>} - SQL connection pool
 */
async function getConnection() {
  try {
    if (pool) {
      return pool;
    }
    
    console.log('🔌 Attempting database connection...');
    
    if (useWindowsAuth) {
      const serverName = process.env.DB_SERVER.split(':')[0];
      const port = process.env.DB_PORT || '1433';
      const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';
      
      console.log(`   Driver: msnodesqlv8 (Windows Native ODBC)`);
      console.log(`   ODBC Driver: ${driver}`);
      console.log(`   Server: ${serverName},${port}`);
      console.log(`   Database: ${process.env.DB_DATABASE}`);
      console.log(`   Authentication: Windows Integrated Security (Trusted_Connection=Yes)`);
      console.log(`   User: (current Windows user - automatic)`);
      console.log(`   Connection String: Server=${serverName},${port};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={${driver}};TrustServerCertificate=yes;`);
    } else {
      console.log(`   Driver: tedious (cross-platform)`);
      console.log(`   Server: ${process.env.DB_SERVER}:${process.env.DB_PORT || 1433}`);
      console.log(`   Database: ${process.env.DB_DATABASE}`);
      console.log(`   Authentication: SQL Authentication`);
      console.log(`   User: ${process.env.DB_USER || '(not set)'}`);
      console.log(`   Encrypt: ${process.env.DB_ENCRYPT}`);
      console.log(`   Trust Certificate: ${process.env.DB_TRUST_SERVER_CERTIFICATE}`);
    }
    
    pool = await sql.connect(config);
    
    console.log('✅ Database connected successfully!');
    if (useWindowsAuth) {
      console.log(`   Connected as current Windows user`);
    } else {
      console.log(`   Connected as: ${process.env.DB_USER}`);
    }
    return pool;
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
    console.error('');
    console.error('💡 Troubleshooting tips:');
    
    if (useWindowsAuth) {
      console.error('   1. Make sure msnodesqlv8 is installed: npm install msnodesqlv8');
      console.error('   2. Check SQL Server is running: services.msc');
      console.error('   3. Verify server name: ' + process.env.DB_SERVER);
      console.error('   4. Test connection: sqlcmd -S ' + process.env.DB_SERVER + ' -E');
      console.error('   5. Ensure your Windows user has database access');
      console.error('   6. Check SQL Server Native Client is installed');
      console.error('      Download from: https://www.microsoft.com/en-us/download/details.aspx?id=50402');
    } else {
      console.error('   1. Check SQL Server is running and accessible');
      console.error('   2. Verify server name: ' + process.env.DB_SERVER);
      console.error('   3. Verify database name: ' + process.env.DB_DATABASE);
      console.error('   4. Check username and password in .env file');
      console.error('   5. Ensure SQL Server allows SQL Authentication');
      console.error('   6. Check firewall allows connection on port ' + (process.env.DB_PORT || 1433));
      console.error('   7. Verify user has access to the database');
    }
    
    console.error('');
    console.error('Full error:', error);
    throw error;
  }
}

/**
 * Close database connection
 */
async function closeConnection() {
  try {
    if (pool) {
      await pool.close();
      pool = null;
      console.log('Database connection closed');
    }
  } catch (error) {
    console.error('Error closing database connection:', error);
  }
}

module.exports = {
  sql,
  getConnection,
  closeConnection
};
