# Kiro Quick Start Guide

**Get started with spec-driven development in 5 minutes**

## What is This?

Kiro is a spec-driven development system for the BLOC Digital Wallet project. It helps you:
- Define features clearly with requirements
- Design solutions systematically
- Implement incrementally with testing
- Ensure correctness with property-based tests

## 3-Minute Setup

### 1. Understand the Structure
```
.kiro/
├── steering/              # Development rules
├── specs/                 # Feature specifications
└── settings/              # Configuration
```

### 2. Read Key Files
- **Start here**: `.kiro/README.md` (5 min read)
- **For specs**: `.kiro/specs/README.md` (5 min read)
- **For code**: `.kiro/steering/flutter-bloc-patterns.md` (10 min read)

### 3. You're Ready!

## Creating Your First Spec

### Step 1: Create Directory
```bash
mkdir -p .kiro/specs/my-feature-name
```

### Step 2: Create requirements.md
```markdown
# Requirements: My Feature

## Glossary
- **System**: The BLOC Digital Wallet app
- **User**: Person using the wallet

## Requirements

### Requirement 1: Basic Feature

**User Story:** As a user, I want [feature], so that [benefit]

#### Acceptance Criteria

1. WHEN [event], THE System SHALL [response]
2. WHEN [event], THE System SHALL [response]
```

### Step 3: Create design.md
```markdown
# Design: My Feature

## Overview
[Brief description]

## Architecture
[Component design]

## Data Models
[Data structures]

## Correctness Properties

Property 1: [Universal property]
- For all [inputs], [property] should hold
- Validates: Requirements 1.1

## Testing Strategy
[Unit and property-based tests]
```

### Step 4: Create tasks.md
```markdown
# Implementation Plan: My Feature

## Tasks

- [ ] 1. Implement core logic
  - Create domain layer entities
  - _Requirements: 1.1_

- [ ]* 1.1 Write property test
  - **Property 1: [Property name]**
  - **Validates: Requirements 1.1**

- [ ] 2. Implement data layer
  - Create models and repositories
  - _Requirements: 1.1_
```

## Key Concepts

### EARS Patterns (Requirements)
```
WHEN user clicks button, THE System SHALL show result
WHILE user is logged in, THE System SHALL display dashboard
IF error occurs, THEN THE System SHALL show error message
```

### Correctness Properties (Design)
```
For all valid inputs, the system should preserve invariant X
For any data, serializing then deserializing should return equivalent object
For all operations, applying twice should equal applying once
```

### MVI Pattern (Code)
```
User Action → Intent → BLoC → State + Side Effects → UI Update
```

## Common Tasks

### Create a Feature Spec
1. Create `.kiro/specs/{feature_name}/` directory
2. Write `requirements.md` with user stories
3. Write `design.md` with architecture
4. Write `tasks.md` with implementation steps

### Implement a Feature
1. Read the spec's `design.md`
2. Follow `.kiro/steering/flutter-bloc-patterns.md`
3. Execute tasks from `tasks.md`
4. Run: `melos genAlls && dart format lib/`

### Add Development Rules
1. Update `.kiro/steering/flutter-bloc-patterns.md`
2. Or create new steering file
3. Reference in specs

## Essential Commands

```bash
# Code generation
melos genAlls

# Format code
dart format lib/

# Analyze code
flutter analyze --no-fatal-infos

# Run tests
flutter test

# Create feature (Mason)
mason make mvi_feature --feature_name wallet
```

## File Locations

| What | Where |
|------|-------|
| Steering rules | `.kiro/steering/` |
| Feature specs | `.kiro/specs/{feature_name}/` |
| Requirements | `.kiro/specs/{feature_name}/requirements.md` |
| Design | `.kiro/specs/{feature_name}/design.md` |
| Tasks | `.kiro/specs/{feature_name}/tasks.md` |

## Architecture Rules (TL;DR)

