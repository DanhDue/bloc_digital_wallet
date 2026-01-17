# Task Prompt Template: Update UI

**Template Type**: Template D - Update UI  
**Use Case**: Updating user interface, styling, or visual improvements  
**Project**: bloc_digital_wallet

---

## 📋 Template Structure

```markdown
TASK: Update UI for [screen/component]

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: UI Update
GOAL: [What UI changes to make in 1-2 sentences]

REQUIREMENTS:
- Changes: [Describe UI changes]
- **Figma Design**: [Provide Figma link if available]
  - **🎯 UI Development Strategy**:
    - **Source of Truth**: Figma design is the absolute authority for UI/UX
    - **Priority**: Use `figma-dev-mode-mcp-server` to fetch design specs BEFORE generating frontend code
    - **No Guessing**: Never guess colors, spacing, or font sizes - always reference Figma
    - Extract node ID from URL and use MCP tools to get exact specifications
- Design reference: [If available, attach design files]
- Responsive: [Mobile/Tablet requirements]
- Accessibility: [Any a11y requirements]

AFFECTED FILES:
@[mention UI files to update]

⚠️ MANDATORY RULES:
[ ] **Fetch Figma design FIRST** using `mcp_figma-dev-mode-mcp-server_get_design_context`
[ ] Use context.appThemes for ALL styling (never Theme.of(context))
[ ] Use context.t for ALL text (never hardcoded strings)
[ ] Match Figma specs exactly (colors, spacing, typography)
[ ] Follow Material Design 3 guidelines
[ ] Maintain existing functionality
[ ] Ensure responsive design
[ ] Test theme switching (light/dark)
[ ] Add translations (en & vi)

🛠 MISSION:
1. REVIEW: Current UI implementation
2. UPDATE: Apply new design/styling
3. VERIFY: Responsive, accessible, themed
4. TEST: Light/dark themes, multiple screen sizes

VERIFICATION:
[ ] UI matches design requirements
[ ] context.appThemes used for all colors/styles
[ ] context.t used for all text
[ ] No hardcoded colors or strings
[ ] Responsive on different screen sizes
[ ] Theme switching works (light/dark)
[ ] Translations added (en & vi)
[ ] Accessibility: proper semantics, contrast
[ ] Run: fvm flutter analyze --no-fatal-infos → 0 issues
```

---

## 🎯 Example 1: Update Login Page Design

