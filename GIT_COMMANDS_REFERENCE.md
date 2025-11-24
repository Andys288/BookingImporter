# Git Commands Reference for BookingImporter

## Quick Reference for Common Git Operations

### Check Status
```bash
# View current status
git status

# View commit history
git log --oneline -10

# View detailed log with author info
git log --format="%h - %an - %s" -5
```

### Making Changes
```bash
# Stage all changes
git add .

# Stage specific file
git add filename.ext

# Commit changes
git commit -m "Your descriptive commit message"

# Stage and commit in one command
git commit -am "Your message"
```

### Syncing with Remote
```bash
# Fetch latest changes from remote
git fetch origin

# Pull latest changes (fetch + merge)
git pull origin main

# Push your commits to remote (requires authentication)
git push origin main

# View remote information
git remote -v
git remote show origin
```

### Branch Operations
```bash
# List all branches
git branch -a

# Create new branch
git branch feature-name

# Switch to branch
git checkout branch-name

# Create and switch to new branch
git checkout -b feature-name

# Merge branch into current branch
git merge branch-name
```

### Viewing Changes
```bash
# View uncommitted changes
git diff

# View changes in staged files
git diff --staged

# View changes in specific file
git diff filename.ext

# View file at specific commit
git show commit-hash:path/to/file
```

### Undoing Changes
```bash
# Discard changes in working directory
git checkout -- filename.ext

# Unstage file (keep changes)
git reset HEAD filename.ext

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
```

### Authentication for Push

Since this is a public repository, you'll need to authenticate when pushing. Options:

#### Option 1: Personal Access Token (PAT)
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token with 'repo' scope
3. Use token as password when prompted:
   ```bash
   git push origin main
   Username: Andys288
   Password: <your-token>
   ```

#### Option 2: GitHub CLI
```bash
# Install GitHub CLI
# Then authenticate
gh auth login

# Push using GitHub CLI
gh repo sync
```

#### Option 3: SSH Key
1. Generate SSH key: `ssh-keygen -t ed25519 -C "your_email@example.com"`
2. Add to GitHub: Settings → SSH and GPG keys
3. Change remote to SSH:
   ```bash
   git remote set-url origin git@github.com:Andys288/BookingImporter.git
   ```

### Current Configuration

```
Repository: https://github.com/Andys288/BookingImporter.git
Branch: main
User: Andys288 <andys288@users.noreply.github.com>
Remote: origin (fetch and push enabled)
```

### Useful Aliases

Add these to your git config for shortcuts:
```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.last 'log -1 HEAD'
git config --global alias.unstage 'reset HEAD --'
```

Then use:
```bash
git st        # instead of git status
git co main   # instead of git checkout main
git br        # instead of git branch
git ci -m     # instead of git commit -m
```

### Project-Specific Workflow

1. **Before starting work:**
   ```bash
   git pull origin main
   ```

2. **Make your changes** (edit files)

3. **Check what changed:**
   ```bash
   git status
   git diff
   ```

4. **Stage and commit:**
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

5. **Push to GitHub:**
   ```bash
   git push origin main
   ```

### Troubleshooting

**Problem: Push rejected**
```bash
# Solution: Pull first, then push
git pull origin main
git push origin main
```

**Problem: Merge conflicts**
```bash
# 1. Open conflicted files and resolve
# 2. Stage resolved files
git add resolved-file.ext
# 3. Complete merge
git commit -m "Resolved merge conflicts"
```

**Problem: Accidentally committed wrong files**
```bash
# Undo last commit, keep changes
git reset --soft HEAD~1
# Fix the staging
git add correct-files
# Commit again
git commit -m "Correct commit"
```

### Best Practices

1. **Commit often** with clear messages
2. **Pull before push** to avoid conflicts
3. **Use descriptive commit messages**:
   - Good: "Add validation for booking dates"
   - Bad: "Fixed stuff"
4. **Test before committing** major changes
5. **Don't commit sensitive data** (passwords, tokens)
6. **Use .gitignore** for files that shouldn't be tracked

### Getting Help

```bash
# Get help for any command
git help <command>
git <command> --help

# Examples:
git help commit
git push --help
```

---

**Note**: This repository is public, so all commits will be visible to everyone. Be careful not to commit sensitive information like database passwords or API keys.
