# Design Spec: Documentation Restructure — Flutter Super App Template

**Date**: 2026-09-16  
**Author**: brainstorming session  
**Status**: Approved — ready for epic-designer  

---

## 1. Background & Problem

The `docs/` directory currently has 13 files across 5 folders. After auditing all docs and 8 epics in `.devtool/epic/`, four structural problems were identified:

1. **Cheat Sheet rules are scattered** inside guide docs (`QUICK_REFERENCE`, `THEME_TAILOR_GUIDE`, `SLANG_GUIDE`) instead of being in a dedicated source that quality audit skills can reference.
2. **Rich technical analysis is locked in `.devtool/epic/`** — 5 epics contain deep architectural decisions (logging, governance, deeplink, resilience, OTA localization) that developers cannot easily discover. Only AI agents navigate `.devtool/` naturally.
3. **Empty folders** — `system-design/` and `environment/` each contain only 1 file.
4. **`/epic-lifecycle` is under-introduced** — 4 lines at the bottom of README, not the prominent workflow entry point it should be.

Additionally, the project lacks a consolidated **Super App Requirements** document that maps the governance pillars to concrete implemented features.

---

## 2. Goals

- Restructure `docs/` into 4 clear categories: Architecture, Technical Analysis, Tool Guides, Cheat Sheets
- Distill epic HLDs (full content) into `docs/technical-analysis/` — move HLD files out of `.devtool/epic/`, leaving only task files there
- Create `docs/cheat-sheets/FLUTTER_QUALITY_RULES.md` from 5 sources, as input for quality audit skills
- Create `docs/technical-analysis/SUPER_APP_REQUIREMENTS.md` mapping requirements to implementations
- Give `/epic-lifecycle` a prominent, dedicated section in `docs/README.md`
- Keep en+vi bilingual files separate (no merge)
- No content loss: every important concept finds a clear, discoverable home

---

## 3. Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Bilingual strategy | Keep en+vi separate | Clean, no interleaved content |
| Technical analysis depth | Full HLD copy | Comprehensive — no information loss |
| Epic HLD location | Move into docs/ | Discoverability for developers, not just agents |
| Cheat-sheets timing | Create now, in same epic | Immediate value for quality skills |

---

## 4. Target File Structure

```
docs/
├── README.md                                    # UPDATE: new nav + epic-lifecycle section
│
├── architecture/                                # [CAT 1] Architecture docs
│   ├── ARCHITECTURE.md                          # KEEP unchanged (canonical)
│   ├── NETWORKING.md                            # KEEP unchanged
│   └── REFRESH_TOKEN_DESIGN.md                  # MOVE from system-design/refresh_token.md
│
├── technical-analysis/                          # [CAT 2] NEW folder
│   ├── SUPER_APP_REQUIREMENTS.md                # NEW — requirements + implementations map
│   ├── LOGGING_SYSTEM.en.md                     # MOVE from logging_refactor/logging_refactor.en.md
│   ├── LOGGING_SYSTEM.vi.md                     # MOVE from logging_refactor/logging_refactor.vi.md
│   ├── SUPER_APP_GOVERNANCE.en.md               # MOVE from super_app_governance/super_app_governance.en.md
│   ├── SUPER_APP_GOVERNANCE.vi.md               # MOVE from super_app_governance/super_app_governance.vi.md
│   ├── DEEPLINK_ENGINE.en.md                    # MOVE from deeplink_router_engine/deeplink_router_engine.en.md
│   ├── DEEPLINK_ENGINE.vi.md                    # MOVE from deeplink_router_engine/deeplink_router_engine.vi.md
│   ├── RESILIENCE_AND_MEMORY.en.md              # MOVE from super_app_resilience_and_memory/super_app_resilience_and_memory.en.md
│   └── RESILIENCE_AND_MEMORY.vi.md              # MOVE from super_app_resilience_and_memory/super_app_resilience_and_memory.vi.md
│
├── getting-started/                             # [CAT 3] Template guides
│   ├── create-new-project-from-template.en.md   # KEEP unchanged
│   ├── create-new-project-from-template.vi.md   # KEEP unchanged
│   ├── template-usage-guide.en.md               # KEEP unchanged
│   ├── template-usage-guide.vi.md               # KEEP unchanged
│   └── QUICK_REFERENCE.md                       # SLIM: remove arch overlap, keep commands + Mason
│
├── development/                                 # [CAT 3] Tool guides
│   ├── MELOS_COMMANDS.md                        # KEEP unchanged
│   ├── THEME_TAILOR_GUIDE.md                    # TRIM: keep how-to, extract do/dont → cheat-sheets
│   ├── SLANG_LOCALIZATION_GUIDE.md              # TRIM: keep how-to, extract do/dont → cheat-sheets
│   └── ENVIRONMENT_SETUP.md                     # MOVE from environment/ (delete that folder)
│
└── cheat-sheets/                                # [CAT 4] NEW folder
    └── FLUTTER_QUALITY_RULES.md                 # NEW — consolidated rules → feed quality skills
```

