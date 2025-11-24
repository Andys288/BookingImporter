/**
 * Quick test to verify the database connection fix
 */

require('dotenv').config();
const { getConnection, closeConnection } = require('./server/config/database');

console.log('Testing database connection with fixed configuration...\n');

getConnection()
  .then(async (pool) => {
    console.log('\n✅ SUCCESS! Connection established.\n');
    
    // Run a test query
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        DB_NAME() AS CurrentDatabase,
        @@SERVERNAME AS ServerName,
        GETDATE() AS ServerTime
    `);
    
    console.log('Connection Details:');
    console.log('  Connected as:', result.recordset[0].CurrentUser);
    console.log('  Database:', result.recordset[0].CurrentDatabase);
    console.log('  Server:', result.recordset[0].ServerName);
    console.log('  Server Time:', result.recordset[0].ServerTime);
    console.log('\n✅ All tests passed! Your connection is working.\n');
    
    await closeConnection();
    process.exit(0);
  })
  .catch((error) => {
    console.log('\n❌ Connection failed with error:\n');
    console.log(error.message);
    console.log('\nFull error:', error);
    process.exit(1);
  });
