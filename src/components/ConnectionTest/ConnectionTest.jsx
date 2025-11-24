import { useState } from 'react';
import axios from 'axios';
import './ConnectionTest.css';

const API_BASE_URL = 'http://localhost:5000/api';

function ConnectionTest() {
  const [status, setStatus] = useState(null);
  const [testing, setTesting] = useState(false);

  const testConnection = async () => {
    setTesting(true);
    setStatus(null);

    try {
      const response = await axios.get(`${API_BASE_URL}/bookings/test-connection`);
      setStatus({
        success: response.data.success,
        message: response.data.message
      });
    } catch (error) {
      setStatus({
        success: false,
        message: error.response?.data?.message || 'Failed to connect to server'
      });
    } finally {
      setTesting(false);
    }
  };

  return (
    <div className="connection-test card">
      <div className="connection-header">
        <h3>🔌 Database Connection</h3>
        <button 
          className="btn btn-secondary btn-sm" 
          onClick={testConnection}
          disabled={testing}
        >
          {testing ? '⏳ Testing...' : '🔄 Test Connection'}
        </button>
      </div>

      {status && (
        <div className={`alert ${status.success ? 'alert-success' : 'alert-error'}`}>
          {status.success ? '✅' : '❌'} {status.message}
        </div>
      )}

      {!status && !testing && (
        <p className="connection-hint">
          Click "Test Connection" to verify database connectivity before importing data.
        </p>
      )}
    </div>
  );
}

export default ConnectionTest;
