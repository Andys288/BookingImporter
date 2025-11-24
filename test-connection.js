/**
 * SQL Server 2022 Windows Authentication Connection Test
 * 
 * This script tests your database connection and provides detailed diagnostics
 * Run: node test-connection.js
 */

require('dotenv').config();
const { execSync } = require('child_process');
const os = require('os');

// Color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function section(title) {
  console.log('\n' + '='.repeat(70));
  log(title, 'cyan');
  console.log('='.repeat(70) + '\n');
}

async function checkPrerequisites() {
  section('1. Checking Prerequisites');
  
  // Check Node.js version
  const nodeVersion = process.version;
  log(`✓ Node.js Version: ${nodeVersion}`, 'green');
  
  // Check Windows user
  const username = process.env.USERNAME || process.env.USER;
  const domain = process.env.USERDOMAIN || os.hostname();
  log(`✓ Windows User: ${domain}\\${username}`, 'green');
  
  // Check environment variables
  const requiredVars = ['DB_SERVER', 'DB_DATABASE'];
  let missingVars = [];
  
  for (const varName of requiredVars) {
    if (process.env[varName]) {
      log(`✓ ${varName}: ${process.env[varName]}`, 'green');
    } else {
      log(`✗ ${varName}: NOT SET`, 'red');
      missingVars.push(varName);
    }
  }
  
  if (missingVars.length > 0) {
    log('\n⚠️  Missing required environment variables!', 'red');
    log('Create a .env file with:', 'yellow');
    missingVars.forEach(v => log(`  ${v}=your_value`, 'yellow'));
    return false;
  }
  
  return true;
}

async function checkODBCDrivers() {
  section('2. Checking ODBC Drivers');
  
  try {
    const drivers = execSync(
      'powershell "Get-OdbcDriver | Select-Object -ExpandProperty Name"',
      { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'ignore'] }
    );
    
    const driverList = drivers.split('\n').filter(d => d.trim());
    
    log('Available ODBC Drivers:', 'blue');
    driverList.forEach(driver => {
      if (driver.includes('SQL Server')) {
        log(`  ✓ ${driver}`, 'green');
      } else {
        log(`    ${driver}`, 'reset');
      }
    });
    
    const hasDriver18 = drivers.includes('ODBC Driver 18 for SQL Server');
    const hasDriver17 = drivers.includes('ODBC Driver 17 for SQL Server');
    const hasNativeClient = drivers.includes('SQL Server Native Client');
    
    console.log('');
    if (hasDriver18) {
      log('✅ ODBC Driver 18 found - Perfect for SQL Server 2022!', 'green');
      return 'ODBC Driver 18 for SQL Server';
    } else if (hasDriver17) {
      log('✅ ODBC Driver 17 found - Compatible with SQL Server 2022', 'green');
      log('   Consider upgrading to Driver 18 for best results', 'yellow');
      return 'ODBC Driver 17 for SQL Server';
    } else if (hasNativeClient) {
      log('⚠️  Only SQL Server Native Client found (deprecated)', 'yellow');
      log('   Install ODBC Driver 18: https://go.microsoft.com/fwlink/?linkid=2249004', 'yellow');
      return 'SQL Server Native Client 11.0';
    } else {
      log('❌ No SQL Server ODBC driver found!', 'red');
      log('   Install ODBC Driver 18: https://go.microsoft.com/fwlink/?linkid=2249004', 'red');
      return null;
    }
  } catch (error) {
    log('⚠️  Could not check ODBC drivers (PowerShell error)', 'yellow');
    log('   Assuming ODBC Driver 18 is installed', 'yellow');
    return 'ODBC Driver 18 for SQL Server';
  }
}

async function checkSQLServerService() {
  section('3. Checking SQL Server Service');
  
  try {
    const services = execSync(
      'powershell "Get-Service -Name MSSQL* | Select-Object Name, Status, DisplayName | Format-Table -AutoSize"',
      { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'ignore'] }
    );
    
    console.log(services);
    
    if (services.includes('Running')) {
      log('✅ SQL Server service is running', 'green');
      return true;
    } else {
      log('❌ SQL Server service is not running', 'red');
      log('   Start it with: Start-Service MSSQLSERVER', 'yellow');
      return false;
    }
  } catch (error) {
    log('⚠️  Could not check SQL Server service status', 'yellow');
    return true; // Assume it's running
  }
}

