# 🚀 Quick Reference Card

## 🌐 URLs
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000/api
- **Health Check**: http://localhost:5000/api/health

## 🎯 Quick Start
```bash
# Terminal 1 - Backend
cd my-react-app
npm run server

# Terminal 2 - Frontend
cd my-react-app
npm run dev

# Open browser
http://localhost:3000
```

## 📋 Excel Template Columns

### Required:
- **ProjectID** (Integer) - e.g., 1001
- **ResourceID** (Integer) - e.g., 2001
- **StartDate** (Date) - Format: YYYY-MM-DD
- **EndDate** (Date) - Format: YYYY-MM-DD
- **AllocationPercentage** (0-100) - e.g., 75

### Optional:
- **BookingID** (Integer) - For updates/deletes
- **Role** (Text) - e.g., "Developer"
- **Notes** (Text) - Any notes
- **Action** (Text) - INSERT/UPDATE/DELETE

## 🔧 Configuration (.env)
```env
DB_SERVER=your-server.database.windows.net
DB_DATABASE=your-database
DB_USER=your-username
DB_PASSWORD=your-password
DB_PORT=1433
DB_ENCRYPT=true
DB_TRUST_CERT=false
```

## 📚 Documentation Files
1. **FINAL_SUMMARY.md** ⭐ - Start here!
2. **TROUBLESHOOTING.md** - If issues occur
3. **USER_GUIDE.md** - How to use
4. **SETUP_GUIDE.md** - Installation
5. **README.md** - Technical details
6. **POC_SUMMARY.md** - Executive overview
7. **QUICKSTART.md** - Fast setup

## ✅ Verification Checklist
- [ ] Frontend loads at localhost:3000
- [ ] Backend running on localhost:5000
- [ ] Can download template
- [ ] Can test connection (after DB config)
- [ ] Can upload file (after DB config)

## 🆘 Common Issues

### Blank Screen?
```bash
cd my-react-app
npm install
npm run dev
```

### Connection Failed?
- Check backend is running
- Verify .env configuration
- Test: `curl http://localhost:5000/api/health`

### Port In Use?
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Kill process on port 5000
lsof -ti:5000 | xargs kill -9
```

## 📞 Support
See **TROUBLESHOOTING.md** for detailed help.

---
**Version**: 1.0 | **Date**: 2025-11-21