```markdown
TASK: Update login page with new Material Design 3 styling

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: UI Update
GOAL: Redesign login page to use Material Design 3 components with improved visual hierarchy and modern styling

REQUIREMENTS:
- Changes: 
  - Replace old text fields with Material 3 styled fields
  - Update button styling to use FilledButton
  - Add logo and welcome text at top
  - Improve spacing and padding
  - Add subtle animations on field focus
  - Update color scheme to match app theme
- **Figma Design**: https://figma.com/design/example/wallet?node-id=1-5
  - **Node ID**: `1:5` (Login Screen)
  - **MCP Integration**: Fetch design context before implementation
- Design reference: Material Design 3 Login pattern
- Responsive: Works on phones (320px - 428px width)
- Accessibility: 
  - Proper labels for screen readers
  - Minimum 4.5:1 contrast ratio
  - Touch targets minimum 48x48dp

AFFECTED FILES:
@lib/features/authentication/presentation/pages/login_page.dart
@lib/features/authentication/presentation/widgets/auth_text_field.dart
@assets/locales/en.i18n.json
@assets/locales/vi.i18n.json

⚠️ MANDATORY RULES:
[ ] **Fetch Figma design FIRST**: Use `mcp_figma-dev-mode-mcp-server_get_design_context` with nodeId `1:5`
[ ] Use context.appThemes.primaryColor (not Theme.of(context).colorScheme.primary)
[ ] Use context.appThemes.bodyMedium (not Theme.of(context).textTheme.bodyMedium)
[ ] Use context.t.authWelcomeBack (not "Welcome Back" hardcoded)
[ ] Match Figma spacing, colors, and typography exactly
[ ] Follow Material Design 3 guidelines
[ ] Keep all existing functionality (login logic unchanged)
[ ] Test both light and dark themes
[ ] Add all new text to translations

🛠 MISSION:
1. **FETCH DESIGN SPECS**:
   [x] Use `mcp_figma-dev-mode-mcp-server_get_design_context` with nodeId: `1:5`
   [x] Review colors, spacing, typography from Figma
   [x] Note any component specifications

2. REVIEW:
   [x] Check current login_page.dart implementation
   [x] Identify hardcoded colors/strings
   [x] Review existing authentication logic
   [x] Check current translations

2. UPDATE:
   Phase 1: Update structure
   [x] Add logo section at top
   [x] Add welcome text below logo
   [x] Reorganize field layout
   [x] Update spacing using proper gaps
   
   Phase 2: Update styling
   [x] Replace TextField with Material 3 styled fields:
       - Use InputDecoration with filled: true
       - Apply context.appThemes.surfaceColor for fillColor
       - Use context.appThemes.primaryColor for focused border
   [x] Replace ElevatedButton with FilledButton:
       - Use context.appThemes.primaryColor for background
       - Use context.appThemes.bodyLarge for text style
   [x] Update TextButton for "Forgot Password":
       - Use context.appThemes.textSecondaryColor
       - Proper touch target size
   
   Phase 3: Add translations
   [x] Add authWelcomeBack to en.i18n.json: "Welcome Back"
   [x] Add authWelcomeBack to vi.i18n.json: "Chào Mừng Trở Lại"
   [x] Add authLoginToContinue to en.i18n.json: "Login to continue"
   [x] Add authLoginToContinue to vi.i18n.json: "Đăng nhập để tiếp tục"
   [x] Run: melos genAlls
   
   Phase 4: Ensure responsiveness
   [x] Use MediaQuery.of(context).size.width for responsive padding
   [x] Test on small screens (320px width)
   [x] Test on large screens (428px width)
   [x] Ensure all content visible without scrolling on standard screens
   
   Phase 5: Accessibility
   [x] Add Semantics labels for fields
   [x] Verify contrast ratios using DevTools
   [x] Ensure touch targets are 48x48dp minimum
   [x] Test with screen reader (TalkBack/VoiceOver)

3. VERIFY:
   [x] UI matches Material Design 3 patterns
   [x] All colors use context.appThemes
   [x] All text uses context.t
   [x] No hardcoded colors (check with search)
   [x] No hardcoded strings (check with search)
   [x] Responsive on all screen sizes
   [x] Theme switching works perfectly
   [x] Translations complete (en & vi)
   [x] Accessibility guidelines met
   [x] Login functionality unchanged
   [x] Run: fvm flutter analyze --no-fatal-infos → 0 issues

4. TEST:
   [x] Light theme → All colors correct
   [x] Dark theme → All colors correct
   [x] Small screen (320px) → Layout good
   [x] Large screen (428px) → Layout good
   [x] Field focus → Proper highlighting
   [x] Button tap → Proper feedback
   [x] Screen reader → Proper labels
   [x] Login flow → Works correctly

DELIVERABLES:
[x] Updated login_page.dart with Material 3 design
[x] Updated auth_text_field.dart widget
[x] Added translations (4 new keys)
[x] Verified context.appThemes usage (0 Theme.of(context))
[x] Verified context.t usage (0 hardcoded strings)
[x] Tested light/dark themes
[x] Tested responsiveness
[x] Code analysis: 0 issues

✅ VERIFICATION:
Visual Checks:
- Logo displays at top center ✓
- Welcome text below logo ✓
- Text fields have Material 3 styling ✓
- Button uses FilledButton style ✓
- Spacing and padding improved ✓
- Animations smooth on field focus ✓

Theme Compliance:
- context.appThemes.primaryColor used ✓
- context.appThemes.surfaceColor used ✓
- context.appThemes.bodyMedium used ✓
- NO Theme.of(context) found ✓

Translation Compliance:
- context.t.authWelcomeBack used ✓
- context.t.authLoginToContinue used ✓
- NO hardcoded strings found ✓

Responsiveness:
- 320px width (small phone) ✓
- 375px width (standard phone) ✓
- 428px width (large phone) ✓
- Landscape orientation ✓

Accessibility:
- Contrast ratio: 6.2:1 (passes WCAG AAA) ✓
- Touch targets: All 48x48dp+ ✓
- Screen reader labels: Present ✓
- Semantic structure: Proper ✓

Functionality:
- Login with valid credentials ✓
- Login with invalid credentials ✓
- Field validation ✓
- Loading state ✓
- Error display ✓
- Navigation ✓
```

