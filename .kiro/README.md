# Kiro Configuration & Specs

This directory contains Kiro configuration and spec-driven development artifacts for the BLOC Digital Wallet project.

> **Quick Start**: New here? Read [INDEX.md](INDEX.md) for a complete overview, or [QUICK_START.md](QUICK_START.md) for a 5-minute guide.

## Directory Structure

```
.kiro/
├── INDEX.md                         # Master index and quick reference
├── README.md                        # This file - Main navigation
├── QUICK_START.md                   # 5-minute quick start guide
├── SETUP_SUMMARY.md                 # Setup documentation
├── settings/
│   └── mcp.json                    # MCP server configuration
├── steering/                        # Development rules (auto-included)
│   ├── flutter-bloc-patterns.md    # Flutter BLOC patterns (legacy)
│   ├── spec-guidelines.md          # Spec workflow guidelines
│   ├── project-conventions.md      # Critical conventions ⚠️
│   ├── mvi-architecture.md         # MVI pattern guide
│   └── mason-workflows.md          # Mason brick workflows
└── specs/                          # Feature specifications
    ├── README.md                   # Specs workflow guide
    └── {feature_name}/             # Individual feature specs
        ├── requirements.md         # Feature requirements
        ├── design.md              # Technical design
        └── tasks.md               # Implementation tasks
```

## Quick Navigation

### Essential Reading (Start Here)
- **[INDEX.md](INDEX.md)** - Master index with complete overview
- **[QUICK_START.md](QUICK_START.md)** - 5-minute quick start guide
- **[Project Conventions](steering/project-conventions.md)** - ⚠️ Critical rules (MUST READ)

### For Spec Creation
- **[Specs README](specs/README.md)** - How to create and manage specs
- **[Spec Guidelines](steering/spec-guidelines.md)** - Spec workflow and best practices

### For Development
- **[MVI Architecture](steering/mvi-architecture.md)** - MVI pattern implementation
- **[Mason Workflows](steering/mason-workflows.md)** - Feature generation with Mason
- **[Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)** - Legacy architecture reference

### For Implementation
- **[AI Agent Context](../docs/ai-agents/AI_AGENT_CONTEXT.md)** - Code patterns and templates
- **[Implementation Guide](../docs/development/IMPLEMENTATION_GUIDE.md)** - Step-by-step tutorial
- **[Architecture Guide](../docs/architecture/ARCHITECTURE.md)** - Detailed architecture

## Steering Files

Steering files provide context and rules for development:

### flutter-bloc-patterns.md
Provides:
- Layer organization rules
- MVI pattern flow
- File structure patterns
- Naming conventions
- Theme and localization rules
- Code generation requirements
- Testing requirements

**Use when**: Creating new code, following architecture patterns

### spec-guidelines.md
Provides:
- Spec workflow overview
- File locations
- Property-based testing guidelines
- Integration with Flutter BLOC
- Best practices

**Use when**: Creating new specs, planning features

## Specs Directory

The `specs/` directory contains feature specifications:

### Structure
Each feature has its own directory with three documents:
- `requirements.md` - User stories and acceptance criteria
- `design.md` - Technical design and correctness properties
- `tasks.md` - Implementation tasks and checklist

### Workflow
1. **Requirements Phase** - Define what the feature should do
2. **Design Phase** - Design how to implement it
3. **Tasks Phase** - Create implementation checklist
4. **Implementation Phase** - Execute tasks incrementally

### Creating a New Spec

```bash
# 1. Create feature directory
mkdir -p .kiro/specs/{feature_name}

# 2. Start with requirements gathering
# Create requirements.md with user stories and acceptance criteria

# 3. Design the solution
# Create design.md with architecture and correctness properties

# 4. Create implementation plan
# Create tasks.md with incremental coding steps

# 5. Execute tasks
# Implement feature following the task checklist
```

## MCP Configuration

The `settings/mcp.json` file configures Model Context Protocol servers:

