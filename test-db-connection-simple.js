/**
 * Simple Database Connection Test
 * This will show us the exact error you're experiencing
 */

require('dotenv').config();
const sql = require('mssql');

console.log('='.repeat(70));
console.log('DATABASE CONNECTION TEST');
console.log('='.repeat(70));
console.log();

// Show environment variables
console.log('Environment Variables:');
console.log('  USE_WINDOWS_AUTH:', process.env.USE_WINDOWS_AUTH);
console.log('  DB_SERVER:', process.env.DB_SERVER);
console.log('  DB_DATABASE:', process.env.DB_DATABASE);
console.log('  DB_PORT:', process.env.DB_PORT);
console.log('  DB_USER:', process.env.DB_USER || '(not set)');
console.log('  DB_PASSWORD:', process.env.DB_PASSWORD ? '***' : '(not set)');
console.log('  ODBC_DRIVER:', process.env.ODBC_DRIVER);
console.log('  DB_ENCRYPT:', process.env.DB_ENCRYPT);
console.log('  DB_TRUST_SERVER_CERTIFICATE:', process.env.DB_TRUST_SERVER_CERTIFICATE);
console.log();

const useWindowsAuth = process.env.USE_WINDOWS_AUTH === 'true';

console.log('Authentication Mode:', useWindowsAuth ? 'Windows Authentication' : 'SQL Authentication');
console.log();

let config;

if (useWindowsAuth) {
  console.log('Building Windows Authentication Config...');
  
  const serverName = process.env.DB_SERVER.split(':')[0];
  const port = process.env.DB_PORT || '1433';
  const driver = process.env.ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';
  
  const connectionString = `Server=${serverName},${port};Database=${process.env.DB_DATABASE};Trusted_Connection=Yes;Driver={${driver}};TrustServerCertificate=yes;`;
  
  console.log('Connection String:', connectionString);
  console.log();
  
  config = {
    driver: 'msnodesqlv8',
    connectionString: connectionString,
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000
    }
  };
} else {
  console.log('Building SQL Authentication Config...');
  
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

console.log('Final Config Object:');
console.log(JSON.stringify(config, null, 2));
console.log();

console.log('Attempting connection...');
console.log();

sql.connect(config)
  .then(async pool => {
    console.log('✅ CONNECTION SUCCESSFUL!');
    console.log();
    
    // Test query
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        DB_NAME() AS CurrentDatabase,
        @@VERSION AS SQLVersion
    `);
    
    console.log('Connection Details:');
    console.log('  User:', result.recordset[0].CurrentUser);
    console.log('  Database:', result.recordset[0].CurrentDatabase);
    console.log('  SQL Version:', result.recordset[0].SQLVersion.split('\n')[0]);
    console.log();
    
    await pool.close();
    console.log('✅ Test completed successfully!');
    process.exit(0);
  })
  .catch(error => {
    console.log('❌ CONNECTION FAILED!');
    console.log();
    console.log('Error Name:', error.name);
    console.log('Error Message:', error.message);
    console.log();
    console.log('Full Error Object:');
    console.log(error);
    console.log();
    
    // Provide specific guidance
    if (error.message.includes('config.server')) {
      console.log('🔍 DIAGNOSIS: The mssql library is expecting a "server" property');
      console.log('   but you\'re using Windows Authentication with a connection string.');
      console.log();
      console.log('💡 SOLUTION: This is a configuration format issue.');
      console.log('   The msnodesqlv8 driver requires a connection string format,');
      console.log('   not individual server/database properties.');
    }
    
    process.exit(1);
  });
