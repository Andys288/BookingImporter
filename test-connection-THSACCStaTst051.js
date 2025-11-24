/**
 * Quick Connection Test for THSACCStaTst051
 * 
 * This script tests the database connection to your SQL Server
 * Server: THSACCStaTst051
 * Database: Accounts
 * Authentication: Windows Authentication
 */

const sql = require('mssql');

// Configuration for THSACCStaTst051
// mssql@12.x requires both server property AND connectionString when using ODBC
const config = {
  server: 'THSACCStaTst051',  // Required by mssql@12.x even with connectionString
  connectionString: 'Driver={ODBC Driver 18 for SQL Server};Server=THSACCStaTst051;Database=Accounts;Trusted_Connection=Yes;TrustServerCertificate=yes;',
  options: {
    trustedConnection: true,
    enableArithAbort: true,
    trustServerCertificate: true
  }
};

async function testConnection() {
  console.log('═══════════════════════════════════════════════════════════════');
  console.log('🔌 SQL Server Connection Test');
  console.log('═══════════════════════════════════════════════════════════════');
  console.log('');
  console.log('📋 Connection Details:');
  console.log('   Server:         THSACCStaTst051');
  console.log('   Database:       Accounts');
  console.log('   Driver:         ODBC Driver 18 for SQL Server');
  console.log('   Authentication: Windows Authentication (Trusted_Connection)');
  console.log('   Windows User:   ' + (process.env.USERNAME || process.env.USER || 'Unknown'));
  console.log('   Domain:         ' + (process.env.USERDOMAIN || 'Unknown'));
  console.log('');
  console.log('───────────────────────────────────────────────────────────────');
  console.log('');

  let pool = null;

  try {
    // Step 1: Connect
    console.log('⏳ Step 1: Connecting to SQL Server...');
    pool = await sql.connect(config);
    console.log('✅ Connection successful!');
    console.log('');

    // Step 2: Test Query
    console.log('⏳ Step 2: Running test query...');
    const result = await pool.request().query('SELECT @@VERSION as Version, DB_NAME() as DatabaseName, SYSTEM_USER as SystemUser, CURRENT_USER as CurrentUser');
    console.log('✅ Query successful!');
    console.log('');

    // Step 3: Display Results
    console.log('───────────────────────────────────────────────────────────────');
    console.log('📊 Connection Information:');
    console.log('───────────────────────────────────────────────────────────────');
    if (result.recordset && result.recordset.length > 0) {
      const info = result.recordset[0];
      console.log('');
      console.log('🗄️  Database:     ' + info.DatabaseName);
      console.log('👤 System User:   ' + info.SystemUser);
      console.log('👤 Current User:  ' + info.CurrentUser);
      console.log('');
      console.log('📦 SQL Server Version:');
      console.log('   ' + info.Version.split('\n')[0]);
      console.log('');
    }

    // Step 4: Test Table Access
    console.log('───────────────────────────────────────────────────────────────');
    console.log('⏳ Step 4: Testing table access...');
    console.log('───────────────────────────────────────────────────────────────');
    console.log('');

    try {
      const tables = await pool.request().query(`
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE' 
        ORDER BY TABLE_NAME
      `);
      
      console.log('✅ Table access successful!');
      console.log('');
      console.log(`📋 Found ${tables.recordset.length} tables in the Accounts database:`);
      console.log('');
      
      tables.recordset.forEach((table, index) => {
        console.log(`   ${(index + 1).toString().padStart(2, ' ')}. ${table.TABLE_NAME}`);
      });
      console.log('');
    } catch (tableError) {
      console.log('⚠️  Could not list tables (may need permissions)');
      console.log('   Error: ' + tableError.message);
      console.log('');
    }

    // Step 5: Test Stored Procedures
    console.log('───────────────────────────────────────────────────────────────');
    console.log('⏳ Step 5: Checking stored procedures...');
    console.log('───────────────────────────────────────────────────────────────');
    console.log('');

    try {
      const procs = await pool.request().query(`
        SELECT ROUTINE_NAME 
        FROM INFORMATION_SCHEMA.ROUTINES 
        WHERE ROUTINE_TYPE = 'PROCEDURE'
        ORDER BY ROUTINE_NAME
      `);
      
      console.log('✅ Stored procedure access successful!');
      console.log('');
      console.log(`📋 Found ${procs.recordset.length} stored procedures:`);
      console.log('');
      
      procs.recordset.slice(0, 10).forEach((proc, index) => {
        console.log(`   ${(index + 1).toString().padStart(2, ' ')}. ${proc.ROUTINE_NAME}`);
      });
      
      if (procs.recordset.length > 10) {
        console.log(`   ... and ${procs.recordset.length - 10} more`);
      }
      console.log('');
    } catch (procError) {
      console.log('⚠️  Could not list stored procedures (may need permissions)');
      console.log('   Error: ' + procError.message);
      console.log('');
    }

    // Success Summary
    console.log('═══════════════════════════════════════════════════════════════');
    console.log('✅ CONNECTION TEST SUCCESSFUL!');
    console.log('═══════════════════════════════════════════════════════════════');
    console.log('');
    console.log('🎉 Your connection to THSACCStaTst051 is working perfectly!');
    console.log('');
    console.log('Next steps:');
    console.log('   1. Start your backend server: npm run server');
    console.log('   2. Start your frontend: npm run dev');
    console.log('   3. Open http://localhost:5173 in your browser');
    console.log('');
    console.log('═══════════════════════════════════════════════════════════════');

  } catch (error) {
    console.log('');
    console.log('═══════════════════════════════════════════════════════════════');
    console.log('❌ CONNECTION TEST FAILED');
    console.log('═══════════════════════════════════════════════════════════════');
    console.log('');
    console.log('Error Details:');
    console.log('   Message: ' + error.message);
    console.log('');
    
    if (error.code) {
      console.log('   Error Code: ' + error.code);
      console.log('');
    }

    console.log('───────────────────────────────────────────────────────────────');
    console.log('💡 Troubleshooting Steps:');
    console.log('───────────────────────────────────────────────────────────────');
    console.log('');

    if (error.message.includes('msnodesqlv8')) {
      console.log('❌ msnodesqlv8 driver issue detected');
      console.log('');
      console.log('   Solution:');
      console.log('   1. Install the driver:');
      console.log('      npm install msnodesqlv8');
      console.log('');
      console.log('   2. Install SQL Server Native Client:');
      console.log('      Download from: https://www.microsoft.com/en-us/download/details.aspx?id=50402');
      console.log('');
    } else if (error.message.includes('Login failed') || error.message.includes('Cannot open database')) {
      console.log('❌ Authentication or database access issue');
      console.log('');
      console.log('   Your Windows user needs access to the database.');
      console.log('');
      console.log('   Ask your DBA to run this SQL:');
      console.log('   ─────────────────────────────────────────────────────');
      console.log('   USE [Accounts];');
      console.log('   GO');
      console.log('   CREATE USER [' + (process.env.USERDOMAIN || 'DOMAIN') + '\\' + (process.env.USERNAME || 'YourUsername') + '] FOR LOGIN [' + (process.env.USERDOMAIN || 'DOMAIN') + '\\' + (process.env.USERNAME || 'YourUsername') + '];');
      console.log('   GO');
      console.log('   ALTER ROLE db_datareader ADD MEMBER [' + (process.env.USERDOMAIN || 'DOMAIN') + '\\' + (process.env.USERNAME || 'YourUsername') + '];');
      console.log('   ALTER ROLE db_datawriter ADD MEMBER [' + (process.env.USERDOMAIN || 'DOMAIN') + '\\' + (process.env.USERNAME || 'YourUsername') + '];');
      console.log('   GO');
      console.log('   ─────────────────────────────────────────────────');
      console.log('');
    } else if (error.message.includes('timeout') || error.message.includes('ETIMEDOUT')) {
      console.log('❌ Connection timeout - server may be unreachable');
      console.log('');
      console.log('   Check:');
      console.log('   1. Is SQL Server running?');
      console.log('   2. Can you ping THSACCStaTst051?');
      console.log('      ping THSACCStaTst051');
      console.log('');
      console.log('   3. Test with sqlcmd:');
      console.log('      sqlcmd -S THSACCStaTst051 -E -Q "SELECT @@VERSION"');
      console.log('');
    } else {
      console.log('❌ General connection error');
      console.log('');
      console.log('   Try these steps:');
      console.log('   1. Verify server name: THSACCStaTst051');
      console.log('   2. Check SQL Server is running');
      console.log('   3. Test with sqlcmd:');
      console.log('      sqlcmd -S THSACCStaTst051 -E -Q "SELECT @@VERSION"');
      console.log('');
      console.log('   4. Check firewall allows port 1433');
      console.log('   5. Verify Windows Authentication is enabled on SQL Server');
      console.log('');
    }

    console.log('───────────────────────────────────────────────────────────────');
    console.log('');
    console.log('Full Error:');
    console.error(error);
    console.log('');
    console.log('═══════════════════════════════════════════════════════════════');

  } finally {
    // Close connection
    if (pool) {
      try {
        await pool.close();
        console.log('');
        console.log('🔌 Connection closed.');
      } catch (closeError) {
        console.error('Error closing connection:', closeError.message);
      }
    }
  }
}

// Run the test
console.log('');
testConnection().catch(err => {
  console.error('Unexpected error:', err);
  process.exit(1);
});