```json
{
  "mcpServers": {
    "server_name": {
      "command": "command_to_run",
      "args": ["arg1", "arg2"],
      "env": {
        "ENV_VAR": "value"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

**Current servers**: None configured (add as needed)

## Integration with Project

### Architecture Rules
All code must follow:
- **Clean Architecture** (Domain/Data/Presentation layers)
- **MVI Pattern** (Intent → State → UI)
- **Feature-first organization**
- **Dependency injection** with get_it

### Code Generation
After implementing features:
```bash
melos genAlls                              # Generate all code
dart format lib/                           # Format code
flutter analyze --no-fatal-infos          # Verify no issues
```

### Testing
Include both:
- **Unit tests** - Specific examples and edge cases
- **Property-based tests** - Universal properties across inputs

## Best Practices

### For Specs
✅ Start with clear requirements  
✅ Use EARS patterns for requirements  
✅ Include correctness properties in design  
✅ Get approval at each phase  
✅ Reference existing patterns  

### For Code
✅ Follow steering file rules  
✅ Use theme/localization (never hardcode)  
✅ Follow MVI pattern  
✅ Write tests alongside code  
✅ Run code generation before committing  

### For Development
✅ Read relevant steering files first  
✅ Reference AI Agent documentation  
✅ Follow existing patterns  
✅ Test incrementally  
✅ Get user approval at phase boundaries  

## Documentation Map

```
Project Root
├── .kiro/                          # Kiro configuration (this directory)
│   ├── steering/                   # Development rules & guidelines
│   └── specs/                      # Feature specifications
├── docs/
│   ├── ai-agents/                  # AI agent documentation
│   │   ├── AI_AGENT_CONTEXT.md     # Architecture & patterns
│   │   ├── AI_AGENT_WORKFLOWS.md   # Step-by-step workflows
│   │   └── AI_AGENT_CHECKLIST.md   # Quick reference
│   ├── architecture/               # Architecture documentation
│   ├── development/                # Development guides
│   └── getting-started/            # Quick start guides
└── README.md                       # Project overview
```

## Common Tasks

### Create a New Feature Spec
1. Read [Specs README](specs/README.md)
2. Create `.kiro/specs/{feature_name}/` directory
3. Follow the three-phase workflow
4. Get approval at each phase

### Implement a Feature from Spec
1. Read [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)
2. Review the spec's design.md
3. Execute tasks from tasks.md incrementally
4. Run code generation and tests

### Add Development Rules
1. Update [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)
2. Or create new steering file
3. Reference in specs as needed

### Debug Architecture Issues
1. Check [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)
2. Review [AI Agent Context](../docs/ai-agents/AI_AGENT_CONTEXT.md)
3. Check existing code patterns
4. Reference [Architecture Guide](../docs/architecture/ARCHITECTURE.md)

## Key Concepts

### EARS Patterns
Requirements must follow one of six patterns:
- **Ubiquitous**: `THE <system> SHALL <response>`
- **Event-driven**: `WHEN <trigger>, THE <system> SHALL <response>`
- **State-driven**: `WHILE <condition>, THE <system> SHALL <response>`
- **Unwanted event**: `IF <condition>, THEN THE <system> SHALL <response>`
- **Optional feature**: `WHERE <option>, THE <system> SHALL <response>`
- **Complex**: Combination of above patterns

### Correctness Properties
Each property should:
- Use universal quantification ("for all" or "for any")
- Reference specific requirements
- Be implementable as automated test
- Validate across many generated inputs

### MVI Pattern
```
User Action → Intent → BLoC → State + Side Effects → UI Update
```

## Resources

### Internal Documentation
- [Specs README](specs/README.md) - Spec workflow
- [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md) - Architecture rules
- [Spec Guidelines](steering/spec-guidelines.md) - Spec best practices

### Project Documentation
- [AI Agent Context](../docs/ai-agents/AI_AGENT_CONTEXT.md) - Code patterns
- [Implementation Guide](../docs/development/IMPLEMENTATION_GUIDE.md) - Tutorial
- [Architecture Guide](../docs/architecture/ARCHITECTURE.md) - Detailed architecture
- [Quick Reference](../docs/getting-started/QUICK_REFERENCE.md) - Code templates

### External Resources
- [Kiro Documentation](https://kiro.dev) - Kiro IDE documentation
- [Flutter Documentation](https://flutter.dev) - Flutter framework
- [BLoC Documentation](https://bloclibrary.dev) - BLoC pattern
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Architecture principles

## Getting Started

### First Time Setup
1. Read this README
2. Review [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)
3. Check [Specs README](specs/README.md)
4. Review project [Architecture Guide](../docs/architecture/ARCHITECTURE.md)

### Creating First Spec
1. Identify feature to build
2. Create `.kiro/specs/{feature_name}/` directory
3. Follow [Specs README](specs/README.md) workflow
4. Start with requirements gathering

### Implementing Feature
1. Review spec's design.md
2. Read [Flutter BLOC Patterns](steering/flutter-bloc-patterns.md)
3. Execute tasks from tasks.md
4. Run code generation and tests

## Questions?

- **Architecture questions**: See [Architecture Guide](../docs/architecture/ARCHITECTURE.md)
- **Pattern questions**: See [AI Agent Context](../docs/ai-agents/AI_AGENT_CONTEXT.md)
- **Spec questions**: See [Specs README](specs/README.md)
- **Development questions**: See [Implementation Guide](../docs/development/IMPLEMENTATION_GUIDE.md)

---

**Last Updated**: 2026-01-14  
**Version**: 1.0.0  
**Project**: BLOC Digital Wallet
