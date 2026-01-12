# Task Assignment Template - Information Collection Guide

**Purpose**: Structured template for AI agents to collect missing information when creating features  
**When to Use**: During step 3 of proactive workflow (PREPARE TASK ASSIGNMENT TEMPLATE)  
**Reference**: TASK_ASSIGNMENT.md

---

## 📋 Information Collection Template

When an AI agent needs to collect module information and confirmation, use this structured template:

### Standard Template Structure

```markdown
To proceed with implementation, I need to confirm the following details:

## MODULE INFORMATION
- **Type**: [New Module / Subfeature to existing module]
- **Module name**: [recommended_module_name]
- **Feature/Subfeature name**: [suggested_feature_name]
- **Functionality**: [clear description of what it does]
- **UI requirements**: [screens, components, navigation]

## TECHNICAL DETAILS
- **API endpoints**: [if applicable, list endpoints with methods]
- **Data models**: [entities/models needed]
- **Validation rules**: [input validation, business rules]
- **Error handling**: [expected errors and handling approach]
- **Success flow**: [what happens after successful operation]

## ADDITIONAL REQUIREMENTS
- **Translations**: [keys to add in en.i18n.json & vi.i18n.json]
- **Routing**: [paths to configure in app_router.dart]
- **Dependencies**: [any new packages or external services]
- **Permissions**: [if needed, e.g., camera, storage]
- **State persistence**: [if data needs to be cached/stored]

## ASSUMPTIONS
[List any assumptions you're making about implementation]

## CONFIRMATION
Should I proceed with [recommended option: mvi_feature/mvi_subfeature]?

Please confirm or provide corrections to any of the above details.
```

---

## 🎯 Template Usage Examples

### Example 1: Ambiguous Feature Request - Forgot Password

**User Request**: "Create a forgot password feature"

**AI Agent Response**:

```markdown
I'll analyze the codebase and present implementation options:

ANALYSIS:
• Found existing authentication module at lib/features/authentication/
• Forgot password belongs to authentication domain
• Can reuse AuthenticationRepository and AuthenticationBloc

RECOMMENDATION: Add as subfeature to authentication module

OPTION 1 (Recommended): Add Subfeature
• Template: mvi_subfeature
• Module: authentication
• Benefits: Reuses infrastructure, maintains cohesion

OPTION 2 (Not Recommended): Create New Module
• Template: mvi_feature
• Note: Would duplicate authentication infrastructure

---

To proceed with implementation, I need to confirm the following details:

## MODULE INFORMATION
- **Type**: Subfeature to existing authentication module
- **Module name**: authentication
- **Subfeature name**: forgot_password
- **Functionality**: 
  - User enters email address
  - System sends password reset link via email
  - User receives confirmation message
- **UI requirements**: 
  - New page: forgot_password_page.dart
  - Email input field with validation
  - Submit button with loading state
  - Success/error message display
  - Navigation from login page
  - Back button to return to login

## TECHNICAL DETAILS
- **API endpoints**: 
  - POST /auth/forgot-password
    - Request: { "email": "user@example.com" }
    - Response: { "message": "Reset email sent" }
  - (Please confirm or provide correct endpoint)
- **Data models**: 
  - Reuse existing AuthUserEntity (no new entity needed)
- **Validation rules**:
  - Email format validation (RFC 5322)
  - Empty field validation
  - Rate limiting handling (if user sends multiple requests)
- **Error handling**:
  - Invalid email format → Show validation error
  - User not found → Show generic message (security)
  - Network error → Show retry option
  - Rate limit exceeded → Show "Try again later"
- **Success flow**:
  - Show success message: "Password reset email sent!"
  - Auto-navigate back to login after 2 seconds
  - Or provide manual "Back to Login" button

## ADDITIONAL REQUIREMENTS
- **Translations**: 
  - authForgotPasswordTitle: "Forgot Password"
  - authForgotPasswordDescription: "Enter your email..."
  - authForgotPasswordEmailLabel: "Email Address"
  - authForgotPasswordSubmitButton: "Send Reset Link"
  - authForgotPasswordSuccessMessage: "Email sent! Check inbox"
  - authForgotPasswordBackToLogin: "Back to Login"
  - (Will add to both en.i18n.json & vi.i18n.json)
- **Routing**: 
  - Add route: /forgot-password in app_router.dart
  - Add navigation from login_page.dart
- **Dependencies**: 
  - No new packages needed (using existing Dio for API)
- **State persistence**: 
  - No persistence needed (one-time operation)

## ASSUMPTIONS
- Email service is configured on backend
- Reset link is sent via email (not SMS)
- User will reset password via email link (separate flow)
- This feature only handles sending the reset email

## CONFIRMATION
Should I proceed with Option 1 (adding forgot_password as a subfeature to authentication module)?

Please confirm or provide corrections to any of the above details.
```

---

### Example 2: New Module Request - Notifications

**User Request**: "Add notifications"

**AI Agent Response**:

