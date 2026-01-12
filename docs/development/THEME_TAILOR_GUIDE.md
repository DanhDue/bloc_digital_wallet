# Theme Tailor Guide

**Centralized Theme Management for bloc_digital_wallet**

This guide explains how to use `theme_tailor` for consistent theming across the application.

---

## 🎯 Core Principle

**NEVER** use `Theme.of(context)` directly. **ALWAYS** use `context.appThemes`.

---

## ❌ What NOT to Do

### Don't Use Theme.of(context)

```dart
// ❌ WRONG - Direct theme access
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  ),
)

Container(
  color: Theme.of(context).colorScheme.surface,
)

// ❌ WRONG - Hardcoded colors
Container(color: Colors.red)
Text('Error', style: TextStyle(color: Colors.red))
Icon(Icons.check, color: Color(0xFF00FF00))
```

---

## ✅ What to Do

### Use context.appThemes

```dart
// ✅ CORRECT - Using context.appThemes
Text(
  'Hello',
  style: context.appThemes.bodyMedium.copyWith(
    color: context.appThemes.textSecondaryColor,
  ),
)

Container(
  color: context.appThemes.surfaceColor,
)

// ✅ CORRECT - Using theme colors
Container(color: context.appThemes.errorColor)
Text('Error', style: context.appThemes.bodyMedium.copyWith(
  color: context.appThemes.errorColor,
))
Icon(Icons.check, color: context.appThemes.primaryColor)
```

---

## 📋 Available Theme Properties

### Text Styles

All text styles support `.copyWith()` for customization:

#### Display Styles
- `displayLarge` - 57sp, Regular
- `displayMedium` - 45sp, Regular
- `displaySmall` - 36sp, Regular
- `displayLargeEmphasized` - 57sp, Medium
- `displayMediumEmphasized` - 45sp, Medium
- `displaySmallEmphasized` - 36sp, Medium

#### Headline Styles
- `headlineLarge` - 32sp, Regular
- `headlineMedium` - 28sp, Regular
- `headlineSmall` - 24sp, Regular
- `headlineLargeEmphasized` - 32sp, Medium
- `headlineMediumEmphasized` - 28sp, Medium
- `headlineSmallEmphasized` - 24sp, Medium

#### Title Styles
- `titleLarge` - 22sp, Regular
- `titleMedium` - 16sp, Medium
- `titleSmall` - 14sp, Medium
- `titleLargeEmphasized` - 22sp, Medium
- `titleMediumEmphasized` - 16sp, SemiBold
- `titleSmallEmphasized` - 14sp, SemiBold

#### Body Styles
- `bodyLarge` - 16sp, Regular
- `bodyMedium` - 14sp, Regular
- `bodySmall` - 12sp, Regular
- `bodyLargeEmphasized` - 16sp, Medium
- `bodyMediumEmphasized` - 14sp, Medium
- `bodySmallEmphasized` - 12sp, Medium

#### Label Styles
- `labelLarge` - 14sp, Medium
- `labelMedium` - 12sp, Medium
- `labelSmall` - 11sp, Medium
- `labelLargeEmphasized` - 14sp, SemiBold
- `labelMediumEmphasized` - 12sp, SemiBold
- `labelSmallEmphasized` - 11sp, SemiBold

### Colors

#### Core Colors
- `primaryColor` - Primary brand color
- `secondaryColor` - Secondary brand color
- `backgroundColor` - Main background color
- `surfaceColor` - Surface/card color
- `errorColor` - Error state color

#### Text Colors
- `textPrimaryColor` - Primary text color
- `textSecondaryColor` - Secondary/hint text color

#### UI Colors
- `dividerColor` - Divider/border color
- `shadowColor` - Shadow color

#### Authentication Colors
- `authTextSecondary` - Secondary text in auth screens
- `authBorderColor` - Border color in auth screens
- `authShadowColor` - Shadow color in auth screens
- `authTextPrimary` - Primary text in auth screens

---

## 📝 Usage Examples

### Example 1: Simple Text Styling

```dart
Text(
  'Welcome Back',
  style: context.appThemes.headlineSmall,
)

Text(
  'Please login to continue',
  style: context.appThemes.bodyMedium.copyWith(
    color: context.appThemes.textSecondaryColor,
  ),
)
```

### Example 2: Container with Theme Colors

```dart
Container(
  decoration: BoxDecoration(
    color: context.appThemes.surfaceColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: context.appThemes.dividerColor),
    boxShadow: [
      BoxShadow(
        color: context.appThemes.shadowColor,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Text(
    'Card Content',
    style: context.appThemes.bodyMedium,
  ),
)
```

### Example 3: Button with Theme Colors

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: context.appThemes.primaryColor,
    foregroundColor: context.appThemes.surfaceColor,
  ),
  onPressed: () {},
  child: Text(
    'Submit',
    style: context.appThemes.labelLarge,
  ),
)
```

### Example 4: TextField with Theme

```dart
TextField(
  style: context.appThemes.bodyMedium,
  decoration: InputDecoration(
    labelText: 'Email',
    labelStyle: context.appThemes.bodySmall.copyWith(
      color: context.appThemes.textSecondaryColor,
    ),
    filled: true,
    fillColor: context.appThemes.surfaceColor,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: context.appThemes.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: context.appThemes.primaryColor, width: 2),
    ),
  ),
)
```

---

## 🔧 Adding New Colors

### Step 1: Add to colors.xml

**File**: `assets/colors/colors.xml`

```xml
<resources>
  <!-- ... existing colors ... -->
  
  <!-- Your new color -->
  <color name="custom_success">#4CAF50</color>
  <color name="custom_warning">#FF9800</color>
