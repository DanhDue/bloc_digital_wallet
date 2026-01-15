# AI Agent Rules

## Coding Standards

### Dart / Flutter
-   **Dot Shorthands**: Use dot shorthands for Enums and static members where supported by Dart.
    -   **Preferred**: `.contain`, `.srcIn`, `.fixed`
    -   **Avoid**: `BoxFit.contain`, `BlendMode.srcIn`, `BottomNavigationBarType.fixed`
    -   **Reasoning**: Reduces verbosity and improves readability.
    -   **Constructors/Static Methods**: Use dot shorthands for constructors and static methods where the type can be inferred (context-aware).
        -   **Preferred**: `.mode(...)`, `.only(...)`, `.all(...)`
        -   **Avoid**: `ColorFilter.mode(...)`, `EdgeInsets.only(...)`, `EdgeInsets.all(...)`

-   **Color Usage**: Follow the strict 4-step workflow for adding and using colors.
    1.  **Define**: Add the color to `assets/colors/colors.xml`.
    2.  **Expose**: Add the color field to `AppThemes` in `lib/config/theme/app_themes.dart` (including constructor, `copyWith`, `lerp`, `light`, and `dark` instances).
    3.  **Generate**: Run `melos genAlls` to update generated files (colors, themes, etc.).
    4.  **Use**: Use the color via `context.appThemes.yourColorName` in widgets.
    -   **Avoid**: Hardcoding `Color(0xFF...)` or `Colors.red` directly in widgets.
