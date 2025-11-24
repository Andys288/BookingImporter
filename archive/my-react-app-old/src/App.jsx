import { useState } from 'react';
import './App.css';
import FileUpload from './components/FileUpload';
import ResultsDisplay from './components/ResultsDisplay';
import ConnectionTest from './components/ConnectionTest';

function App() {
  const [results, setResults] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleUploadComplete = (uploadResults) => {
    setResults(uploadResults);
    setLoading(false);
  };

  const handleUploadStart = () => {
    setLoading(true);
    setResults(null);
  };

  const handleReset = () => {
    setResults(null);
    setLoading(false);
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>📊 Resource Booking Import Tool</h1>
        <p className="subtitle">Import resource booking data from Excel to scheduling system</p>
      </header>

      <main className="App-main">
        <ConnectionTest />
        
        <div className="upload-section">
          <FileUpload 
            onUploadStart={handleUploadStart}
            onUploadComplete={handleUploadComplete}
            loading={loading}
          />
        </div>

        {results && (
          <ResultsDisplay 
            results={results} 
            onReset={handleReset}
          />
        )}
      </main>

      <footer className="App-footer">
        <p>POC - Resource Booking Import System v1.0</p>
      </footer>
    </div>
  );
}

export default App;
