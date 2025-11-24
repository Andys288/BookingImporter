import './ResultsDisplay.css';

function ResultsDisplay({ results, onReset }) {
  if (!results || !results.success) {
    return (
      <div className="results-container card">
        <div className="alert alert-error">
          <h3>❌ Upload Failed</h3>
          <p>{results?.message || 'An error occurred during upload'}</p>
          {results?.error && <p className="error-detail">{results.error}</p>}
          <button className="btn btn-primary" onClick={onReset}>
            Try Again
          </button>
        </div>
      </div>
    );
  }

  const { results: data } = results;
  const hasErrors = data.validationErrors.length > 0 || data.processingErrors.length > 0;
  const hasWarnings = data.warnings.length > 0;

  return (
    <div className="results-container card">
      <div className="results-header">
        <h2>📊 Import Results</h2>
        <button className="btn btn-secondary" onClick={onReset}>
          Upload Another File
        </button>
      </div>

      {/* Summary Section */}
      <div className="summary-section">
        <h3>Summary</h3>
        <div className="summary-grid">
          <div className="summary-item">
            <div className="summary-label">File Name</div>
            <div className="summary-value">{data.fileName}</div>
          </div>
          <div className="summary-item">
            <div className="summary-label">Sheet Name</div>
            <div className="summary-value">{data.sheetName}</div>
          </div>
          <div className="summary-item">
            <div className="summary-label">Total Records</div>
            <div className="summary-value">{data.totalRecords}</div>
          </div>
          <div className="summary-item success">
            <div className="summary-label">✅ Successful</div>
            <div className="summary-value">{data.successCount}</div>
          </div>
          <div className="summary-item error">
            <div className="summary-label">❌ Failed</div>
            <div className="summary-value">{data.failureCount}</div>
          </div>
          <div className="summary-item warning">
            <div className="summary-label">⚠️ Warnings</div>
            <div className="summary-value">{data.warningCount}</div>
          </div>
        </div>
      </div>

      {/* Status Badge */}
      <div className="status-section">
        {data.successCount === data.totalRecords && (
          <div className="alert alert-success">
            <strong>🎉 Success!</strong> All {data.totalRecords} records were imported successfully.
          </div>
        )}
        {data.successCount > 0 && data.failureCount > 0 && (
          <div className="alert alert-warning">
            <strong>⚠️ Partial Success</strong> {data.successCount} of {data.totalRecords} records were imported. {data.failureCount} failed.
          </div>
        )}
        {data.successCount === 0 && data.failureCount > 0 && (
          <div className="alert alert-error">
            <strong>❌ Import Failed</strong> No records were imported. Please review the errors below.
          </div>
        )}
      </div>

      {/* Validation Errors */}
      {data.validationErrors.length > 0 && (
        <div className="errors-section">
          <h3>❌ Validation Errors ({data.validationErrors.length})</h3>
          <div className="error-list">
            {data.validationErrors.map((error, idx) => (
              <div key={idx} className="error-item">
                <span className="error-icon">⚠️</span>
                <span className="error-text">{error}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Processing Errors */}
      {data.processingErrors.length > 0 && (
        <div className="errors-section">
          <h3>❌ Processing Errors ({data.processingErrors.length})</h3>
          <div className="error-list">
            {data.processingErrors.map((error, idx) => (
              <div key={idx} className="error-item">
                <span className="error-icon">🔴</span>
                <div className="error-details">
                  <div className="error-text">
                    <strong>Row {error.row}:</strong> {error.error}
                  </div>
                  {error.record && (
                    <details className="error-record">
                      <summary>View Record Data</summary>
                      <pre>{JSON.stringify(error.record, null, 2)}</pre>
                    </details>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Warnings */}
      {data.warnings.length > 0 && (
        <div className="warnings-section">
          <h3>⚠️ Warnings ({data.warnings.length})</h3>
          <div className="warning-list">
            {data.warnings.map((warning, idx) => (
              <div key={idx} className="warning-item">
                <span className="warning-icon">⚠️</span>
                <span className="warning-text">{warning}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Duplicates */}
      {data.duplicates && data.duplicates.length > 0 && (
        <div className="duplicates-section">
          <h3>🔄 Potential Duplicates ({data.duplicates.length})</h3>
          <div className="duplicate-list">
            {data.duplicates.map((dup, idx) => (
              <div key={idx} className="duplicate-item">
                <div className="duplicate-header">
                  Rows: {dup.rows.join(', ')}
                </div>
                <div className="duplicate-record">
                  <pre>{JSON.stringify(dup.record, null, 2)}</pre>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Success Message */}
      {!hasErrors && !hasWarnings && (
        <div className="success-message">
          <div className="success-icon">✅</div>
          <h3>All records processed successfully!</h3>
          <p>Your booking data has been imported into the scheduling system.</p>
        </div>
      )}
    </div>
  );
}

export default ResultsDisplay;
