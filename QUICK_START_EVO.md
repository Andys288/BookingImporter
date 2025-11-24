# 🚀 Quick Start - Evo Builder

## ✅ Current Status

**Both servers are RUNNING!**

```
✅ Backend:  http://localhost:5000  (Express API)
✅ Frontend: http://localhost:3000  (React + Vite)
```

---

## 🎯 Quick Commands

### View Running Servers
```bash
# Check backend logs
curl http://localhost:5000/api/health

# Check frontend
curl -I http://localhost:3000
```

### Restart Servers (if needed)

**Backend:**
```bash
# Stop: Ctrl+C in the server terminal
# Start:
npm run server
```

**Frontend:**
```bash
# Stop: Ctrl+C in the dev terminal
# Start:
npm run dev
```

---

## 🔧 Configure Database

Edit `.env` file:

```env
# For SQL Authentication (current setup)
USE_WINDOWS_AUTH=false
DB_SERVER=your-server-name
DB_DATABASE=your-database-name
DB_USER=your-username
DB_PASSWORD=your-password

# For Windows Authentication (Windows only)
USE_WINDOWS_AUTH=true
DB_SERVER=your-server-name
DB_DATABASE=your-database-name
```

After changing `.env`, restart the backend server.

---

## 📱 Access the Application

1. **Open your browser**
2. **Navigate to**: http://localhost:3000
3. **You should see**:
   - 📊 Resource Booking Import Tool
   - Connection status indicator
   - File upload area
   - Template download buttons

---

## 🧪 Test the Application

### 1. Download Template
Click "Download Minimum Template" or "Download Complete Template"

### 2. Fill Template
Open the downloaded Excel file and add booking data

### 3. Upload File
Drag & drop or click to upload the filled template

### 4. View Results
See import results with success/error details

---

## 📂 Project Structure

```
BookingImporter/
├── server/          # Backend (Express)
│   ├── server.js    # Main server file
│   ├── config/      # Database config
│   ├── routes/      # API routes
│   └── services/    # Business logic
├── src/             # Frontend (React)
│   ├── App.jsx      # Main component
│   └── components/  # React components
├── .env             # Configuration
└── package.json     # Dependencies
```

---

## 🛠️ Useful Commands

```bash
# Install dependencies
npm install

# Start backend
npm run server

# Start frontend
npm run dev

# Build for production
npm run build

# Run linter
npm run lint

# Check for updates
npm outdated
```

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| `EVO_BUILDER_SETUP.md` | Complete setup guide |
| `README.md` | Project overview |
| `LOCAL_SETUP_GUIDE.md` | Local development setup |
| `TROUBLESHOOTING.md` | Common issues |

---

## 🆘 Quick Troubleshooting

### Backend not responding?
```bash
# Check if running
curl http://localhost:5000/api/health

# Restart
npm run server
```

### Frontend not loading?
```bash
# Check if running
curl -I http://localhost:3000

# Restart
npm run dev
```

### Database connection error?
1. Check `.env` file
2. Verify SQL Server is running
3. Test credentials
4. Restart backend

---

## 📞 Need Help?

1. Check `EVO_BUILDER_SETUP.md` for detailed info
2. Review console logs
3. Check GitHub repository
4. Contact: Andys288

---

**Status**: ✅ Ready to use!

*Servers are running on ports 3000 (frontend) and 5000 (backend)*
