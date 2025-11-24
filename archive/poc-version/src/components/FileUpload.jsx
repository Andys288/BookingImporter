import { useState, useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import axios from 'axios';
import './FileUpload.css';

const API_BASE_URL = 'http://localhost:5000/api';

function FileUpload({ onUploadStart, onUploadComplete, loading }) {
  const [selectedFile, setSelectedFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [error, setError] = useState(null);

  const onDrop = useCallback((acceptedFiles, rejectedFiles) => {
    setError(null);
    
    if (rejectedFiles.length > 0) {
      setError('Please upload only Excel files (.xlsx or .xls)');
      return;
    }

    if (acceptedFiles.length > 0) {
      setSelectedFile(acceptedFiles[0]);
      setPreview(null);
    }
  }, []);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
      'application/vnd.ms-excel': ['.xls']
    },
    multiple: false,
    disabled: loading
  });

  const handlePreview = async () => {
    if (!selectedFile) return;

    setError(null);
    const formData = new FormData();
    formData.append('file', selectedFile);

    try {
      const response = await axios.post(`${API_BASE_URL}/bookings/preview`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      setPreview(response.data);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to preview file');
    }
  };

  const handleUpload = async () => {
    if (!selectedFile) return;

    setError(null);
    onUploadStart();

    const formData = new FormData();
    formData.append('file', selectedFile);

    try {
      const response = await axios.post(`${API_BASE_URL}/bookings/upload`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });

      onUploadComplete(response.data);
      setSelectedFile(null);
      setPreview(null);
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to upload file');
      onUploadComplete(null);
    }
  };

  const handleDownloadTemplate = () => {
    window.open(`${API_BASE_URL}/bookings/template`, '_blank');
  };

  return (
    <div className="file-upload-container card">
      <h2>📁 Upload Excel File</h2>
      
      <div className="template-download">
        <button 
          className="btn btn-secondary" 
          onClick={handleDownloadTemplate}
          disabled={loading}
        >
          📥 Download Sample Template
        </button>
      </div>

      <div 
        {...getRootProps()} 
        className={`dropzone ${isDragActive ? 'active' : ''} ${loading ? 'disabled' : ''}`}
      >
        <input {...getInputProps()} />
        {isDragActive ? (
          <p>📂 Drop the Excel file here...</p>
        ) : (
          <div>
            <p>🎯 Drag & drop an Excel file here, or click to select</p>
            <p className="file-types">Accepted: .xlsx, .xls</p>
          </div>
        )}
      </div>

      {error && (
        <div className="alert alert-error">
          ❌ {error}
        </div>
      )}

      {selectedFile && (
        <div className="selected-file">
          <h3>Selected File:</h3>
          <div className="file-info">
            <span className="file-name">📄 {selectedFile.name}</span>
            <span className="file-size">
              {(selectedFile.size / 1024).toFixed(2)} KB
            </span>
          </div>
          
          <div className="action-buttons">
            <button 
              className="btn btn-secondary" 
              onClick={handlePreview}
              disabled={loading}
            >
              👁️ Preview
            </button>
            <button 
              className="btn btn-primary" 
              onClick={handleUpload}
              disabled={loading}
            >
              {loading ? '⏳ Processing...' : '🚀 Upload & Process'}
            </button>
          </div>
        </div>
      )}

      {loading && (
        <div className="loading-container">
          <div className="spinner"></div>
          <p>Processing your file... Please wait.</p>
        </div>
      )}

      {preview && !loading && (
        <div className="preview-container">
          <h3>📋 File Preview</h3>
          <div className="preview-info">
            <p><strong>Sheet Name:</strong> {preview.sheetName}</p>
            <p><strong>Total Rows:</strong> {preview.totalRows}</p>
            <p><strong>Columns:</strong> {preview.headers.join(', ')}</p>
          </div>
          
          <div className="preview-table-container">
            <table className="preview-table">
              <thead>
                <tr>
                  {preview.headers.map((header, idx) => (
                    <th key={idx}>{header}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {preview.preview.map((row, idx) => (
                  <tr key={idx}>
                    {preview.headers.map((header, colIdx) => (
                      <td key={colIdx}>{row[header] || '-'}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="preview-note">
            Showing first {preview.preview.length} of {preview.totalRows} rows
          </p>
        </div>
      )}
    </div>
  );
}

export default FileUpload;
