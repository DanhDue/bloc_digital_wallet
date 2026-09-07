---
name: aggregate_translations
description: Aggregate all translation JSON files from the app level and package level into a single directory for easy upload to a translation management system or backend.
---

# Aggregate Translations Skill

This skill provides a utility script to parse and merge all translation JSON files (`*.json` or `*.i18n.json`) across the application, specifically from:
- `assets/locales/` (Main App Level)
- `packages/*/assets/locales/` (Feature Package Level)

The script performs a deep merge of the JSON objects grouped by language code (derived from the filename, e.g., `en.i18n.json` -> `en.json`) and outputs the combined files. This is extremely useful for generating the final dynamic translation JSONs that need to be hosted on your backend.

## Usage

You can run the included Dart script directly from the project root:

```bash
dart .agents/skills/aggregate_translations/scripts/aggregate.dart [output_directory]
```

### Examples

**Output to the default directory (`build/aggregated_locales`):**
```bash
dart .agents/skills/aggregate_translations/scripts/aggregate.dart
```

**Output to a custom directory:**
```bash
dart .agents/skills/aggregate_translations/scripts/aggregate.dart assets/aggregated_locales
```
