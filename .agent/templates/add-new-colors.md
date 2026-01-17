# Task Prompt Template: Add New Colors

**Template Type**: Template E - Add New Colors
**Use Case**: Adding new color definitions to the Design System
**Project**: bloc_digital_wallet

---

## 📋 Template Structure

```markdown
TASK: Add new colors to Design System

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Design System Update
GOAL: Implement new colors into the project's strict Design System workflow.

INPUT COLORS:
[Paste colors here, e.g.]
<color name="brand_primary">#007BFF</color>

⚠️ MANDATORY RULES:
[ ] **Color Usage Workflow**: Follow the strict 4-step workflow:
    1. **Define**: Add to `assets/colors/colors.xml`
    2. **Expose**: Add to `AppThemes` in `lib/config/theme/app_themes.dart` (fields, constructor, copyWith, lerp, light/dark instances)
    3. **Generate**: Run `melos genAlls`
    4. **Use**: Access via `context.appThemes.colorName`
[ ] **Naming**: Convert snake_case (xml) to camelCase (dart)
[ ] **Verification**: Ensure `flutter analyze` passes

TESTING:
[ ] Verify `colors.gen.dart` is updated
[ ] Verify `app_themes.tailor.dart` is updated
[ ] Verify new colors are accessible via `context.appThemes`

```

---

## 🎯 Example: Add 'True Blue' Palette

```markdown
TASK: Add 'True Blue' color palette

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Design System Update
GOAL: Add the new 'True Blue' color scale to the application theme.

INPUT COLORS:
<color name="true_blue_0">#FAFDFF</color>
<color name="true_blue_100">#037DD6</color>

⚠️ MANDATORY RULES:
[ ] **Color Usage Workflow**: Follow the strict 4-step workflow:
    1. **Define**: Add colors to `assets/colors/colors.xml`
    2. **Expose**: Update `AppThemes` in `lib/config/theme/app_themes.dart`:
       - Add `final Color trueBlue0;`
       - Add `final Color trueBlue100;`
       - Update constructor, copyWith, lerp
       - Initialize in `AppThemes.light` and `AppThemes.dark`
    3. **Generate**: Run `melos genAlls`
    4. **Use**: Access via `context.appThemes.trueBlue0`

🛠 MISSION:
1. UPDATE `assets/colors/colors.xml`:
   [ ] Insert new color tags

2. UPDATE `lib/config/theme/app_themes.dart`:
   [ ] Add fields
   [ ] Update boilerplate
   [ ] Initialize in themes

3. GENERATE:
   [ ] Run `melos genAlls`

4. VERIFY:
   [ ] Check `flutter analyze`

```
