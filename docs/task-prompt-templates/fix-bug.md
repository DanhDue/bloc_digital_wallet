# Task Prompt Template: Fix Bug

**Template Type**: Template B - Fix Bug  
**Use Case**: Fixing bugs, errors, or unexpected behavior  
**Project**: bloc_digital_wallet

---

## 📋 Template Structure

```markdown
TASK: Fix [bug description]

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Bug Fix
GOAL: [What bug to fix in 1-2 sentences]

SYMPTOMS:
- What's happening: [Describe the bug]
- Expected behavior: [What should happen]
- Steps to reproduce: [How to trigger the bug]
- Affected area: [Which feature/screen]

AFFECTED FILES:
@[mention specific files where bug exists]

⚠️ CONSTRAINTS:
[ ] Minimal changes - fix root cause only
[ ] Maintain existing behavior elsewhere
[ ] Don't introduce new features
[ ] Add tests if missing
[ ] Follow existing patterns

🛠 MISSION:
1. ANALYZE: Identify root cause
2. FIX: Implement minimal fix
3. VERIFY: Test that bug is resolved
4. CHECK: Ensure no regressions

VERIFICATION:
[ ] Bug is fixed and doesn't occur anymore
[ ] No new issues introduced
[ ] Existing tests still pass
[ ] Run: fvm flutter analyze --no-fatal-infos → 0 issues
[ ] Manual testing confirms fix
```

---

## 🎯 Example 1: Fix Login Button Not Responding

```markdown
TASK: Fix login button not responding on first tap

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Bug Fix
GOAL: Fix login button requiring double tap to trigger login action

SYMPTOMS:
- What's happening: First tap on login button does nothing, second tap works
- Expected behavior: Single tap should trigger login immediately
- Steps to reproduce:
  1. Open app and navigate to login page
  2. Enter valid email and password
  3. Tap login button once
  4. Nothing happens (no loading indicator, no action)
  5. Tap login button again
  6. Login action triggers correctly
- Affected area: Authentication feature - Login page
- Frequency: Happens 100% of the time on first tap

AFFECTED FILES:
@lib/features/authentication/presentation/authentication/login_page.dart
@lib/features/authentication/presentation/authentication/authentication_bloc.dart
@lib/features/authentication/presentation/authentication/widgets/auth_text_field.dart

⚠️ CONSTRAINTS:
[ ] Minimal changes - fix button tap detection only
[ ] Don't modify login business logic
[ ] Don't change UI appearance
[ ] Maintain existing validation behavior
[ ] Keep current loading state management

🛠 MISSION:
1. ANALYZE: 
   - Check BlocBuilder rebuild logic in login_page.dart
   - Check button onPressed handler
   - Check if BlocProvider is properly configured
   - Look for event listener conflicts
   - Check gesture detector configuration

2. FIX:
   - Identify root cause (likely BlocBuilder wrapping issue or gesture absorber)
   - Implement minimal fix without changing architecture
   - Ensure button responds immediately to first tap
   - Maintain existing loading state behavior

3. VERIFY:
   - Test single tap triggers login immediately
   - Test loading indicator shows correctly
   - Test error handling still works
   - Test success flow unchanged

4. CHECK:
   - No changes to authentication logic
   - No changes to validation
   - No changes to UI appearance
   - All existing functionality preserved

DELIVERABLES:
[x] Root cause identified and documented
[x] Minimal fix implemented in login_page.dart
[x] Button now responds to single tap
[x] Loading state displays correctly
[x] Login flow works as expected
[x] Run: fvm flutter analyze --no-fatal-infos → 0 issues
[x] Manual testing confirms fix

✅ VERIFICATION:
Test Scenarios:
1. Single tap with valid credentials → Login triggers immediately ✓
2. Single tap with invalid credentials → Validation error shows ✓
3. Single tap while loading → Button disabled ✓
4. Multiple rapid taps → Only one login attempt ✓
5. Login success flow → Navigates correctly ✓
6. Login error flow → Error message displays ✓

Code Quality:
- No new linter warnings
- Code analysis: 0 issues
- No regression in other authentication features
- Pattern consistency maintained
```

---

## 🎯 Example 2: Fix Transaction List Not Updating