async function testNetworkConnectivity() {
  section('4. Testing Network Connectivity');
  
  const server = process.env.DB_SERVER || 'localhost';
  const port = process.env.DB_PORT || '1433';
  
  try {
    const result = execSync(
      `powershell "Test-NetConnection -ComputerName ${server} -Port ${port} -InformationLevel Quiet"`,
      { encoding: 'utf-8', stdio: ['pipe', 'pipe', 'ignore'] }
    );
    
    if (result.trim() === 'True') {
      log(`✅ Port ${port} is accessible on ${server}`, 'green');
      return true;
    } else {
      log(`❌ Port ${port} is NOT accessible on ${server}`, 'red');
      log('   Check firewall settings and SQL Server TCP/IP configuration', 'yellow');
      return false;
    }
  } catch (error) {
    log('⚠️  Could not test network connectivity', 'yellow');
    return true; // Assume it's accessible
  }
}

async function testSQLCmdConnection() {
  section('5. Testing with sqlcmd');
  
  const server = process.env.DB_SERVER || 'localhost';
  
  try {
    const result = execSync(
      `sqlcmd -S ${server} -E -Q "SELECT SUSER_NAME() AS CurrentUser, @@VERSION AS SQLVersion" -h -1`,
      { encoding: 'utf-8', timeout: 10000 }
    );
    
    log('✅ sqlcmd connection successful!', 'green');
    console.log(result);
    return true;
  } catch (error) {
    log('❌ sqlcmd connection failed!', 'red');
    log('   Error: ' + error.message, 'red');
    log('\n   This means Windows Authentication is not working at the OS level.', 'yellow');
    log('   Fix this before trying Node.js connection.', 'yellow');
    return false;
  }
}

