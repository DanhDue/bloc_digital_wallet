# Kiro Instrumentation Index

**Project**: BLOC Digital Wallet  
**Setup Date**: January 14, 2026  
**Status**: ✅ Complete and Ready

---

## 📍 Start Here

### For First-Time Users
1. **Read**: `docs/kiro/KIRO_SETUP_COMPLETE.md` (this directory)
2. **Read**: `.kiro/QUICK_START.md` (5 minutes)
3. **Read**: `.kiro/README.md` (10 minutes)
4. **Ready**: Create your first spec!

### For Experienced Developers
1. **Review**: `.kiro/steering/flutter-bloc-patterns.md`
2. **Review**: `.kiro/specs/README.md`
3. **Create**: Feature spec following three-phase workflow

---

## 📁 Directory Structure

```
Project Root
├── docs/kiro/                      ← Kiro documentation
│   ├── KIRO_SETUP_COMPLETE.md      ← Setup summary (read first!)
│   ├── KIRO_INDEX.md               ← This file
│   └── INSTRUMENTATION_COMPLETE.md ← Comprehensive summary
├── .kiro/                          ← Kiro configuration
│   ├── README.md                   ← Main navigation hub
│   ├── QUICK_START.md              ← 5-minute quick start
│   ├── SETUP_SUMMARY.md            ← Detailed setup info
│   ├── settings/
│   │   └── mcp.json                ← MCP configuration
│   ├── steering/
│   │   ├── flutter-bloc-patterns.md ← Architecture rules
│   │   └── spec-guidelines.md      ← Spec workflow
│   └── specs/
│       ├── README.md               ← Specs index & workflow
│       └── {feature_name}/         ← Individual specs
│           ├── requirements.md
│           ├── design.md
│           └── tasks.md
└── docs/                           ← Project documentation
    ├── ai-agents/                  ← AI agent guides
    ├── architecture/               ← Architecture docs
    ├── development/                ← Development guides
    └── getting-started/            ← Quick start guides
```

---

## 📚 File Guide

### docs/kiro/ Directory

| File | Purpose | Read Time |
|------|---------|-----------|
| `KIRO_SETUP_COMPLETE.md` | Setup completion summary | 5 min |
| `KIRO_INDEX.md` | This file - navigation index | 2 min |
| `INSTRUMENTATION_COMPLETE.md` | Comprehensive summary | 10 min |

### .kiro/ Directory

| File | Purpose | Read Time |
|------|---------|-----------|
| `.kiro/README.md` | Main navigation hub | 10 min |
| `.kiro/QUICK_START.md` | 5-minute quick start | 5 min |
| `.kiro/SETUP_SUMMARY.md` | Detailed setup summary | 10 min |

### .kiro/steering/ Directory

| File | Purpose | Read Time |
|------|---------|-----------|
| `flutter-bloc-patterns.md` | Architecture rules & patterns | 15 min |
| `spec-guidelines.md` | Spec workflow guidelines | 10 min |

### .kiro/specs/ Directory

| File | Purpose | Read Time |
|------|---------|-----------|
| `README.md` | Specs index & workflow | 10 min |
| `{feature_name}/` | Individual feature specs | Varies |

### .kiro/settings/ Directory

| File | Purpose |
|------|---------|
| `mcp.json` | MCP server configuration |

---

## 🚀 Quick Navigation

### I Want To...

#### Create a New Feature Spec
1. Read: `.kiro/specs/README.md`
2. Create: `.kiro/specs/{feature_name}/` directory
3. Follow: Three-phase workflow
   - Phase 1: `requirements.md`
   - Phase 2: `design.md`
   - Phase 3: `tasks.md`

#### Understand Architecture
1. Read: `.kiro/steering/flutter-bloc-patterns.md`
2. Review: `docs/ai-agents/AI_AGENT_CONTEXT.md`
3. Check: Existing code patterns

#### Implement a Feature
1. Review: Spec's `design.md`
2. Read: `.kiro/steering/flutter-bloc-patterns.md`
3. Execute: Tasks from `tasks.md`
4. Run: `melos genAlls && dart format lib/`