### `.devtool/epic/` after restructure

HLD files (both `.en.md` and `.vi.md`) move to `docs/technical-analysis/`. Each epic directory retains only:
- Design spec files (`YYYY-MM-DD-*.md`) — kept as source artifacts
- Task files (`task_*.md`) — execution artifacts
- BDD files (`bdd_scenarios.md`) — test specs

```
.devtool/epic/
├── logging_refactor/
│   ├── 2026-08-25-logging-module-design.md                    # KEEP (source spec)
│   ├── 2026-08-26-logger-native-bridge-headless-design.md     # KEEP (source spec)
│   ├── logging_refactor.en.md                                 # DELETE (moved to docs/)
│   └── logging_refactor.vi.md                                 # DELETE (moved to docs/)
├── super_app_governance/
│   ├── 2026-08-26-super-app-governance-design.md              # KEEP (source spec)
│   ├── super_app_governance.en.md                             # DELETE (moved to docs/)
│   └── super_app_governance.vi.md                             # DELETE (moved to docs/)
├── deeplink_router_engine/
│   ├── 2026-09-11-external-deeplink-engine-design.md          # KEEP (source spec)
│   ├── deeplink_router_engine.en.md                           # DELETE (moved to docs/)
│   └── deeplink_router_engine.vi.md                           # DELETE (moved to docs/)
├── super_app_resilience_and_memory/
│   ├── 2026-09-11-super-app-resilience-and-memory-design.md   # KEEP
│   ├── bdd_scenarios.md                                        # KEEP (test specs)
│   ├── super_app_resilience_and_memory.en.md                  # DELETE (moved to docs/)
│   └── super_app_resilience_and_memory.vi.md                  # DELETE (moved to docs/)
├── flutter_super_app_template/
│   ├── [all design spec .md files]               # KEEP
│   ├── bdd_scenarios.md                          # KEEP
│   └── [task files]
├── settings_language_darkmode/
│   ├── 2026-09-06-settings-language-darkmode-design.md # KEEP
│   └── [task files]
├── settings_bugfixes/                            # Small — keep as-is (no HLD to move)
└── template_flutter/                             # Keep as-is (Planning)
```

---

## 5. New Files — Content Spec

### 5.1 `docs/technical-analysis/SUPER_APP_REQUIREMENTS.md`

A mapping document that answers: *"What does a Super App platform need, and what have we built?"*

**Structure:**
```
# Super App Requirements & Implementation Status

## 1. The 4-Pillar Governance Framework
For each pillar: requirement description, Flutter adaptation, implementation status

## Pillar 1: Decomposed Architecture (Container & Modules)
- Req 1.1: Host App as Container (auth, network, storage only) → Status: ✅ Implemented
- Req 1.2: Mini Apps as independent Dart packages → Status: ✅ Implemented

## Pillar 2: Centralized Communication & Routing
- Req 2.1: DeepLink Router Engine (blind modules) → Status: 🔄 In Progress (epic: deeplink_router_engine)
- Req 2.2: AppEventBus (stateless event bridge) → Status: ✅ Implemented

## Pillar 3: State Isolation
- Req 3.1: Local State per Mini App (MVI/BLoC) → Status: ✅ Implemented
- Req 3.2: Layered DI (GetIt + injectable) → Status: ✅ Implemented

## Pillar 4: Lifecycle Governance (CI/CD)
- Req 4.1: Sandbox Development (package-level standalone) → Status: ✅ Implemented
- Req 4.2: Module Boundary CI Gate → Status: ✅ Implemented (check_module_boundaries.sh)

## 5. Resilience & Memory Requirements
- OOM prevention (image downsampling) → Status: ✅ Implemented
- Mini App crash isolation → Status: ✅ Implemented
- OS memory pressure handling → Status: ✅ Implemented
- Offline-awareness → Status: ✅ Implemented

## 6. Logging & Observability Requirements
- Pluggable logging (swap backend without touching core) → Status: 📋 Planned (epic: logging_refactor)
- Per-module logging toggles → Status: 📋 Planned
- Headless native logging (no Flutter Engine) → Status: 📋 Planned
- W3C Trace Context → Status: 📋 Planned

## 7. Native Plugin Requirements (Tri-Platform Parity)
- Android: Pure Dagger2 + WorkManager (zero Flutter Engine) → Status: ✅ Implemented
- iOS: FactoryKit + BGTaskScheduler (zero Flutter Engine) → Status: ✅ Implemented
- Mason brick generation (pac_native_plugin, pac_add_native_ui) → Status: ✅ Implemented

## 8. Template & Developer Experience
- Dual-Mode (Enterprise/Lean) → Status: ✅ Implemented
- One-command project rename → Status: ✅ Implemented
- Mason bricks (pac_mvi_feature, pac_mvi_subfeature, etc.) → Status: ✅ Implemented
```

