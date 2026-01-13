# Sample MVI Feature Brick

A comprehensive demo brick that generates a feature with **all** MVI actions, events, and states for learning purposes.

## Usage

```bash
mason make sample --feature_name example
```

## Generated Content

This brick generates a complete feature demonstrating:

### Actions (User Input → ViewModel)
- `LoadAll...sAction` - Load all items
- `Load...Action` - Load single item by ID
- `Create...Action` - Create new item
- `Update...Action` - Update existing item  
- `Delete...Action` - Delete item
- `Refresh...sAction` - Refresh list

### Events (ViewModel → View - One-time effects)
- `ShowMessage` - Toast/Snackbar with success/error/warning/info types
- `NavigateTo...Detail` - Navigate to detail page
- `NavigateToCreate...` - Navigate to create page
- `NavigateToEdit...` - Navigate to edit page
- `NavigateBack` - Pop navigation
- `ShowConfirmDialog` - Show confirmation dialog

### States (UI State)
- `...Initial` - Initial state
- `...Loading` - Loading state
- `...sLoaded` - List loaded
- `...Loaded` - Single item loaded
- `...Empty` - No items found
- `...Error` - Error occurred
- `...Creating` - Item is being created
- `...Created` - Item was created
- `...Deleting` - Item is being deleted

## Purpose

Use this brick for:
1. **Learning** - Understand the full MVI pattern
2. **Reference** - Copy patterns for your features
3. **Demo** - Show the complete architecture

For production features, use `mason make mvi_feature` which generates a simpler template.