async function testNodeJSConnection(driver) {
  section('6. Testing Node.js Connection');
  
  try {
    // Check if msnodesqlv8 is installed
    try {
      require.resolve('msnodesqlv8');
      log('✓ msnodesqlv8 package is installed', 'green');
    } catch {
      log('✗ msnodesqlv8 package is NOT installed', 'red');
      log('  Install with: npm install msnodesqlv8', 'yellow');
      return false;
    }
    
    const sql = require('mssql');
    
    const connectionString = 
      `Server=${process.env.DB_SERVER},${process.env.DB_PORT || 1433};` +
      `Database=${process.env.DB_DATABASE};` +
      `Trusted_Connection=Yes;` +
      `Driver={${driver}};` +
      `Encrypt=${process.env.DB_ENCRYPT === 'true' ? 'yes' : 'no'};` +
      `TrustServerCertificate=${process.env.DB_TRUST_SERVER_CERTIFICATE === 'true' ? 'yes' : 'no'};`;
    
    const config = {
      driver: 'msnodesqlv8',
      connectionString: connectionString,
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
    
    log('Attempting connection with:', 'blue');
    log(`  Server: ${process.env.DB_SERVER}:${process.env.DB_PORT || 1433}`, 'blue');
    log(`  Database: ${process.env.DB_DATABASE}`, 'blue');
    log(`  Driver: ${driver}`, 'blue');
    log(`  Authentication: Windows Integrated Security`, 'blue');
    console.log('');
    
    const pool = await sql.connect(config);
    
    const result = await pool.request().query(`
      SELECT 
        SUSER_NAME() AS CurrentUser,
        DB_NAME() AS CurrentDatabase,
        @@VERSION AS SQLVersion,
        GETDATE() AS ServerTime,
        @@SERVERNAME AS ServerName
    `);
    
    await pool.close();
    
    log('✅ Node.js connection SUCCESSFUL!', 'green');
    console.log('');
    log('Connection Details:', 'cyan');
    log(`  User: ${result.recordset[0].CurrentUser}`, 'green');
    log(`  Database: ${result.recordset[0].CurrentDatabase}`, 'green');
    log(`  Server: ${result.recordset[0].ServerName}`, 'green');
    log(`  Server Time: ${result.recordset[0].ServerTime}`, 'green');
    log(`  SQL Version: ${result.recordset[0].SQLVersion.split('\n')[0]}`, 'green');
    
    return true;
    
  } catch (error) {
    log('❌ Node.js connection FAILED!', 'red');
    console.log('');
    log('Error Details:', 'red');
    log(`  ${error.message}`, 'red');
    console.log('');
    
    // Provide specific troubleshooting based on error
    if (error.message.includes('Data source name not found')) {
      log('💡 Solution: Install ODBC Driver 18', 'yellow');
      log('   Download: https://go.microsoft.com/fwlink/?linkid=2249004', 'yellow');
    } else if (error.message.includes('Login failed')) {
      log('💡 Solution: Grant database access to your Windows user', 'yellow');
      log('   Run in SSMS:', 'yellow');
      log(`   USE [${process.env.DB_DATABASE}];`, 'yellow');
      log(`   CREATE USER [${process.env.USERDOMAIN}\\${process.env.USERNAME}]`, 'yellow');
      log(`   FOR LOGIN [${process.env.USERDOMAIN}\\${process.env.USERNAME}];`, 'yellow');
      log(`   ALTER ROLE db_owner ADD MEMBER [${process.env.USERDOMAIN}\\${process.env.USERNAME}];`, 'yellow');
    } else if (error.message.includes('certificate')) {
      log('💡 Solution: Trust server certificate for local development', 'yellow');
      log('   Add to .env file:', 'yellow');
      log('   DB_TRUST_SERVER_CERTIFICATE=true', 'yellow');
    } else if (error.message.includes('timeout')) {
      log('💡 Solution: Check SQL Server is running and accessible', 'yellow');
      log('   1. Verify service: Get-Service MSSQLSERVER', 'yellow');
      log('   2. Check firewall: Test-NetConnection -Port 1433', 'yellow');
      log('   3. Enable TCP/IP in SQL Server Configuration Manager', 'yellow');
    }
    
    return false;
  }
}

async function runFullTest() {
  console.clear();
  log('╔═══════════════════════════════════════════════════════════════════╗', 'cyan');
  log('║  SQL Server 2022 Windows Authentication Connection Test          ║', 'cyan');
  log('╚═══════════════════════════════════════════════════════════════════╝', 'cyan');
  
  // Step 1: Prerequisites
  const prereqsOk = await checkPrerequisites();
  if (!prereqsOk) {
    log('\n❌ Prerequisites check failed. Fix the issues above and try again.', 'red');
    process.exit(1);
  }
  
  // Step 2: ODBC Drivers
  const driver = await checkODBCDrivers();
  if (!driver) {
    log('\n❌ No ODBC driver found. Install ODBC Driver 18 and try again.', 'red');
    process.exit(1);
  }
  
  // Step 3: SQL Server Service
  await checkSQLServerService();
  
  // Step 4: Network Connectivity
  await testNetworkConnectivity();
  
  // Step 5: sqlcmd Test
  const sqlcmdOk = await testSQLCmdConnection();
  if (!sqlcmdOk) {
    log('\n❌ sqlcmd test failed. Fix Windows Authentication at OS level first.', 'red');
    process.exit(1);
  }
  
  // Step 6: Node.js Connection
  const nodejsOk = await testNodeJSConnection(driver);
  
  // Final Summary
  section('Test Summary');
  
  if (nodejsOk) {
    log('╔═══════════════════════════════════════════════════════════════════╗', 'green');
    log('║                  ✅ ALL TESTS PASSED!                             ║', 'green');
    log('╚═══════════════════════════════════════════════════════════════════╝', 'green');
    log('\n🎉 Your Node.js application can now connect to SQL Server 2022!', 'green');
    log('\nNext steps:', 'cyan');
    log('  1. Use the database-windows-auth.js configuration in your app', 'cyan');
    log('  2. Start your server: npm run server', 'cyan');
    log('  3. Test your application endpoints', 'cyan');
    process.exit(0);
  } else {
    log('╔═══════════════════════════════════════════════════════════════════╗', 'red');
    log('║                  ❌ TESTS FAILED                                  ║', 'red');
    log('╚═══════════════════════════════════════════════════════════════════╝', 'red');
    log('\n📖 Review the error messages above and follow the suggested solutions.', 'yellow');
    log('📚 For detailed help, see: SQL_SERVER_2022_WINDOWS_AUTH_GUIDE.md', 'yellow');
    process.exit(1);
  }
}

// Run the test
runFullTest().catch(error => {
  log('\n❌ Unexpected error during testing:', 'red');
  console.error(error);
  process.exit(1);
});
