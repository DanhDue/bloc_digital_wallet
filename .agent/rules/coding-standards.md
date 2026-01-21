# Coding Standards

## 📝 Naming Conventions
- **Files**: `snake_case.dart` (e.g., `user_repository.dart`).
- **Classes**: `PascalCase` (e.g., `UserRepository`).
- **Variables/Methods**: `camelCase` (e.g., `getUserData`).
- **Constants**: `lowerCamelCase` (e.g., `kDefaultTimeout`) or `SCREAMING_SNAKE` for strict config.

## 🎨 Formatting
- **Line Length**: 80 chars (standard Dart formatter).
- **Trailing Commas**: ALWAYS use trailing commas in widget trees for better formatting.
- **Organization**:
  1.  Imports (Dart -> Package -> Project)
  2.  Constants
  3.  Fields
  4.  Constructor
  5.  Lifecycle methods
  6.  Public methods
  7.  Private methods

## 🧰 Best Practices
- **Variables**: Prefer `final` over `var` or `dynamic`.
- **Async**: Use `async/await` instead of raw `.then()`.
- **Widgets**: Split large widgets into smaller, reusable components.
- **Comments**: Comment *why*, not *what*. Use `///` for documentation comments.