#### Get Quick Reference
1. Read: `.kiro/QUICK_START.md`
2. Or: `.kiro/README.md`

#### Understand Spec Workflow
1. Read: `.kiro/specs/README.md`
2. Review: `.kiro/steering/spec-guidelines.md`

#### Find Code Patterns
1. Check: `.kiro/steering/flutter-bloc-patterns.md`
2. Or: `docs/ai-agents/AI_AGENT_CONTEXT.md`

---

## 📖 Reading Paths

### Path 1: Quick Start (5 minutes)
```
docs/kiro/KIRO_SETUP_COMPLETE.md
    ↓
.kiro/QUICK_START.md
    ↓
Ready to create spec!
```

### Path 2: Thorough (20 minutes)
```
docs/kiro/KIRO_SETUP_COMPLETE.md
    ↓
.kiro/README.md
    ↓
.kiro/specs/README.md
    ↓
.kiro/steering/flutter-bloc-patterns.md
    ↓
Ready to create comprehensive spec!
```

### Path 3: Complete (45 minutes)
```
docs/kiro/KIRO_SETUP_COMPLETE.md
    ↓
.kiro/README.md
    ↓
.kiro/SETUP_SUMMARY.md
    ↓
.kiro/specs/README.md
    ↓
.kiro/steering/flutter-bloc-patterns.md
    ↓
.kiro/steering/spec-guidelines.md
    ↓
docs/ai-agents/AI_AGENT_CONTEXT.md
    ↓
Ready for advanced spec creation!
```

---

## 🎯 Key Concepts

### EARS Patterns (Requirements)
Requirements must follow one of six patterns:
- **Ubiquitous**: `THE <system> SHALL <response>`
- **Event-driven**: `WHEN <trigger>, THE <system> SHALL <response>`
- **State-driven**: `WHILE <condition>, THE <system> SHALL <response>`
- **Unwanted event**: `IF <condition>, THEN THE <system> SHALL <response>`
- **Optional feature**: `WHERE <option>, THE <system> SHALL <response>`
- **Complex**: Combination of above patterns

### Correctness Properties (Design)
Each property should:
- Use universal quantification ("for all" or "for any")
- Reference specific requirements
- Be implementable as automated test
- Validate across many generated inputs

### MVI Pattern (Code)
```
User Action → Intent → BLoC → State + Side Effects → UI Update
```

### Architecture Layers
```
Domain: Business logic, entities, repositories (abstract)
Data: API clients, models, repository implementations
Presentation: UI, BLoC, pages, widgets
```

---

## ✅ Checklist: Before You Start

- [ ] Read `docs/kiro/KIRO_SETUP_COMPLETE.md`
- [ ] Read `.kiro/QUICK_START.md` or `.kiro/README.md`
- [ ] Understand EARS patterns
- [ ] Understand MVI pattern
- [ ] Know where to put code
- [ ] Ready to create spec!

---

## 🔗 Quick Links

### Essential Files
- 🚀 **Setup Complete**: `docs/kiro/KIRO_SETUP_COMPLETE.md`
- 📍 **This Index**: `docs/kiro/KIRO_INDEX.md`
- ⚡ **Quick Start**: `.kiro/QUICK_START.md`
- 📖 **Overview**: `.kiro/README.md`

### Steering Files
- 🏗️ **Architecture**: `.kiro/steering/flutter-bloc-patterns.md`
- 📝 **Spec Workflow**: `.kiro/steering/spec-guidelines.md`

### Specs
- 📊 **Specs Index**: `.kiro/specs/README.md`
- 📋 **Create Spec**: `.kiro/specs/{feature_name}/`

### Project Documentation
- 🤖 **AI Agent Context**: `docs/ai-agents/AI_AGENT_CONTEXT.md`
- 📚 **Implementation Guide**: `docs/development/IMPLEMENTATION_GUIDE.md`
- 🏛️ **Architecture Guide**: `docs/architecture/ARCHITECTURE.md`

---

## 📊 Setup Status

