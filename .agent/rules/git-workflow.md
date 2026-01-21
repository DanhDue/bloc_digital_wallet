# Git Workflow Rules

## 🌿 Branching Strategy
- **Main Branch**: `main` (Protected, always deployable).
- **Feature Branches**: `feature/<feature-name>` (e.g., `feature/login-screen`).
- **Fix Branches**: `fix/<bug-name>` (e.g., `fix/token-refresh`).
- **Chore Branches**: `chore/<task-name>` (e.g., `chore/upgrade-deps`).

## 💬 Commit Messages
Format: `type(scope): subject`

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting (no code change)
- `refactor`: Restructuring code
- `test`: Adding tests
- `chore`: Maintenance (dependencies, build scripts)

### Examples
- `feat(auth): implement login screen`
- `fix(wallet): resolve infinite loading state`
- `style(ui): run dart format`

## 🚀 Pre-Push Checklist
1.  Run `melos run analyze` -> Must report "No issues found!".
2.  Run `dart format lib/` -> Must show no changes needed.
3.  Check `project_state.md` -> Update status if milestone reached.
