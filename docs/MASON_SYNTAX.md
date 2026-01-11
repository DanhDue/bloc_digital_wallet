# Mason Template Syntax Reference

## File and Directory Naming

Mason uses curly braces for template variables in file/directory names:

### Correct Syntax
```
{{{variable_name}}}              # Basic variable
{{{variable_name.snakeCase()}}}  # With helper
{{{variable_name.pascalCase()}}} # Pascal case
{{{variable_name.camelCase()}}}  # Camel case
```

### Examples
```
__brick__/
  lib/
    {{{feature_name.snakeCase()}}}/
      domain/
        entities/
          {{{feature_name.snakeCase()}}}_entity.dart
```

## File Content Templating

Inside files, use double curly braces:

### Basic Variables
```dart
class {{feature_name.pascalCase()}}Entity {
  final String {{variable_name}};
}
```

### Conditionals
```dart
{{#use_equatable}}
import 'package:equatable/equatable.dart';
{{/use_equatable}}

{{^use_equatable}}
// Equatable not used
{{/use_equatable}}
```

### Loops
```dart
{{#items}}
- {{name}}
{{/items}}
```

## Case Helpers

- `{{variable.pascalCase()}}` → PascalCase
- `{{variable.snakeCase()}}` → snake_case
- `{{variable.camelCase()}}` → camelCase
- `{{variable.constantCase()}}` → CONSTANT_CASE
- `{{variable.dotCase()}}` → dot.case
- `{{variable.headerCase()}}` → Header-Case
- `{{variable.paramCase()}}` → param-case
- `{{variable.pathCase()}}` → path/case
- `{{variable.sentenceCase()}}` → Sentence case
- `{{variable.titleCase()}}` → Title Case

## Common Patterns

### Entity File
```dart
// File: {{{feature_name.snakeCase()}}}_entity.dart

class {{feature_name.pascalCase()}}Entity {
  final String id;
  
  const {{feature_name.pascalCase()}}Entity({required this.id});
}
```

### BLoC File
```dart
// File: {{{feature_name.snakeCase()}}}_bloc.dart

class {{feature_name.pascalCase()}}Bloc extends Bloc<{{feature_name.pascalCase()}}Event, {{feature_name.pascalCase()}}State> {
  // Implementation
}
```

## Tips

1. **Always use parentheses** with helpers: `.snakeCase()` not `.snakeCase`
2. **Triple braces for filenames**: `{{{var}}}` in paths
3. **Double braces for content**: `{{var}}` in file contents
4. **Test incrementally**: Start with one file, verify it works, then add more
5. **Avoid deep nesting**: Mason works best with simpler directory structures

## Debugging

If generated files have incorrect names:
1. Check you're using triple braces: `{{{var}}}`
2. Ensure helpers have parentheses: `snakeCase()`
3. Verify the variable is defined in `brick.yaml`
4. Run `mason get` after changing templates
5. Clear cache: `rm -rf .mason && mason get`

## Example brick.yaml

```yaml
name: my_brick
version: 0.1.0+1

vars:
  feature_name:
    type: string
    prompt: Feature name?
  
  use_equatable:
    type: boolean
    default: true
```

## Full Example Structure

```
my_brick/
├── brick.yaml
├── README.md
└── __brick__/
    └── lib/
        └── {{{feature_name.snakeCase()}}}/
            ├── {{{feature_name.snakeCase()}}}_model.dart
            └── {{{feature_name.snakeCase()}}}_view.dart
```

With content:
```dart
// {{{feature_name.snakeCase()}}}_model.dart
class {{feature_name.pascalCase()}}Model {
  final String name;
}
```

Generates (feature_name = "user_profile"):
```
lib/
  user_profile/
    user_profile_model.dart  // Contains: class UserProfileModel
    user_profile_view.dart
```

## Resources

- [Mason Documentation](https://docs.brickhub.dev/)
- [Mason CLI GitHub](https://github.com/felangel/mason)
- [BrickHub](https://brickhub.dev/) - Browse community bricks
