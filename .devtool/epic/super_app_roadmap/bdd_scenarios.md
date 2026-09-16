# BDD Scenarios: Super App Production Roadmap & 4-Pillar Governance Synthesis

Epic: [super_app_roadmap](super_app_roadmap.en.md)

---

## UC-1: Evaluate Super App Governance & Codebase Reality

### Scenario 1.1 — Developer reads 4-Pillar Scorecard in SUPER_APP_OVERVIEW.md
```gherkin
[Tier C - Integration]
Given a developer opens docs/technical-analysis/SUPER_APP_OVERVIEW.md
When they navigate to the Super App Maturity Scorecard section
Then they find all 4 core governance pillars evaluated with maturity percentages
And Pillar 1 (Container & Modules) scores >= 95%
And Pillar 2 (Communication & Routing) scores >= 90%
And Pillar 3 (State Isolation) scores >= 90%
And Pillar 4 (Lifecycle Governance) scores >= 75%
And concrete evidence from the bloc_digital_wallet codebase is cited for each score
```

### Scenario 1.2 — Architect studies DFM vs Flutter Single Binary Gap Analysis
```gherkin
[Tier C - Integration]
Given an architect reviews SUPER_APP_OVERVIEW.md
When they read the Gap Analysis section
Then they find a clear technical distinction between Android Dynamic Feature Modules (DFM) and Flutter AOT Single Binary compilation
And the document explains App Store compliance constraints on runtime code execution
And the document highlights package modularization and OTA dynamic localization as the practical Flutter equivalent
```

### Scenario 1.3 — Team evaluates Dual-Mode Template Positioning
```gherkin
[Tier C - Integration]
Given a developer examines the template architecture in SUPER_APP_OVERVIEW.md
When they check the Dual-Mode section
Then they find instructions and architecture seams for both:
  | Mode | Characteristics | Command |
  | Lean Mode | 2 tabs (Home, Settings), zero skeleton overhead | ./scripts/configure_mode.sh lean |
  | Enterprise Mode | 3 tabs (Home, Scanner, Settings), full super app seams | ./scripts/configure_mode.sh enterprise |
And the document links directly to scripts/configure_mode.sh
```

---

## UC-2: Consult Flutter Production Strategy in FLUTTER_PRODUCTION_ROADMAP.md

### Scenario 2.1 — Memory Management & Scope Hygiene
```gherkin
[Tier A - Unit]
Given a developer consults FLUTTER_PRODUCTION_ROADMAP.md Section II
When they inspect memory management rules
Then they find strict guidelines for:
  | Area | Rule |
  | BLoC Scope | StreamSubscription instances must be cancelled in close() |
  | Allocation Churn | const constructor enforcement, buildWhen predicate usage |
  | RAM Image Cap | PaintingBinding imageCache cap at 25% heap, memCacheWidth downsampling |
  | OS Memory Pressure | WidgetsBindingObserver.didHaveMemoryPressure handling |
```

### Scenario 2.2 — Permission Management & Domain Purity
```gherkin
[Tier A - Unit]
Given a developer checks Section III of FLUTTER_PRODUCTION_ROADMAP.md
When they examine the Clean Architecture boundary rules
Then they find a strict prohibition on importing package:permission_handler in domain layers
And Domain layers must use pure Dart PermissionStatus abstractions
And the document mandates permissionless PhotoPicker (image_picker) for media selection
```

### Scenario 2.3 — Runtime Resilience: LRU Hibernation & Crash Isolation
```gherkin
[Tier A - Unit]
Given an engineer reviews Section IV of FLUTTER_PRODUCTION_ROADMAP.md
When they inspect the 3 vital runtime problems
Then they find:
  | Problem | Architectural Solution |
  | LRU Memory Bloat | Active mini app hibernation with state snapshot save/restore |
  | Mini App Crash | MiniAppErrorBoundary with graceful fallback screen |
  | Critical Bug at Runtime | DeepLinkCoordinator Router Kill-Switch via Remote Config |
```

---

## UC-3: Audit & Track Governance Requirements in SUPER_APP_REQUIREMENTS.md

### Scenario 3.1 — Verify Total Requirement Count and New Domains
```gherkin
[Tier C - Integration]
Given an auditor inspects docs/technical-analysis/SUPER_APP_REQUIREMENTS.md
When they count the total requirements across all domains
Then the catalog contains at least 58 requirements across 11 domains
And Domain 9 covers Permission Management (Requirements 9.1 to 9.4)
And Domain 10 covers Fintech Security Hardening (Requirements 10.1 to 10.4)
And Domain 11 covers Production Resilience & Process Death (Requirements 11.1 to 11.5)
```

### Scenario 3.2 — Documentation Navigation & Zero Broken Links
```gherkin
[Tier C - Integration]
Given all files in the epic are written
When scanning docs/README.md and all files under docs/technical-analysis/
Then all relative links resolve to existing files
And no broken markdown links exist
And melos run analyze reports zero issues
```
