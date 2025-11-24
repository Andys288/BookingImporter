function App() {
  return (
    <div style={{ 
      padding: '40px', 
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', 
      minHeight: '100vh',
      color: 'white',
      fontSize: '24px'
    }}>
      <h1 style={{ fontSize: '48px', marginBottom: '20px' }}>✅ Hello World - React is Working!</h1>
      <p style={{ fontSize: '20px', marginBottom: '10px' }}>If you can see this, React is rendering correctly.</p>
      <p style={{ fontSize: '18px', backgroundColor: 'rgba(255,255,255,0.2)', padding: '20px', borderRadius: '8px' }}>
        Frontend is running on port 3000 ✅
      </p>
    </div>
  )
}

export default App