### 5.2 `docs/technical-analysis/LOGGING_SYSTEM.en.md` + `LOGGING_SYSTEM.vi.md`

- Move `.devtool/epic/logging_refactor/logging_refactor.en.md` → `docs/technical-analysis/LOGGING_SYSTEM.en.md`
- Move `.devtool/epic/logging_refactor/logging_refactor.vi.md` → `docs/technical-analysis/LOGGING_SYSTEM.vi.md`
- Add header note to both: `> Source: epic/logging_refactor — Status: Planning`
- Delete originals from `.devtool/epic/logging_refactor/`

### 5.3 `docs/technical-analysis/SUPER_APP_GOVERNANCE.en.md` + `SUPER_APP_GOVERNANCE.vi.md`

- Move `.devtool/epic/super_app_governance/super_app_governance.en.md` → `docs/technical-analysis/SUPER_APP_GOVERNANCE.en.md`
- Move `.devtool/epic/super_app_governance/super_app_governance.vi.md` → `docs/technical-analysis/SUPER_APP_GOVERNANCE.vi.md`
- Add header note to both: `> Source: epic/super_app_governance — Status: Complete`
- Delete originals from `.devtool/epic/super_app_governance/`

### 5.4 `docs/technical-analysis/DEEPLINK_ENGINE.en.md` + `DEEPLINK_ENGINE.vi.md`

- Move `.devtool/epic/deeplink_router_engine/deeplink_router_engine.en.md` → `docs/technical-analysis/DEEPLINK_ENGINE.en.md`
- Move `.devtool/epic/deeplink_router_engine/deeplink_router_engine.vi.md` → `docs/technical-analysis/DEEPLINK_ENGINE.vi.md`
- Add header note to both: `> Source: epic/deeplink_router_engine — Status: Todo`
- Delete originals from `.devtool/epic/deeplink_router_engine/`

### 5.5 `docs/technical-analysis/RESILIENCE_AND_MEMORY.en.md` + `RESILIENCE_AND_MEMORY.vi.md`

- Move `.devtool/epic/super_app_resilience_and_memory/super_app_resilience_and_memory.en.md` → `docs/technical-analysis/RESILIENCE_AND_MEMORY.en.md`
- Move `.devtool/epic/super_app_resilience_and_memory/super_app_resilience_and_memory.vi.md` → `docs/technical-analysis/RESILIENCE_AND_MEMORY.vi.md`
- Add header note to both: `> Source: epic/super_app_resilience_and_memory — Status: Completed`
- Delete originals from `.devtool/epic/super_app_resilience_and_memory/`

---

### 5.6 `docs/cheat-sheets/FLUTTER_QUALITY_RULES.md`

Consolidated from 5 sources. Structure:

```
# Flutter Quality Rules — Cheat Sheet

> This document is the authoritative source for quality audit skills:
> d3nexus:flutter-ui-audit, d3nexus:architecture-audit,
> d3nexus:code-health-audit, d3nexus:security-audit

## 1. MVI Naming Conventions          ← from QUICK_REFERENCE §Naming
## 2. Architecture Layer Rules         ← from QUICK_REFERENCE §Arch Rules + ARCHITECTURE §V.4
## 3. Common Anti-Patterns             ← from QUICK_REFERENCE §Common Mistakes
## 4. Theme Usage Rules                ← from THEME_TAILOR_GUIDE §What NOT to Do
## 5. Localization Rules               ← from SLANG_LOCALIZATION_GUIDE
## 6. Networking Rules                 ← from NETWORKING.md §Incorrect Pattern
## 7. Security Rules                   ← from system-design/refresh_token.md
## 8. Dependency Injection Rules       ← from NETWORKING.md §DI Rules + ARCHITECTURE
```

