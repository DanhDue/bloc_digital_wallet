# Task Prompt Template: Create New Feature

**Template Type**: Template A - Create New Feature  
**Use Case**: Creating a new module or adding a subfeature to existing module  
**Project**: bloc_digital_wallet

---

## 📋 Template Structure

```markdown
TASK: Create [feature_name] feature

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: [New Module / Subfeature]
GOAL: [Describe what you want to achieve in 1-2 sentences]

CONTEXT:
- Current state: [What exists now]
- Desired outcome: [What should exist after]
- Files involved: @[mention relevant files/folders]

⚠️ CRITICAL RULES:
- IF creating feature WITHOUT clear module context:
  1. ANALYZE - Check lib/features/ for existing modules
  2. PRESENT PLAN - Show options with recommendation
  3. PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR CONFIRMATION
  4. THEN PROCEED
- Use context.appThemes for ALL styling (not Theme.of(context))
- Use context.t for ALL text (not hardcoded strings)
- Follow MVI pattern (Action/State/Event)
- Use bloc.onAction() as single entry point

🛠 MISSION:
REQUIREMENTS:
- Feature type: [New Module / Subfeature to existing module]
- IF Subfeature: Target module: [module_name]
- Functionality: [Describe what it does]
- UI requirements: [Describe screens/components]
- **Figma Design**: [If available, provide Figma link]
  - **IMPORTANT**: Use `figma-dev-mode-mcp-server` to fetch design specs BEFORE implementing UI
  - Extract node ID from URL: `https://figma.com/design/:fileKey/:fileName?node-id=1-2` → nodeId: `1:2`
  - Never guess colors, spacing, or typography - always reference Figma
- API endpoints: [If applicable]

FILES TO REVIEW:
@[relevant existing files]

DELIVERABLES:
[ ] Generated structure (mason make mvi_feature or mvi_subfeature)
[ ] Implemented business logic
[ ] UI implementation with theme/translations
[ ] Route configuration
[ ] Code generation completed (melos genAlls)
[ ] All tests passing (fvm flutter analyze --no-fatal-infos → 0 issues)

✅ VERIFICATION:
- Run: melos genAlls
- Run: dart format lib/
- Run: fvm flutter analyze --no-fatal-infos
- Must show: "No issues found!"
- Test functionality works as expected
```

---

## 🎯 Example 1: Add Forgot Password Feature (Subfeature)

```markdown
TASK: Add forgot password functionality to authentication

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Subfeature
GOAL: Add forgot password functionality to allow users to reset their password via email

CONTEXT:
- Current state: Authentication module exists with login and register
- Desired outcome: Users can request password reset email from login screen
- Files involved: @lib/features/authentication

⚠️ CRITICAL RULES:
- Use mvi_subfeature template (adding to existing authentication module)
- Use context.appThemes for styling
- Use context.t for all text
- Follow MVI pattern (actions, states, events)

🛠 MISSION:
REQUIREMENTS:
- Feature type: Subfeature to existing authentication module
- Target module: authentication
- Functionality: 
  - User enters email address
  - System sends password reset link via email
  - User receives confirmation message
- UI requirements: 
  - New page: forgot_password_page.dart
  - Email input field with validation
  - Submit button with loading state
  - Success/error message display
  - Navigation from login page
- **Figma Design**: https://figma.com/design/example/wallet?node-id=2-117
  - **Node ID**: `2:117` (Forgot Password screen)
  - Use `mcp_figma-dev-mode-mcp-server_get_design_context` to fetch specs
- API endpoints: 
  - POST /auth/forgot-password
    Request: { "email": "user@example.com" }
    Response: { "message": "Reset email sent" }

FILES TO REVIEW:
@lib/features/authentication/presentation/pages/login_page.dart
@lib/features/authentication/presentation/mvi/authentication_bloc.dart
@lib/features/authentication/domain/repositories/authentication_repository.dart

IMPLEMENTATION STEPS:
1. ANALYZE: Check authentication module structure
2. PRESENT: Show plan for adding forgot_password subfeature
3. IMPLEMENT: After confirmation, add:
   - Use case: forgot_password_usecase.dart
   - Action: ForgotPasswordAction in authentication_action.dart
   - Handler in authentication_bloc.dart
   - Repository method in authentication_repository.dart
   - Repository implementation in authentication_repository_impl.dart
   - Data source method in auth_remote_datasource.dart
   - Page: forgot_password_page.dart
   - Translations: authForgotPassword* keys (en & vi)
   - Route: /forgot-password in app_router.dart

DELIVERABLES:
[x] Run: mason make mvi_subfeature
    Module: authentication
    Subfeature: forgot_password
[x] Implement forgot_password_usecase.dart with validation
[x] Add ForgotPasswordAction to authentication_action.dart
[x] Add action handler in authentication_bloc.dart
[x] Add sendPasswordResetEmail method to repository interface
[x] Implement sendPasswordResetEmail in repository_impl
[x] Add API call in auth_remote_datasource.dart
[x] Implement UI in forgot_password_page.dart using context.appThemes & context.t
[x] Add translations (authForgotPassword*) to en.i18n.json & vi.i18n.json
[x] Add route /forgot-password to app_router.dart
[x] Add "Forgot Password?" link on login page
[x] Run: melos genAlls
[x] Run: dart format lib/
[x] Run: fvm flutter analyze --no-fatal-infos → Must show "No issues found!"

