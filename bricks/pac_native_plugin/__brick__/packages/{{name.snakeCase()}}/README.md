# {{name.pascalCase()}}

Native plugin package for the Super App ecosystem.
{{#has_ui}}
Provides native Jetpack Compose and SwiftUI PlatformViews.
{{/has_ui}}
{{^has_ui}}
Provides headless type-safe Pigeon IPC communication.
{{/has_ui}}