✅ **Do:**
- Use `context.appThemes` for colors
- Use `context.t` for text
- Follow MVI pattern
- Write tests alongside code
- Use EARS patterns for requirements

❌ **Don't:**
- Hardcode colors or strings
- Skip requirements phase
- Ignore error handling
- Write all code before testing
- Skip code generation

## Documentation Map

```
Quick Reference
├── This file (QUICK_START.md)
├── .kiro/README.md (overview)
└── .kiro/specs/README.md (spec workflow)

Detailed Guides
├── .kiro/steering/flutter-bloc-patterns.md (architecture)
├── .kiro/steering/spec-guidelines.md (spec workflow)
└── docs/ai-agents/AI_AGENT_CONTEXT.md (code patterns)

Implementation
├── docs/development/IMPLEMENTATION_GUIDE.md (tutorial)
├── docs/architecture/ARCHITECTURE.md (detailed)
└── docs/getting-started/QUICK_REFERENCE.md (templates)
```

## Next Steps

### Option 1: Create a Spec
1. Read `.kiro/specs/README.md`
2. Create `.kiro/specs/{feature_name}/` directory
3. Follow the three-phase workflow

### Option 2: Understand Architecture
1. Read `.kiro/steering/flutter-bloc-patterns.md`
2. Review `docs/ai-agents/AI_AGENT_CONTEXT.md`
3. Check existing code patterns

### Option 3: Implement a Feature
1. Review spec's `design.md`
2. Read `.kiro/steering/flutter-bloc-patterns.md`
3. Execute tasks from `tasks.md`

## Common Questions

**Q: Where do I start?**  
A: Read `.kiro/README.md` for overview, then `.kiro/specs/README.md` for workflow.

**Q: How do I create a spec?**  
A: Follow the three-phase workflow in `.kiro/specs/README.md`.

**Q: What are EARS patterns?**  
A: Requirement patterns (WHEN, WHILE, IF, etc.). See `.kiro/specs/README.md`.

**Q: How do I implement a feature?**  
A: Follow the spec's tasks and `.kiro/steering/flutter-bloc-patterns.md`.

**Q: Where are code patterns?**  
A: See `docs/ai-agents/AI_AGENT_CONTEXT.md` or `.kiro/steering/flutter-bloc-patterns.md`.

**Q: What's MVI pattern?**  
A: Intent → BLoC → State → UI. See `.kiro/steering/flutter-bloc-patterns.md`.

## Checklist: Before You Start

- [ ] Read `.kiro/README.md`
- [ ] Read `.kiro/specs/README.md`
- [ ] Read `.kiro/steering/flutter-bloc-patterns.md`
- [ ] Understand EARS patterns
- [ ] Understand MVI pattern
- [ ] Know where to put code
- [ ] Ready to create spec!

## Resources

### Quick Reference
- This file: `.kiro/QUICK_START.md`
- Overview: `.kiro/README.md`
- Specs: `.kiro/specs/README.md`

### Detailed Guides
- Architecture: `.kiro/steering/flutter-bloc-patterns.md`
- Spec Workflow: `.kiro/steering/spec-guidelines.md`
- Code Patterns: `docs/ai-agents/AI_AGENT_CONTEXT.md`

### Implementation
- Tutorial: `docs/development/IMPLEMENTATION_GUIDE.md`
- Architecture: `docs/architecture/ARCHITECTURE.md`
- Templates: `docs/getting-started/QUICK_REFERENCE.md`

## Support

### For Questions About
- **Getting started**: This file
- **Specs**: `.kiro/specs/README.md`
- **Architecture**: `.kiro/steering/flutter-bloc-patterns.md`
- **Code patterns**: `docs/ai-agents/AI_AGENT_CONTEXT.md`
- **Implementation**: `docs/development/IMPLEMENTATION_GUIDE.md`

---

**Ready?** Start with `.kiro/README.md` 🚀
