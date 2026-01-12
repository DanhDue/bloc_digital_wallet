# Changelog

All notable changes to the MVI Subfeature brick will be documented in this file.

## [1.0.0] - 2026-01-12

### Added
- Initial release of mvi_subfeature brick
- Generate use cases within existing modules
- Generate pages that reuse existing module blocs
- Generate reusable widgets
- Optional entity generation (when subfeature needs its own entity)
- Optional model generation (when subfeature needs its own model)
- Pre-gen hook to validate module existence
- Auto-set year for copyright headers
- Comprehensive documentation and examples

### Features
- Reuses existing module structure (repository, bloc, entities)
- Follows Clean Architecture + MVI pattern
- Injectable dependency injection
- Auto-route page annotation
- Proper event subscription handling
- Pattern-matched state handling
- TODO comments for implementation guidance

### Templates Included
- Use case template with repository reference
- Page template with bloc integration and event handling
- Widget template for reusable components
- Optional entity template (Equatable-based)
- Optional model template (Freezed-based with JSON serialization)

### Documentation
- Comprehensive README with examples
- Use case comparisons (when to use vs mvi_feature)
- Post-generation step-by-step guide
- Troubleshooting section
- Architecture pattern explanation