```markdown
I'll analyze the codebase and present implementation options:

ANALYSIS:
• Checked lib/features/ directory
• No existing notifications module found
• Notifications is a distinct domain concept
• Requires its own repository and data sources

RECOMMENDATION: Create as new module

OPTION 1 (Recommended): Create New Module
• Template: mvi_feature
• Module: notifications
• Creates: Complete module structure
• Benefits: Independent, scalable, follows architecture

---

To proceed with implementation, I need to confirm the following details:

## MODULE INFORMATION
- **Type**: New Module
- **Module name**: notifications
- **Functionality**: 
  - Display list of user notifications
  - Mark notifications as read
  - Delete notifications
  - Real-time notification updates (push notifications)
  - Filter notifications by type (info, warning, success)
- **UI requirements**: 
  - Notifications list page (main screen)
  - Notification detail page (when tapped)
  - Badge counter on app icon
  - In-app notification banner
  - Filter/sort options

## TECHNICAL DETAILS
- **API endpoints**: 
  - GET /notifications → List user notifications
  - GET /notifications/:id → Get notification detail
  - PUT /notifications/:id/read → Mark as read
  - DELETE /notifications/:id → Delete notification
  - POST /notifications/register-device → Register for push
  - (Please confirm or provide correct endpoints)
- **Data models**: 
  - NotificationEntity (id, title, message, type, isRead, timestamp)
  - NotificationType enum (info, warning, success, error)
- **Validation rules**:
  - Pagination (20 items per page)
  - Auto-mark as read when opened
  - Local caching for offline access
- **Error handling**:
  - Network error → Show cached notifications
  - Empty state → "No notifications yet"
  - Delete failure → Retry option
- **Success flow**:
  - Pull to refresh → Fetch latest
  - Mark as read → Update UI immediately
  - Delete → Remove from list with undo option

## ADDITIONAL REQUIREMENTS
- **Translations**: 
  - notificationsTitle: "Notifications"
  - notificationsMarkAllRead: "Mark All as Read"
  - notificationsEmpty: "No notifications yet"
  - notificationsDeleteConfirm: "Delete this notification?"
  - (Will add to both en.i18n.json & vi.i18n.json)
- **Routing**: 
  - /notifications (main list)
  - /notifications/:id (detail page)
- **Dependencies**: 
  - firebase_messaging (for push notifications) - confirm if needed?
  - flutter_local_notifications (for local notifications)
- **Permissions**: 
  - Notification permission (iOS & Android)
  - Badge permission (iOS)
- **State persistence**: 
  - Cache notifications locally (Hive/SharedPreferences)
  - Persist read/unread status
  - Sync with server on app launch

## ASSUMPTIONS
- Backend provides REST API for notifications
- Push notifications are required (not just in-app)
- Notifications have types/categories
- User can delete individual notifications
- Badge counter shows unread count

## CONFIRMATION
Should I proceed with Option 1 (creating notifications as a new module)?

Please confirm or provide corrections to any of the above details, especially:
1. Are push notifications required?
2. Should we use Firebase or a different service?
3. Do you want notification categories/filters?
```

---

## 📝 Template Sections Explained

### 1. MODULE INFORMATION
**Purpose**: Define the scope and structure  
**What to include**:
- Type (new module vs subfeature)
- Module and feature names
- Clear functionality description
- UI components needed

### 2. TECHNICAL DETAILS
**Purpose**: Clarify implementation specifics  
**What to include**:
- API endpoints (with request/response examples)
- Data models (entities/models)
- Validation rules
- Error scenarios
- Success flows

### 3. ADDITIONAL REQUIREMENTS
**Purpose**: Cover supporting implementation needs  
**What to include**:
- Translation keys
- Routing configuration
- New dependencies
- Permissions
- State management needs

### 4. ASSUMPTIONS
**Purpose**: Make implicit decisions explicit  
**What to include**:
- Technical assumptions
- Business logic assumptions
- Integration assumptions
- User flow assumptions

### 5. CONFIRMATION
**Purpose**: Get clear approval to proceed  
**What to include**:
- Clear yes/no question
- Recommended option
- Request for corrections

---

## ✅ Best Practices

### Do This:
- ✅ Be specific with API endpoints (include methods and data structures)
- ✅ List all screens/components needed
- ✅ Anticipate error scenarios
- ✅ Include both success and failure flows
- ✅ Request confirmation on uncertain details
- ✅ Make assumptions explicit
- ✅ Provide examples where helpful

### Don't Do This:
- ❌ Be vague ("some API endpoint")
- ❌ Skip error handling details
- ❌ Assume without stating
- ❌ Forget translations and routing
- ❌ Miss validation rules
- ❌ Ignore edge cases

---

## 🎯 Quick Checklist

Before sending information collection request:

```
[ ] Analyzed existing codebase
[ ] Presented both options (new module vs subfeature)
[ ] Included recommendation with reasoning
[ ] Prepared MODULE INFORMATION section
[ ] Prepared TECHNICAL DETAILS section
[ ] Prepared ADDITIONAL REQUIREMENTS section
[ ] Listed ASSUMPTIONS explicitly
[ ] Included clear CONFIRMATION question
[ ] Requested corrections if any detail is wrong
[ ] Formatted clearly with markdown
```

---

## 📚 Related Documentation

- **TASK_ASSIGNMENT.md** - Main task assignment template
- **AI_AGENT_WORKFLOWS.md** - Complete AI agent workflows
- **.cursorrules** - Critical project rules
- **WORKFLOW_QUICK_REF.md** - Quick reference guide

---

**Usage**: AI agents should use this template structure when reaching step 3 of the proactive workflow (PREPARE TASK ASSIGNMENT TEMPLATE & ASK FOR MODULE INFORMATION AND CONFIRMATION).

**Goal**: Collect all necessary information in one structured request, reducing back-and-forth and ensuring complete requirements before implementation.

---

**Last Updated**: 2026-01-12  
**Version**: 1.0  
**Status**: Production Ready ✅