| Component | Status | Files |
|-----------|--------|-------|
| Directory Structure | ✅ | 4 directories |
| Steering Files | ✅ | 2 files |
| Configuration | ✅ | 1 file |
| Documentation | ✅ | 8 files |
| **Total** | ✅ | **12 files** |

---

## 🎓 Learning Path

### Day 1: Understanding
```
1. Read docs/kiro/KIRO_SETUP_COMPLETE.md
2. Read .kiro/QUICK_START.md
3. Read .kiro/README.md
4. Understand EARS patterns
5. Understand MVI pattern
```

### Day 2: Practice
```
1. Read .kiro/specs/README.md
2. Create first spec directory
3. Write requirements.md
4. Write design.md
5. Write tasks.md
```

### Day 3: Implementation
```
1. Read .kiro/steering/flutter-bloc-patterns.md
2. Review spec's design.md
3. Execute tasks incrementally
4. Write tests alongside code
5. Run code generation
```

---

## 🆘 Getting Help

### For Questions About
- **Getting started**: `docs/kiro/KIRO_SETUP_COMPLETE.md` or `.kiro/QUICK_START.md`
- **Overview**: `.kiro/README.md`
- **Specs**: `.kiro/specs/README.md`
- **Architecture**: `.kiro/steering/flutter-bloc-patterns.md`
- **Workflow**: `.kiro/steering/spec-guidelines.md`
- **Code patterns**: `docs/ai-agents/AI_AGENT_CONTEXT.md`
- **Implementation**: `docs/development/IMPLEMENTATION_GUIDE.md`

### Documentation Hierarchy
```
1. Quick Start (.kiro/QUICK_START.md)
   ↓
2. Overview (.kiro/README.md)
   ↓
3. Detailed Guides (.kiro/steering/*, .kiro/specs/README.md)
   ↓
4. Project Documentation (docs/*)
```

---

## 🎯 Next Steps

### Option 1: Quick Start (5 min)
```bash
1. Read: docs/kiro/KIRO_SETUP_COMPLETE.md
2. Read: .kiro/QUICK_START.md
3. Create: First spec
```

### Option 2: Thorough (20 min)
```bash
1. Read: docs/kiro/KIRO_SETUP_COMPLETE.md
2. Read: .kiro/README.md
3. Read: .kiro/specs/README.md
4. Create: Feature spec
```

### Option 3: Complete (45 min)
```bash
1. Read: All .kiro/ files
2. Review: docs/ai-agents/
3. Create: Comprehensive spec
```

---

## 📝 Creating Your First Spec

### Step 1: Create Directory
```bash
mkdir -p .kiro/specs/my-feature-name
```

### Step 2: Create requirements.md
```markdown
# Requirements: My Feature

## Glossary
- **System**: BLOC Digital Wallet
- **User**: Wallet owner

## Requirements

### Requirement 1: Feature Name

**User Story:** As a user, I want [feature], so that [benefit]

#### Acceptance Criteria

1. WHEN [event], THE System SHALL [response]
```

### Step 3: Create design.md
```markdown
# Design: My Feature

## Architecture
[Component design]

## Correctness Properties

Property 1: [Universal property]
- For all [inputs], [property] should hold
- Validates: Requirements 1.1
```

### Step 4: Create tasks.md
```markdown
# Implementation Plan: My Feature

## Tasks

- [ ] 1. Implement core logic
  - _Requirements: 1.1_

- [ ]* 1.1 Write property test
  - **Property 1: [Property name]**
  - **Validates: Requirements 1.1**
```

---

## 🎉 You're Ready!

The Kiro instrumentation system is complete and ready for use.

**Start with**: `docs/kiro/KIRO_SETUP_COMPLETE.md` or `.kiro/QUICK_START.md`

**Then**: Create your first feature spec!

---

**Status**: ✅ Ready for Spec-Driven Development  
**Date**: January 14, 2026  
**Project**: BLOC Digital Wallet  

**Next**: Read `docs/kiro/KIRO_SETUP_COMPLETE.md` 🚀