```markdown
TASK: Fix transaction list not updating after new transaction

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Bug Fix
GOAL: Fix transaction list to refresh automatically after completing a transaction

SYMPTOMS:
- What's happening: After completing a transfer, transaction list shows old data
- Expected behavior: Transaction list should refresh and show the new transaction
- Steps to reproduce:
  1. Open wallet screen showing transaction list
  2. Initiate a money transfer
  3. Complete transfer successfully
  4. Return to wallet screen
  5. Transaction list still shows old transactions (new one missing)
  6. Pull to refresh manually shows new transaction
- Affected area: Wallet feature - Transaction list
- Frequency: Happens every time after completing a transaction

AFFECTED FILES:
@lib/features/wallet/presentation/wallet/wallet_page.dart
@lib/features/wallet/presentation/transfer/transfer_page.dart
@lib/features/wallet/presentation/wallet/wallet_bloc.dart

⚠️ CONSTRAINTS:
[ ] Don't change transaction creation logic
[ ] Don't modify API calls
[ ] Maintain existing UI/UX
[ ] Keep pull-to-refresh functionality
[ ] Follow existing state management patterns

🛠 MISSION:
1. ANALYZE: 
   - Check event flow from transfer completion to wallet page
   - Look for missing state update trigger
   - Check if wallet bloc is listening to transaction events
   - Verify navigation doesn't dispose wallet bloc
   - Check if list refresh action is dispatched

2. FIX:
   - Identify where refresh should be triggered
   - Add refresh action after successful transaction
   - Ensure proper event handling between pages
   - Maintain existing state management pattern

3. VERIFY:
   - New transaction appears in list immediately
   - No duplicate API calls
   - Pull to refresh still works
   - Other wallet data updates correctly

4. CHECK:
   - Transaction creation unchanged
   - Navigation flow preserved
   - No unnecessary API calls
   - State management pattern consistent

DELIVERABLES:
[x] Root cause identified (missing RefreshWalletAction dispatch)
[x] Add wallet refresh trigger after successful transfer
[x] Implement in transfer_page.dart after success event
[x] Verify wallet_bloc.dart handles refresh correctly
[x] Test transaction list updates automatically
[x] Run: fvm flutter analyze --no-fatal-infos → 0 issues

✅ VERIFICATION:
Test Scenarios:
1. Complete transfer → List refreshes automatically ✓
2. Transfer fails → List doesn't refresh ✓
3. Navigate back without transfer → List unchanged ✓
4. Pull to refresh → Still works independently ✓
5. Multiple transactions → All show in correct order ✓
6. Network error during refresh → Error handled gracefully ✓

Code Quality:
- No duplicate API calls
- Efficient state updates
- Pattern consistency maintained
- No new issues introduced
```

---

## 📝 Bug Analysis Checklist

Before fixing, analyze:

```
[ ] Reproduced the bug consistently
[ ] Identified exact steps to trigger
[ ] Found the root cause (not just symptoms)
[ ] Checked related code for similar issues
[ ] Reviewed recent changes that might have caused it
[ ] Considered edge cases
[ ] Planned minimal fix approach
```

---

## 🔍 Common Bug Categories

### 1. UI/Interaction Bugs
- Button not responding
- Incorrect navigation
- UI not updating
- Layout issues

### 2. State Management Bugs
- State not updating
- Wrong state transitions
- Event not firing
- Memory leaks

### 3. Data Bugs
- Incorrect data display
- Data not persisting
- Sync issues
- Validation errors

### 4. Logic Bugs
- Wrong calculations
- Incorrect conditions
- Missing edge cases
- Flow errors

---

## ✅ Success Criteria

Bug fix is complete when:

- ✅ Bug no longer occurs
- ✅ Root cause addressed (not just symptoms)
- ✅ Minimal changes made
- ✅ No new issues introduced
- ✅ Existing tests pass
- ✅ Manual testing confirms fix
- ✅ Code analysis: 0 issues
- ✅ Pattern consistency maintained
- ✅ Documentation updated if needed

---

**Last Updated**: 2026-01-12  
**Related Templates**: 
- [Create New Feature Template](./create-new-feature.md)
- [Refactor Code Template](./refactor-code.md)
- [Update UI Template](./update-ui.md)