✅ VERIFICATION:
- Navigation from login to forgot password works
- Email validation works correctly
- API call triggers successfully
- Success message displays after submission
- Navigation back to login works
- Theme and translations applied correctly
- Code analysis shows 0 issues
```

---

## 🎯 Example 2: Create Notifications Module (New Module)

```markdown
TASK: Create notifications system

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: New Module
GOAL: Create a complete notifications system to display and manage user notifications

CONTEXT:
- Current state: No notifications module exists
- Desired outcome: Users can view, read, and manage notifications
- Files involved: Will create new module at lib/features/notifications/

⚠️ CRITICAL RULES:
- Use mvi_feature template (creating new module)
- Use context.appThemes for styling
- Use context.t for all text
- Follow MVI pattern (actions, states, events)
- Implement Clean Architecture (Domain → Data → Presentation)

🛠 MISSION:
REQUIREMENTS:
- Feature type: New Module
- Module name: notifications
- Functionality: 
  - Display list of user notifications
  - Mark notifications as read/unread
  - Delete individual notifications
  - Mark all as read
  - Filter by notification type
  - Real-time notification updates (push notifications)
- UI requirements: 
  - Notifications list page (main screen)
  - Notification detail page (when tapped)
  - Badge counter on app icon
  - Empty state when no notifications
  - Pull to refresh
  - Filter/sort options
- API endpoints: 
  - GET /notifications → List user notifications
  - GET /notifications/:id → Get notification detail
  - PUT /notifications/:id/read → Mark as read
  - DELETE /notifications/:id → Delete notification
  - PUT /notifications/read-all → Mark all as read

FILES TO REVIEW:
@lib/core/architecture/mvi_bloc.dart (for MVI pattern reference)
@lib/features/authentication (for similar structure example)

IMPLEMENTATION STEPS:
1. ANALYZE: Check existing modules for pattern consistency
2. PRESENT: Show plan for creating notifications module
3. IMPLEMENT: After confirmation, create:
   - Domain Layer:
     - Entity: notification_entity.dart
     - Repository: notifications_repository.dart
     - Use Cases: get_notifications_usecase.dart, mark_as_read_usecase.dart, delete_notification_usecase.dart
   - Data Layer:
     - Model: notification_model.dart (@freezed)
     - Data Source: notifications_remote_datasource.dart
     - Repository Impl: notifications_repository_impl.dart
   - Presentation Layer:
     - Action: notifications_action.dart
     - State: notifications_state.dart
     - Event: notifications_event.dart
     - BLoC: notifications_bloc.dart
     - Pages: notifications_page.dart, notification_detail_page.dart
     - Widgets: notification_item_widget.dart
   - Translations: notifications* keys (en & vi)
   - Routes: /notifications, /notifications/:id

DELIVERABLES:
[x] Run: mason make mvi_feature --feature_name notifications
[x] Implement NotificationEntity with required fields
[x] Define NotificationsRepository interface
[x] Create use cases (get, mark read, delete)
[x] Implement NotificationModel with toEntity/fromEntity
[x] Implement NotificationsRemoteDataSource with API calls
[x] Implement NotificationsRepositoryImpl
[x] Define NotificationsAction (Load, MarkAsRead, Delete, Refresh)
[x] Define NotificationsState (Loading, Loaded, Empty, Error)
[x] Define NotificationsEvent (ShowSuccess, ShowError, Navigate)
[x] Implement NotificationsBloc with @injectable
[x] Implement notifications_page.dart with BlocProvider
[x] Implement notification_item_widget.dart
[x] Add translations to en.i18n.json & vi.i18n.json
[x] Add routes to app_router.dart
[x] Run: melos genAlls
[x] Run: dart format lib/
[x] Run: fvm flutter analyze --no-fatal-infos → Must show "No issues found!"

✅ VERIFICATION:
- Notifications list displays correctly
- Pull to refresh works
- Mark as read updates UI
- Delete notification works
- Empty state shows when no notifications
- Theme and translations applied correctly
- Navigation works between list and detail
- Code analysis shows 0 issues
- All API calls work correctly
```

---

## 📝 Template Variables to Fill

When using this template, replace these placeholders:

- `[feature_name]` - Name of the feature (e.g., forgot_password, notifications)
- `[module_name]` - Target module name if subfeature (e.g., authentication, wallet)
- `[New Module / Subfeature]` - Choose the type
- `[Describe...]` - Fill with specific description
- `@[files]` - Attach relevant files using @file or @folder

---

## ✅ Success Criteria

Task is complete when:

- ✅ Feature works as described
- ✅ Uses context.appThemes (not Theme.of(context))
- ✅ Uses context.t (not hardcoded strings)
- ✅ Follows MVI pattern correctly
- ✅ Clean Architecture layers implemented
- ✅ Code generation completed (melos genAlls)
- ✅ Code formatted (dart format lib/)
- ✅ Analysis passes with 0 issues (fvm flutter analyze --no-fatal-infos)
- ✅ Translations added for both en & vi
- ✅ Routes configured
- ✅ Functionality tested and working

---

**Last Updated**: 2026-01-12  
**Related Templates**: 
- [Fix Bug Template](./fix-bug.md)
- [Refactor Code Template](./refactor-code.md)
- [Update UI Template](./update-ui.md)