---

## 🎯 Example 2: Update Wallet Balance Card UI

```markdown
TASK: Redesign wallet balance card with gradient background

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: UI Update
GOAL: Update wallet balance card to feature a gradient background, improved typography, and card-style design

REQUIREMENTS:
- Changes: 
  - Add gradient background (primary to secondary color)
  - Update text hierarchy (balance prominent)
  - Add card elevation and rounded corners
  - Include currency icon
  - Add subtle shadow
  - Improve spacing
- Design reference: Modern banking app card style
- Responsive: Adapts to different screen widths
- Accessibility: Maintain readability on gradient

AFFECTED FILES:
@lib/features/wallet/presentation/widgets/balance_card_widget.dart
@assets/locales/en.i18n.json
@assets/locales/vi.i18n.json

⚠️ MANDATORY RULES:
[ ] Use context.appThemes.primaryColor for gradient start
[ ] Use context.appThemes.secondaryColor for gradient end
[ ] Use context.appThemes.displayLarge for balance amount
[ ] Use context.t.walletTotalBalance (not "Total Balance")
[ ] Ensure text readable on gradient (white text)
[ ] Test light and dark theme
[ ] Maintain existing functionality (balance display)

🛠 MISSION:
1. REVIEW:
   [x] Check current balance_card_widget.dart
   [x] Understand current layout
   [x] Check balance data source

2. UPDATE:
   Phase 1: Add gradient
   [x] Create LinearGradient with:
       - Begin: Alignment.topLeft
       - End: Alignment.bottomRight
       - Colors: [context.appThemes.primaryColor, context.appThemes.secondaryColor]
   [x] Apply to Container decoration
   [x] Test gradient in light/dark themes
   
   Phase 2: Update typography
   [x] Balance amount: context.appThemes.displayLarge.copyWith(
       color: Colors.white,
       fontWeight: FontWeight.bold,
     )
   [x] Currency code: context.appThemes.titleMedium.copyWith(color: Colors.white70)
   [x] "Total Balance" label: context.appThemes.bodyMedium.copyWith(color: Colors.white70)
   
   Phase 3: Add card styling
   [x] BorderRadius: BorderRadius.circular(16)
   [x] BoxShadow with appropriate blur and offset
   [x] Padding: EdgeInsets.all(24)
   [x] Margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
   
   Phase 4: Add currency icon
   [x] Icon widget with dollar/currency symbol
   [x] Position in top right corner
   [x] Color: Colors.white70
   [x] Size: 32
   
   Phase 5: Update translations
   [x] Verify walletTotalBalance exists or add
   [x] Run: melos genAlls if added

3. VERIFY:
   [x] Gradient displays correctly
   [x] Text readable on gradient
   [x] Card style applied properly
   [x] Currency icon positioned correctly
   [x] context.appThemes used for all colors
   [x] context.t used for text
   [x] Responsive on different widths
   [x] Light/dark themes both work
   [x] Balance updates correctly
   [x] Run: fvm flutter analyze --no-fatal-infos → 0 issues

4. TEST:
   [x] Light theme → Gradient visible
   [x] Dark theme → Gradient visible
   [x] Small screen → Card fits well
   [x] Large screen → Card scales appropriately
   [x] Balance changes → Updates correctly
   [x] Text contrast → Readable (4.5:1+)

DELIVERABLES:
[x] Updated balance_card_widget.dart with gradient
[x] Proper use of context.appThemes
[x] Proper use of context.t
[x] Responsive design
[x] Tested both themes
[x] Code analysis: 0 issues

✅ VERIFICATION:
Visual Checks:
- Gradient background displays ✓
- Balance amount prominent ✓
- Card elevation visible ✓
- Rounded corners (16dp) ✓
- Currency icon positioned ✓
- Proper spacing/padding ✓

Theme Compliance:
- context.appThemes.primaryColor (gradient start) ✓
- context.appThemes.secondaryColor (gradient end) ✓
- context.appThemes.displayLarge (balance) ✓
- NO hardcoded colors ✓

Translation Compliance:
- context.t.walletTotalBalance used ✓
- NO hardcoded "Total Balance" ✓

Contrast/Accessibility:
- White text on gradient: 5.8:1 contrast ✓
- Readable in all conditions ✓
- Icon visible ✓

Responsiveness:
- 320px width: Card fits ✓
- 428px width: Card scales ✓
- Portrait/Landscape: Both work ✓

Functionality:
- Balance updates display ✓
- Real-time changes reflect ✓
- Navigation preserved ✓
```