---

## 6. Modifications to Existing Files

### 6.1 `docs/getting-started/QUICK_REFERENCE.md` — Slim down

**Remove** (already in ARCHITECTURE.md — link instead):
- §Core Concepts (Action/State/Event table and flow diagram)
- §Architecture Rules table (§Architecture Rules section)
- §Common Mistakes table → move to cheat-sheets

**Keep**:
- §Theme & Styling Rules quick reference (commands only, not explanation)
- §File Structure Template
- §Quick Start Commands (all bash commands — Dual-Mode, Mason, Code Gen)
- §Code Templates (Entity, Repository, UseCase, Model, Action, State, Event, BLoC, Page)
- §Naming Conventions (keep as quick lookup table)
- §Dependency Injection (code snippets)
- §Testing Template
- §Essential Packages (pubspec.yaml reference)
- §Documentation links

### 6.2 `docs/development/THEME_TAILOR_GUIDE.md` — Trim

**Move to cheat-sheets** (❌/✅ do/don't blocks):
- §What NOT to Do section
- `❌ WRONG`/`✅ CORRECT` code blocks

**Keep**:
- §Available Theme Properties (full API reference)
- §How to Add New Theme Properties
- §Dark Mode support notes

### 6.3 `docs/development/SLANG_LOCALIZATION_GUIDE.md` — Trim

**Move to cheat-sheets** (❌/✅ do/don't blocks):
- `❌`/`✅` usage blocks

**Keep**:
- §Project Structure
- §Quick Start (accessing translations)
- §Adding New Translations (step-by-step)
- §Slang configuration
- §Pluralization, Parameters, Gender

### 6.4 `docs/README.md` — Major update

**Add**:
- New section for `technical-analysis/` and `cheat-sheets/` folders
- Prominent **`/epic-lifecycle`** section with table (tri-platform: Flutter + Android + iOS)
- Link to `SUPER_APP_REQUIREMENTS.md`

**Update**:
- Folder tree diagram to match new structure

---

## 7. Verification Plan

### Automated
```bash
# Verify no broken internal links
find docs/ -name "*.md" -exec grep -l "\](../" {} \; | head -20

# Verify epic HLD files are removed from .devtool after move
ls .devtool/epic/logging_refactor/
ls .devtool/epic/super_app_governance/
ls .devtool/epic/deeplink_router_engine/
ls .devtool/epic/super_app_resilience_and_memory/

# Verify new folders exist
ls docs/technical-analysis/
ls docs/cheat-sheets/

# Git status — no files lost
git status --short docs/
```

### Manual
- Read `docs/README.md` and confirm all links navigate correctly
- Confirm `SUPER_APP_REQUIREMENTS.md` covers all 8 epics
- Confirm `FLUTTER_QUALITY_RULES.md` is referenced (in comments) in the 4 audit skill files
- Confirm no content duplication between QUICK_REFERENCE and ARCHITECTURE

---

## 8. Task Breakdown (for epic-designer)

Suggested task split for Kanban:

| # | Task | Files Touched |
|---|------|--------------|
| 1 | Create `technical-analysis/` + move 4 epic HLDs (`.en.md` + `.vi.md`) | `docs/technical-analysis/*.en.md`, `docs/technical-analysis/*.vi.md`, `.devtool/epic/*/` (delete originals) |
| 2 | Create `SUPER_APP_REQUIREMENTS.md` | `docs/technical-analysis/SUPER_APP_REQUIREMENTS.md` |
| 3 | Create `cheat-sheets/FLUTTER_QUALITY_RULES.md` | `docs/cheat-sheets/FLUTTER_QUALITY_RULES.md` |
| 4 | Slim `QUICK_REFERENCE.md` | `docs/getting-started/QUICK_REFERENCE.md` |
| 5 | Trim `THEME_TAILOR_GUIDE.md` + `SLANG_LOCALIZATION_GUIDE.md` | `docs/development/*.md` |
| 6 | Move `refresh_token.md` + consolidate `environment/` folder | `docs/architecture/`, `docs/development/` |
| 7 | Update `docs/README.md` (new nav + epic-lifecycle section) | `docs/README.md` |
| 8 | Verify links + commit | All docs |
