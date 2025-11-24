# 🤝 Contributing Guide

> Guidelines for contributing to the Booking Importer project

---

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Development Workflow](#development-workflow)
3. [Code Standards](#code-standards)
4. [Project Structure](#project-structure)
5. [Testing Guidelines](#testing-guidelines)
6. [Commit Messages](#commit-messages)
7. [Pull Request Process](#pull-request-process)
8. [Code Review Guidelines](#code-review-guidelines)

---

## 🚀 Getting Started

### Prerequisites

- Node.js v16 or higher
- Git
- SQL Server access
- Code editor (VS Code recommended)

### Initial Setup

```bash
# 1. Clone the repository
git clone https://github.com/Andys288/BookingImporter.git
cd BookingImporter

# 2. Install dependencies
npm install

# 3. Set up environment
cp .env.example .env
# Edit .env with your settings

# 4. Start development servers
npm run server  # Terminal 1
npm run dev     # Terminal 2
```

---

## 🔄 Development Workflow

### 1. Create a Feature Branch

```bash
# Update main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b fix/bug-description
```

### 2. Make Your Changes

- Follow the [code standards](#code-standards)
- Keep commits small and focused
- Test your changes thoroughly
- Update documentation if needed

### 3. Commit Your Changes

```bash
# Stage your changes
git add .

# Commit with descriptive message
git commit -m "feat: add new feature description"
```

See [Commit Messages](#commit-messages) for formatting guidelines.

### 4. Push and Create Pull Request

```bash
# Push to remote
git push origin feature/your-feature-name

# Create PR on GitHub
# Fill out the PR template
```

---

## 📝 Code Standards

### JavaScript/React Style Guide

#### General Rules

```javascript
// ✅ Use const/let, never var
const apiUrl = 'http://localhost:5000';
let counter = 0;

// ✅ Use arrow functions for callbacks
const handleClick = () => {
  console.log('Clicked');
};

// ✅ Use template literals
const message = `Hello, ${name}!`;

// ✅ Use destructuring
const { firstName, lastName } = user;

// ✅ Use async/await over promises
async function fetchData() {
  const response = await axios.get('/api/data');
  return response.data;
}
```

#### React Best Practices

```javascript
// ✅ Functional components with hooks
function MyComponent({ prop1, prop2 }) {
  const [state, setState] = useState(null);
  
  useEffect(() => {
    // Side effects here
  }, [dependencies]);
  
  return <div>{/* JSX */}</div>;
}

// ✅ PropTypes or TypeScript for type checking (future)
MyComponent.propTypes = {
  prop1: PropTypes.string.isRequired,
  prop2: PropTypes.number
};

// ✅ Extract complex logic to custom hooks
function useBookingUpload() {
  // Hook logic
  return { upload, loading, error };
}
```

#### Backend Best Practices

```javascript
// ✅ Use async/await with try-catch
async function processBooking(data) {
  try {
    const result = await database.query(sql, params);
    return { success: true, data: result };
  } catch (error) {
    console.error('Error:', error);
    return { success: false, error: error.message };
  }
}

// ✅ Validate input
function validateBookingData(data) {
  if (!data.projectId) {
    throw new Error('Project ID is required');
  }
  // More validation...
}

// ✅ Use meaningful variable names
const bookingStartDate = new Date(data.startDate);
const isValidDateRange = endDate > startDate;
```

### File Organization

Follow the [Project Structure Guide](./STRUCTURE.md):

```
✅ GOOD
src/components/FileUpload/FileUpload.jsx
server/services/bookingService.js

❌ BAD
src/FileUpload.jsx
server/booking-service.js
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| React Components | PascalCase | `FileUpload.jsx` |
| Functions | camelCase | `processBookings()` |
| Constants | UPPER_SNAKE_CASE | `MAX_FILE_SIZE` |
| Files | camelCase | `bookingService.js` |
| CSS Classes | kebab-case | `.file-upload-container` |

---

## 📁 Project Structure

### Where to Add New Files

#### New React Component

```bash
# 1. Create component folder
mkdir src/components/NewComponent

# 2. Create files
touch src/components/NewComponent/NewComponent.jsx
touch src/components/NewComponent/NewComponent.css

# 3. Import in parent
import NewComponent from './components/NewComponent/NewComponent'
```

#### New API Endpoint

```bash
# 1. Add route
# server/routes/bookingRoutes.js
router.post('/new-endpoint', newController);

# 2. Add controller
# server/controllers/bookingController.js
async function newController(req, res) { ... }

# 3. Add service logic
# server/services/bookingService.js
async function newService(data) { ... }
```

#### New Utility Function

```bash
# Frontend utility
touch src/utils/newUtil.js

# Backend utility
touch server/utils/newUtil.js
```

**📖 Full guide:** [docs/STRUCTURE.md](./STRUCTURE.md)

---

## 🧪 Testing Guidelines

### Manual Testing Checklist

Before submitting a PR, test:

- [ ] Frontend loads without errors
- [ ] Backend starts successfully
- [ ] Database connection works
- [ ] File upload functions correctly
- [ ] Error handling works as expected
- [ ] UI is responsive
- [ ] No console errors
- [ ] Changes work in different browsers

### Future: Automated Testing

When adding tests (future):

```bash
# Unit tests
tests/unit/componentName.test.js

# Integration tests
tests/integration/apiEndpoint.test.js

# E2E tests
tests/e2e/uploadFlow.test.js
```

---

## 💬 Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
# Feature
git commit -m "feat(upload): add drag and drop support"

# Bug fix
git commit -m "fix(api): handle empty file upload error"

# Documentation
git commit -m "docs(readme): update setup instructions"

# Refactor
git commit -m "refactor(components): extract FileUpload logic to hook"

# Multiple changes
git commit -m "feat(templates): add complete template option

- Add 47-column complete template
- Update download controller
- Add template selection UI"
```

### Best Practices

- ✅ Use present tense ("add" not "added")
- ✅ Keep subject line under 50 characters
- ✅ Capitalize subject line
- ✅ No period at end of subject
- ✅ Separate subject from body with blank line
- ✅ Explain *what* and *why*, not *how*

---

## 🔍 Pull Request Process

### Before Creating PR

1. **Update from main:**
   ```bash
   git checkout main
   git pull origin main
   git checkout your-branch
   git rebase main
   ```

2. **Run checks:**
   ```bash
   npm run lint
   # Fix any linting errors
   ```

3. **Test thoroughly:**
   - Manual testing
   - Check all affected features
   - Test error cases

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested locally
- [ ] Tested in different browsers
- [ ] Tested error cases

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No console errors
```

### PR Best Practices

- ✅ Keep PRs small and focused
- ✅ Write clear description
- ✅ Link related issues
- ✅ Add screenshots for UI changes
- ✅ Respond to review comments promptly
- ✅ Keep PR updated with main branch

---

## 👀 Code Review Guidelines

### As a Reviewer

#### What to Look For

1. **Functionality**
   - Does it work as intended?
   - Are edge cases handled?
   - Is error handling adequate?

2. **Code Quality**
   - Is code readable and maintainable?
   - Are there any code smells?
   - Is it following project conventions?

3. **Performance**
   - Are there any performance issues?
   - Could it be optimized?

4. **Security**
   - Are there any security concerns?
   - Is input validated?
   - Are credentials exposed?

5. **Testing**
   - Is it adequately tested?
   - Are test cases comprehensive?

#### Review Comments

```markdown
# ✅ Good comments
"Consider extracting this logic into a separate function for reusability"
"This could cause a memory leak. Try using useEffect cleanup"
"Great improvement! Just one suggestion..."

# ❌ Avoid
"This is wrong"
"Why did you do it this way?"
"I would have done it differently"
```

### As an Author

- ✅ Be open to feedback
- ✅ Ask questions if unclear
- ✅ Explain your reasoning
- ✅ Make requested changes promptly
- ✅ Thank reviewers for their time

---

## 🚫 Common Mistakes to Avoid

### Code Issues

```javascript
// ❌ Don't commit console.logs
console.log('Debug info');

// ❌ Don't commit commented code
// const oldFunction = () => { ... }

// ❌ Don't hardcode values
const apiUrl = 'http://localhost:5000';

// ✅ Use environment variables
const apiUrl = process.env.VITE_API_URL;

// ❌ Don't ignore errors
try {
  await doSomething();
} catch (error) {
  // Empty catch
}

// ✅ Handle errors properly
try {
  await doSomething();
} catch (error) {
  console.error('Error doing something:', error);
  // Handle error appropriately
}
```

### File Organization

```bash
# ❌ Don't put files in wrong places
src/utils/MyComponent.jsx
server/components/helper.js

# ✅ Follow structure guidelines
src/components/MyComponent/MyComponent.jsx
server/utils/helper.js
```

### Git Issues

```bash
# ❌ Don't commit to main directly
git checkout main
git commit -m "quick fix"

# ✅ Use feature branches
git checkout -b fix/issue-description
git commit -m "fix: description"

# ❌ Don't commit large files
git add huge-file.xlsx

# ✅ Add to .gitignore
echo "*.xlsx" >> .gitignore

# ❌ Don't commit sensitive data
git add .env

# ✅ Use .env.example
git add .env.example
```

---

## 📚 Additional Resources

### Project Documentation
- [Project Structure](./STRUCTURE.md)
- [Setup Guide](./SETUP.md)
- [API Documentation](./API.md)

### External Resources
- [React Documentation](https://react.dev)
- [Express.js Guide](https://expressjs.com)
- [Git Best Practices](https://git-scm.com/book/en/v2)
- [JavaScript Style Guide](https://github.com/airbnb/javascript)

---

## 🎓 Learning Path for New Contributors

1. **Week 1: Setup & Familiarization**
   - Set up development environment
   - Read all documentation
   - Run the application locally
   - Explore the codebase

2. **Week 2: Small Contributions**
   - Fix typos in documentation
   - Add comments to complex code
   - Improve error messages
   - Update README

3. **Week 3: Bug Fixes**
   - Pick a small bug from issues
   - Fix and test thoroughly
   - Submit your first PR
   - Respond to review feedback

4. **Week 4+: Features**
   - Start with small features
   - Gradually take on larger tasks
   - Help review others' PRs
   - Share knowledge with team

---

## 💡 Tips for Success

1. **Communicate Early**
   - Discuss major changes before implementing
   - Ask questions when stuck
   - Share progress updates

2. **Write Clean Code**
   - Code is read more than written
   - Future you will thank present you
   - Think about maintainability

3. **Document Your Work**
   - Update docs with code changes
   - Add comments for complex logic
   - Write clear commit messages

4. **Test Thoroughly**
   - Test happy path
   - Test error cases
   - Test edge cases
   - Test in different environments

5. **Stay Updated**
   - Pull from main regularly
   - Keep dependencies updated
   - Follow project announcements

---

## 📞 Questions?

- **Technical questions:** Ask in code review or team chat
- **Process questions:** Refer to this guide
- **Stuck on something:** Don't hesitate to ask for help!

---

**Remember:** Good code is code that others can understand and maintain. Happy coding! 🎉
