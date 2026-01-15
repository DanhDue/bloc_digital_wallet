---
inclusion: always
---

# Spec-Driven Development Guidelines

This project uses spec-driven development with Kiro to create features systematically.

## Spec Workflow

Each feature spec consists of three documents:

### 1. Requirements (requirements.md)
- User stories with acceptance criteria
- EARS patterns for requirement structure
- Glossary of terms
- Clear, testable acceptance criteria

### 2. Design (design.md)
- Architecture and component design
- Data models and interfaces
- Correctness properties (for property-based testing)
- Error handling strategy
- Testing strategy

### 3. Tasks (tasks.md)
- Implementation checklist
- Incremental coding steps
- Property-based test tasks
- Checkpoint validations

## Creating a New Spec

1. **Identify feature name** (kebab-case, e.g., `wallet-management`)
2. **Gather requirements** - User stories and acceptance criteria
3. **Design the solution** - Architecture, components, data models
4. **Create implementation plan** - Discrete coding tasks
5. **Execute tasks** - Implement incrementally with testing

## Spec File Locations

All specs are stored in `.kiro/specs/{feature_name}/`:
- `requirements.md` - Feature requirements
- `design.md` - Technical design
- `tasks.md` - Implementation tasks

## Property-Based Testing

Each correctness property in the design should have:
- A universal quantification statement ("for all" or "for any")
- Reference to requirements it validates
- Implementation as a property-based test during task execution

## Best Practices

1. **Requirements First**: Always start with clear requirements
2. **Design Review**: Get design approved before implementation
3. **Incremental Tasks**: Break implementation into small, testable steps
4. **Test Early**: Include property tests close to implementation
5. **Checkpoint Validation**: Verify progress at key milestones

## Integration with Flutter BLOC

When creating specs for this project:

1. **Requirements** should reference MVI pattern components
2. **Design** should specify which layer (domain/data/presentation)
3. **Tasks** should follow the feature generation pattern
4. **Testing** should include both unit and property-based tests

## Code Generation

After implementing a feature from spec:
```bash
melos genAlls  # Generate all code
dart format lib/  # Format code
flutter analyze --no-fatal-infos  # Verify no issues
```

## Documentation

Link specs to existing documentation:
- Reference [AI Agent Context](docs/ai-agents/AI_AGENT_CONTEXT.md) for patterns
- Use [Implementation Guide](docs/development/IMPLEMENTATION_GUIDE.md) for examples
- Follow [Architecture Guide](docs/architecture/ARCHITECTURE.md) for layer rules