---

## 📝 UI Update Checklist

Before starting:

```
[ ] Review current UI implementation
[ ] Check for hardcoded colors/strings
[ ] Understand functionality to preserve
[ ] Review design requirements
```

During update:

```
[ ] Use context.appThemes for ALL colors and text styles
[ ] Use context.t for ALL user-facing text
[ ] Add translations to en.i18n.json & vi.i18n.json
[ ] Test changes in light theme
[ ] Test changes in dark theme
[ ] Ensure responsive design
[ ] Maintain existing functionality
```

After update:

```
[ ] Search for "Theme.of(context)" → should be 0 results
[ ] Search for hardcoded strings → should be 0 results
[ ] Run: melos genAlls
[ ] Run: fvm flutter analyze --no-fatal-infos → 0 issues
[ ] Visual QA on multiple screen sizes
[ ] Theme switching test
[ ] Accessibility check
```

---

## 🎨 Theme Compliance Rules

### Always Use:
```dart
// Colors
context.appThemes.primaryColor
context.appThemes.secondaryColor
context.appThemes.backgroundColor
context.appThemes.surfaceColor
context.appThemes.errorColor

// Text Styles
context.appThemes.displayLarge
context.appThemes.headlineSmall
context.appThemes.titleMedium
context.appThemes.bodyMedium
context.appThemes.labelSmall

// Combined
context.appThemes.bodyMedium.copyWith(
  color: context.appThemes.textSecondaryColor
)
```

### Never Use:
```dart
// ❌ WRONG
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.bodyMedium
Colors.red
Color(0xFF...)
TextStyle(color: Colors.blue)
```

---

## ✅ Success Criteria

UI update is complete when:

- ✅ Visual requirements met
- ✅ context.appThemes used everywhere (0 Theme.of(context))
- ✅ context.t used for all text (0 hardcoded strings)
- ✅ Translations added (en & vi)
- ✅ Responsive on all screen sizes
- ✅ Light theme works perfectly
- ✅ Dark theme works perfectly
- ✅ Accessibility guidelines met
- ✅ Existing functionality preserved
- ✅ Code analysis: 0 issues

---

**Last Updated**: 2026-01-12  
**Related Templates**: 
- [Create New Feature Template](./create-new-feature.md)
- [Fix Bug Template](./fix-bug.md)
- [Refactor Code Template](./refactor-code.md)
