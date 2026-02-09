# Melos Commands Guide

This document explains how to use melos commands for code generation in this monorepo.

## Quick Reference

| Command | Description |
|---------|-------------|
| `melos genAlls` | Full project generation (all packages + root) |
| `melos genFeature <pkg>` | Package gen: slang → build_runner → format |
| `melos rebuildAndFormat` | Root app gen: build_runner → format |
| `melos integrateFeatureToApp <pkg>` | Full feature integration to root app |

---

## Commands

### `melos genAlls`
Runs the complete generation pipeline for all packages and root app.

```bash
melos genAlls
```

**Steps:**
1. Generate translations (slang) for all packages
2. Build UI Kit assets
3. Build all other packages (build_runner)
4. Build Root App
5. Generate Root Assets (fluttergen)
6. Formatting & License Headers
7. Final Analysis
8. Stage all changes

---

### `melos genFeature <package_name>`
Generate code for a **single package** (translations, models, formatting).

```bash
melos genFeature wallet
melos genFeature settings
melos genFeature ui_kit
```

**Steps:**
1. 📝 Generate translations (if `slang.yaml` exists)
2. 🏗️ Run build_runner (freezed, retrofit, etc.)
3. ✨ Format code with 99 line length

**Use when:** You modified models/entities in a package and need to regenerate code.

---

### `melos rebuildAndFormat`
Rebuild the **root app** (`lib/` directory).

```bash
melos rebuildAndFormat
```

**Steps:**
1. 🏗️ Run build_runner on root app
2. ✨ Format root app code

**Use when:** You modified routes, DI, or other root app code that needs regeneration.

---

### `melos integrateFeatureToApp <package_name>`
**Full integration** of a new feature package into the root app.

```bash
melos integrateFeatureToApp wallet
```

**Steps:**
1. Generate package code (via `genFeature`)
2. Build Root App (router, injection, etc.)
3. Generate Root Assets (fluttergen)
4. Formatting & License Headers
5. Final Analysis
6. Stage all changes (git add)

**Use when:** After creating a new feature package with `pac_mvi_feature` brick.

---

## Common Workflows

### After modifying a model in a package
```bash
melos genFeature wallet
```

### After creating a new feature package
```bash
melos integrateFeatureToApp my_new_feature
```

### After modifying root app routes
```bash
melos rebuildAndFormat
```

### Full project regeneration
```bash
melos genAlls
```

---

## Related Mason Bricks

These bricks automatically run the appropriate melos commands:

| Brick | Auto-runs |
|-------|-----------|
| `pac_mvi_feature` | `integrateFeatureToApp` |
| `pac_mvi_subfeature` | `genFeature` |
| `remove_pac_subfeature` | `genFeature` |
| `mvi_feature` | `rebuildAndFormat` |
| `mvi_subfeature` | `rebuildAndFormat` |
| `remove_feature` | `rebuildAndFormat` |
| `remove_subfeature` | `rebuildAndFormat` |
