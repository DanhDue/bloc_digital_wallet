# bloc_digital_wallet — Agent Entry Point

Flutter super-app monorepo (Clean Architecture + MVI, BLoC, Melos, FVM, Mason).

All agent customizations live in [`.agents/`](.agents/README.md) — see that index for the full
map of rules and skills, and for which runtime loads what.

## Rules

@.agents/rules/CRITICAL_RULES.md
@.agents/rules/CLAUDE.md

> The `@` lines above are Claude Code imports. Antigravity ignores them and discovers
> `.agents/rules/*.md` natively, so the rules load in both runtimes without being duplicated.

## Orchestration

| Situation | Start here |
|---|---|
| Epic-scale work (multiple components, needs HLD + task breakdown) | `epic-lifecycle` skill — owns the 4 stages and 4 approval gates |
| Any new feature, component, or behaviour change | `brainstorming` skill |
| A bug, test failure, or unexpected behaviour | `systematic-debugging` skill |
| Finished a workflow or skill | `quality_check` skill (mandatory — see CRITICAL_RULES) |

## Build Environment

Optimized for Dev Containers (`.devcontainer/devcontainer.json`). Initialize with
`bash .devcontainer/setup.sh`, which installs FVM, Mason, Melos and Ruby and decodes
`SECURE_FILES` into `secureFiles/`.

Manual secret decode, if the automatic step fails:

```bash
echo "$SECURE_FILES" | base64 -d | tar -xz
```

Generate that value locally with `bash scripts/secrets_ops.sh encode`.

## CLI

- `fvm flutter` — Flutter SDK (always prefix with `fvm`)
- `melos` — multi-package workspace management
- `mason` — feature generation from `bricks/`

## Architecture

- **State management**: flutter_bloc (MVI)
- **DI**: GetIt + Injectable
- **Persistence**: Isar / SharedPreferences
- **API**: Retrofit / Dio
