import { useState } from 'react'
import './App.css'
import FileUpload from './components/FileUpload'
import ResultsDisplay from './components/ResultsDisplay'
import ConnectionTest from './components/ConnectionTest'

function App() {
  const [results, setResults] = useState(null)
  const [loading, setLoading] = useState(false)

  const handleUploadComplete = (data) => {
    setResults(data)
    setLoading(false)
  }

  const handleUploadStart = () => {
    setLoading(true)
    setResults(null)
  }

  return (
    <div className="App">
      <header className="app-header">
        <h1>📊 Resource Booking Import Tool</h1>
        <p className="subtitle">Upload Excel files to import resource bookings into the scheduling system</p>
      </header>

      <div className="container">
        <ConnectionTest />
        
        <FileUpload 
          onUploadComplete={handleUploadComplete}
          onUploadStart={handleUploadStart}
          loading={loading}
        />
        
        {results && <ResultsDisplay results={results} />}
      </div>
    </div>
  )
}

export default App
