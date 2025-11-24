# 🚀 Quick Start Guide

> **New to the project?** This guide will get you up and running in under 30 minutes!

---

## 📋 Prerequisites Checklist

Before you begin, make sure you have:

- [ ] **Node.js** v16 or higher ([Download](https://nodejs.org/))
- [ ] **Git** installed ([Download](https://git-scm.com/))
- [ ] **SQL Server** access (any edition)
- [ ] **Windows Authentication** enabled on SQL Server
- [ ] **Code Editor** (VS Code recommended)
- [ ] **Terminal/Command Prompt** access

---

## ⚡ 5-Minute Setup

### Step 1: Clone the Repository (1 min)

```bash
# Clone the project
git clone https://github.com/Andys288/BookingImporter.git

# Navigate to project directory
cd BookingImporter
```

### Step 2: Install Dependencies (2 min)

```bash
# Install all npm packages
npm install

# For Windows Authentication (REQUIRED)
npm install msnodesqlv8
```

**💡 Tip:** If you're on Windows, you can run the automated installer:
```bash
# Windows Command Prompt
scripts\install\install-windows-auth.bat

# Or PowerShell
.\scripts\install\install-windows-auth.ps1
```

### Step 3: Configure Environment (1 min)

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your database details
# Use your favorite editor (nano, vim, VS Code, etc.)
```

**Required settings in `.env`:**
```env
DB_SERVER=your_server_name
DB_DATABASE=your_database_name
DB_PORT=1433
```

### Step 4: Start the Application (1 min)

**Open TWO terminal windows:**

**Terminal 1 - Backend:**
```bash
npm run server
```
✅ You should see: `Server running on port 5000`

**Terminal 2 - Frontend:**
```bash
npm run dev
```
✅ You should see: `Local: http://localhost:3000`

### Step 5: Open in Browser

Navigate to: **http://localhost:3000**

🎉 **You're done!** The application should load successfully.

---

## 🧪 Verify Everything Works

### Test 1: Database Connection

1. Look for the **Connection Status** indicator at the top of the page
2. It should show: ✅ **Connected to Database**
3. If not, check your `.env` settings

### Test 2: Template Download

1. Click **"Download Minimum Template"** button
2. An Excel file should download
3. Open it to verify it's a valid template

### Test 3: File Upload (Optional)

1. Use the downloaded template
2. Fill in sample data
3. Drag and drop it into the upload area
4. Verify the upload processes successfully

---

## 📚 What to Read Next

Now that you're set up, here's your learning path:

### Day 1: Understanding the Project (1 hour)

1. **[README.md](../README.md)** (10 min)
   - Project overview
   - Features
   - Architecture

2. **[STRUCTURE.md](./STRUCTURE.md)** (20 min)
   - How the code is organized
   - Where to find things
   - Where to add new files

3. **[CONTRIBUTING.md](./CONTRIBUTING.md)** (30 min)
   - Development workflow
   - Code standards
   - How to contribute

### Day 2: Exploring the Code (2-3 hours)

1. **Frontend Components**
   - `src/App.jsx` - Main application
   - `src/components/FileUpload/` - File upload UI
   - `src/components/ResultsDisplay/` - Results display

2. **Backend Services**
   - `server/server.js` - Express server
   - `server/routes/` - API endpoints
   - `server/controllers/` - Request handlers
   - `server/services/` - Business logic

3. **Database**
   - `database/schema/` - SQL schemas
   - `database/stored-procedures/` - SQL procedures

### Day 3+: Start Contributing

1. Pick a small task or bug
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 🐛 Common Issues & Solutions

### Issue: Backend won't start

**Error:** `Cannot connect to database`

**Solutions:**
1. Check SQL Server is running
2. Verify `.env` settings are correct
3. Ensure your Windows user has database access
4. Check firewall isn't blocking port 1433

```bash
# Test SQL Server connection
sqlcmd -S your_server_name -E
```

---

### Issue: Frontend can't connect to backend

**Error:** `Network Error` or `ERR_CONNECTION_REFUSED`

**Solutions:**
1. Make sure backend is running (`npm run server`)
2. Check backend is on port 5000
3. Verify no other app is using port 5000

```bash
# Check what's running on port 5000 (Windows)
netstat -ano | findstr :5000

# Check what's running on port 5000 (Mac/Linux)
lsof -i :5000
```

---

### Issue: msnodesqlv8 installation fails

**Error:** `node-gyp rebuild failed`

**Solutions:**
1. Install Visual C++ Build Tools
2. Install Windows SDK
3. Run as Administrator

**Windows:**
```bash
# Run PowerShell as Administrator
npm install --global windows-build-tools
npm install msnodesqlv8
```

See [WINDOWS_AUTH_SETUP.md](./WINDOWS_AUTH_SETUP.md) for detailed instructions.

---

### Issue: Excel upload fails

**Error:** `Invalid Excel structure`

**Solutions:**
1. Use the provided templates (don't create from scratch)
2. Don't modify column headers
3. Ensure all required fields are filled
4. Check date formats are correct

**Required columns:**
- ResourceName
- ProjectCode
- StartDate
- EndDate
- Hours

---

### Issue: Port already in use

**Error:** `Port 5000 is already in use`

**Solutions:**

**Option 1: Kill the process using the port**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:5000 | xargs kill -9
```

**Option 2: Change the port**
```bash
# Edit .env file
PORT=5001

# Restart backend
npm run server
```

---

## 💡 Pro Tips

### Tip 1: Use VS Code Extensions

Install these for better development experience:

- **ES7+ React/Redux/React-Native snippets** - React snippets
- **ESLint** - Code linting
- **Prettier** - Code formatting
- **Auto Rename Tag** - HTML/JSX tag renaming
- **Path Intellisense** - Path autocomplete

### Tip 2: Keep Backend Running

The backend rarely needs restarts. Keep it running and only restart when:
- You change environment variables
- You modify server configuration
- You update npm packages

### Tip 3: Hot Reload

The frontend has hot reload enabled. Your changes appear instantly without refresh!

### Tip 4: Use Browser DevTools

Press **F12** to open DevTools:
- **Console** - See errors and logs
- **Network** - Monitor API calls
- **React DevTools** - Inspect React components

### Tip 5: Check Both Terminals

When debugging, always check BOTH terminal windows:
- **Backend terminal** - Server errors, database issues
- **Frontend terminal** - Build errors, compilation issues

---

## 🎯 Development Workflow

### Daily Workflow

```bash
# 1. Pull latest changes
git pull origin main

# 2. Start backend (Terminal 1)
npm run server

# 3. Start frontend (Terminal 2)
npm run dev

# 4. Make your changes

# 5. Test thoroughly

# 6. Commit and push
git add .
git commit -m "feat: your feature description"
git push
```

### Before Committing

```bash
# 1. Run linter
npm run lint

# 2. Fix any errors
npm run lint -- --fix

# 3. Test the application
# - Upload a file
# - Download templates
# - Check database connection

# 4. Commit
git commit -m "your message"
```

---

## 📁 Project Structure Quick Reference

```
BookingImporter/
├── docs/              # 📚 Read documentation here
├── src/               # 🎨 Frontend code here
│   └── components/    # React components
├── server/            # 🔧 Backend code here
│   ├── routes/        # API endpoints
│   ├── controllers/   # Request handlers
│   └── services/      # Business logic
├── public/templates/  # 📊 Excel templates
├── database/          # 🗄️ SQL files
└── scripts/           # 🛠️ Utility scripts
```

**Need more details?** See [STRUCTURE.md](./STRUCTURE.md)

---

## 🔑 Key Commands

### Development
```bash
npm run dev        # Start frontend (port 3000)
npm run server     # Start backend (port 5000)
npm run build      # Build for production
npm run preview    # Preview production build
```

### Code Quality
```bash
npm run lint       # Check code quality
npm run lint --fix # Auto-fix issues
```

### Dependencies
```bash
npm install        # Install all dependencies
npm update         # Update dependencies
npm audit          # Check for vulnerabilities
npm audit fix      # Fix vulnerabilities
```

---

## 🎓 Learning Resources

### Project Documentation
- [README.md](../README.md) - Project overview
- [STRUCTURE.md](./STRUCTURE.md) - Code organization
- [CONTRIBUTING.md](./CONTRIBUTING.md) - How to contribute
- [API.md](./API.md) - API documentation
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Common issues

### External Resources
- [React Documentation](https://react.dev/learn) - Learn React
- [Express.js Guide](https://expressjs.com/en/guide/routing.html) - Learn Express
- [Vite Documentation](https://vitejs.dev/guide/) - Learn Vite
- [SQL Server Docs](https://docs.microsoft.com/en-us/sql/) - Learn SQL Server

---

## 🆘 Getting Help

### Self-Help (Try First)
1. Check this guide
2. Read [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
3. Check browser console (F12)
4. Check terminal output
5. Search existing issues on GitHub

### Ask for Help
1. **Team Chat** - Quick questions
2. **GitHub Issues** - Bug reports, feature requests
3. **Code Review** - During pull requests
4. **Tech Lead** - Complex issues

### When Asking for Help, Include:
- What you're trying to do
- What you expected to happen
- What actually happened
- Error messages (full text)
- Screenshots (if relevant)
- What you've already tried

---

## ✅ Setup Checklist

Use this checklist to verify your setup:

### Environment Setup
- [ ] Node.js installed (v16+)
- [ ] Git installed
- [ ] Code editor installed
- [ ] Project cloned
- [ ] Dependencies installed (`npm install`)
- [ ] msnodesqlv8 installed (for Windows Auth)

### Configuration
- [ ] `.env` file created
- [ ] Database server configured
- [ ] Database name configured
- [ ] Port settings configured

### Application Running
- [ ] Backend starts without errors
- [ ] Frontend starts without errors
- [ ] Can access http://localhost:3000
- [ ] Database connection shows green
- [ ] Can download templates
- [ ] Can upload files (optional)

### Development Tools
- [ ] VS Code extensions installed
- [ ] Browser DevTools familiar
- [ ] Git configured
- [ ] Terminal comfortable

### Documentation Read
- [ ] README.md
- [ ] STRUCTURE.md
- [ ] CONTRIBUTING.md
- [ ] This guide

---

## 🎉 You're Ready!

Congratulations! You're now set up and ready to contribute to the Booking Importer project.

### Next Steps:
1. ✅ Explore the codebase
2. ✅ Pick a small task
3. ✅ Make your first contribution
4. ✅ Help others get started

### Remember:
- 💬 Ask questions when stuck
- 📚 Read the documentation
- 🧪 Test your changes
- 🤝 Help your teammates

---

**Welcome to the team! Happy coding! 🚀**

---

**Last Updated:** January 2025  
**Maintained By:** Development Team  
**Questions?** Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) or ask the team!