</resources>
```

### Step 2: Add Field to AppThemes

**File**: `lib/config/theme/app_themes.dart`

```dart
@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
@TailorMixinComponent()
class AppThemes extends ThemeExtension<AppThemes> with _$AppThemesTailorMixin {
  @override
  final Color primaryColor;
  // ... existing colors ...
  
  // Add your new color fields
  @override
  final Color customSuccess;
  @override
  final Color customWarning;
  
  const AppThemes({
    required this.primaryColor,
    // ... existing parameters ...
    required this.customSuccess,
    required this.customWarning,
  });
  
  // ... copyWith and lerp methods ...
}
```

### Step 3: Initialize in Light Theme

```dart
static final light = AppThemes(
  primaryColor: AppColors.themePrimary,
  // ... existing colors ...
  customSuccess: AppColors.customSuccess,
  customWarning: AppColors.customWarning,
  // ... remaining colors ...
);
```

### Step 4: Initialize in Dark Theme

```dart
static final dark = AppThemes(
  primaryColor: AppColors.themePrimary,
  // ... existing colors ...
  customSuccess: AppColors.customSuccess, // Same or different
  customWarning: AppColors.customWarning,
  // ... remaining colors ...
);
```

### Step 5: Update copyWith Method

```dart
@override
AppThemes copyWith({
  Color? primaryColor,
  // ... existing colors ...
  Color? customSuccess,
  Color? customWarning,
}) {
  return AppThemes(
    primaryColor: primaryColor ?? this.primaryColor,
    // ... existing colors ...
    customSuccess: customSuccess ?? this.customSuccess,
    customWarning: customWarning ?? this.customWarning,
  );
}
```

### Step 6: Update lerp Method

```dart
@override
AppThemes lerp(ThemeExtension<AppThemes> other, double t) {
  if (other is! AppThemes) {
    return this;
  }
  return AppThemes(
    primaryColor: Color.lerp(primaryColor, other.primaryColor, t) ?? primaryColor,
    // ... existing colors ...
    customSuccess: Color.lerp(customSuccess, other.customSuccess, t) ?? customSuccess,
    customWarning: Color.lerp(customWarning, other.customWarning, t) ?? customWarning,
  );
}
```

### Step 7: Run Code Generation

```bash
# Using Melos (recommended)
melos genAlls

# OR manually
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 8: Use Your New Color

```dart
Container(
  color: context.appThemes.customSuccess,
  child: Text(
    'Success!',
    style: context.appThemes.bodyMedium.copyWith(
      color: context.appThemes.surfaceColor,
    ),
  ),
)
```

---

## ⚠️ Important Notes

1. **Import Required**: Always import the AppThemes extension:
   ```dart
   import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
   ```

2. **BuildContext Required**: `context.appThemes` requires a valid `BuildContext`.

3. **No Null Safety Needed**: Unlike `Theme.of(context).textTheme.bodyMedium?`, `context.appThemes.bodyMedium` is non-nullable.

4. **Theme Switching**: Light/Dark themes are automatically handled. Just define both variants.

5. **Hot Reload**: Changes to theme values require running code generation (`melos genAlls`).

---

## 🎨 Best Practices

### 1. Use Semantic Naming

```dart
// ✅ Good - Semantic names
context.appThemes.errorColor
context.appThemes.textSecondaryColor

// ❌ Bad - Generic names
context.appThemes.red
context.appThemes.color1
```

### 2. Group Related Colors

```dart
// Authentication-specific colors
authTextPrimary
authTextSecondary
authBorderColor
authShadowColor
```

### 3. Provide Both Light and Dark

```dart
static final light = AppThemes(
  textPrimaryColor: AppColors.black,
  backgroundColor: AppColors.white,
);

static final dark = AppThemes(
  textPrimaryColor: AppColors.white,
  backgroundColor: AppColors.themeBackgroundDark,
);
```

### 4. Use Emphasized for Bold Text

```dart
// Regular weight
context.appThemes.bodyMedium

// Medium/SemiBold weight
context.appThemes.bodyMediumEmphasized
```

---

## 🔍 Troubleshooting

### Error: "appThemes not found"

**Solution**: Import the extension:
```dart
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
```

### Error: "The getter 'appThemes' isn't defined"

**Solution**: Run code generation:
```bash
melos genAlls
```

### Error: "A value of type 'AppThemes?' can't be assigned"

**Solution**: You're likely using an old pattern. Use `context.appThemes` (non-nullable) instead of `Theme.of(context).extension<AppThemes>()`.

### Colors Not Updating

**Solution**: 
1. Check if you ran `melos genAlls`
2. Restart the app (hot reload might not be enough for theme changes)

---

## 📚 Related Documentation

- [Implementation Guide](IMPLEMENTATION_GUIDE.md) - Complete feature creation guide
- [AI Agent Context](../ai-agents/AI_AGENT_CONTEXT.md) - AI-specific guidelines
- [Quick Reference](../getting-started/QUICK_REFERENCE.md) - Quick lookup cheat sheet

---

**Remember**: Consistent theming makes the app maintainable and provides a better user experience! ✨
