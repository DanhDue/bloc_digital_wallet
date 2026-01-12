# Task Prompt Template: Refactor Code

**Template Type**: Template C - Refactor Code  
**Use Case**: Improving code quality, structure, or performance without changing functionality  
**Project**: bloc_digital_wallet

---

## 📋 Template Structure

```markdown
TASK: Refactor [component/feature]

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Refactor
GOAL: [What to improve in 1-2 sentences]

CURRENT STATE:
- What exists: [Current implementation]
- Problems: [Code smells, technical debt, issues]
- Metrics: [Performance issues, complexity, duplication]

GOAL:
- Desired state: [Clean, maintainable code]
- Improvements: [Better patterns, performance, readability]
- Benefits: [Why refactor is needed]

AFFECTED FILES:
@[mention files to refactor]

⚠️ CONSTRAINTS:
[ ] Preserve functionality - behavior must remain the same
[ ] Follow architecture patterns
[ ] Update tests if needed
[ ] Don't introduce breaking changes
[ ] Maintain API compatibility

🛠 MISSION:
1. ANALYZE: Current code structure and issues
2. PLAN: Refactoring approach and steps
3. REFACTOR: Implement improvements incrementally
4. VERIFY: Functionality unchanged, quality improved

SAFETY:
[ ] Show refactoring plan first
[ ] Get approval before major changes
[ ] Refactor incrementally (not all at once)
[ ] Test after each step
[ ] Keep commits atomic

VERIFICATION:
[ ] Functionality preserved (all tests pass)
[ ] Code quality improved (metrics better)
[ ] No breaking changes
[ ] Documentation updated
[ ] Run: fvm flutter analyze --no-fatal-infos → 0 issues
```

---

## 🎯 Example 1: Refactor Authentication BLoC

```markdown
TASK: Refactor authentication BLoC to improve maintainability

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Refactor
GOAL: Improve authentication BLoC code quality by reducing complexity and improving error handling

CURRENT STATE:
- What exists: 
  - AuthenticationBloc handles login, register, logout
  - Single large onAction method with nested switch cases
  - Duplicate error handling code
  - Mixed concerns (validation + business logic)
- Problems:
  - High cyclomatic complexity (CC > 15)
  - Code duplication in error handling
  - Hard to test individual actions
  - Validation logic mixed with business logic
  - Long methods (>100 lines)
- Metrics:
  - onAction method: 150 lines
  - Duplicated error handling: 3 times
  - Unit test coverage: 60%

GOAL:
- Desired state: 
  - Separated validation logic
  - Extracted error handling
  - Smaller, focused methods
  - Improved testability
- Improvements:
  - Reduce complexity (CC < 10)
  - Extract reusable error handler
  - Separate validation concerns
  - Better method organization
- Benefits:
  - Easier to maintain and extend
  - Better test coverage
  - Reduced bugs from complexity
  - Clearer separation of concerns

AFFECTED FILES:
@lib/features/authentication/presentation/mvi/authentication_bloc.dart
@lib/features/authentication/domain/usecases/login_with_email_password_usecase.dart
@lib/features/authentication/domain/usecases/register_with_email_usecase.dart

⚠️ CONSTRAINTS:
[ ] All existing tests must pass
[ ] No changes to public API (actions, states, events)
[ ] Maintain MVI pattern
[ ] Keep @injectable annotation
[ ] Don't change business logic behavior
[ ] Preserve error messages

🛠 MISSION:
1. ANALYZE:
   - Review current AuthenticationBloc implementation
   - Identify code smells and duplication
   - Check test coverage gaps
   - Plan extraction of methods

2. PLAN:
   Phase 1: Extract error handling
   - Create _handleRepositoryError method
   - Replace duplicated error handling
   
   Phase 2: Extract validation
   - Move validation to use case layer
   - Remove validation from bloc
   
   Phase 3: Split onAction method
   - Extract _handleLoginAction
   - Extract _handleRegisterAction
   - Extract _handleLogoutAction
   
   Phase 4: Add documentation
   - Document extracted methods
   - Add examples

3. REFACTOR:
   Step 1: Extract error handler
   [x] Create _handleRepositoryError(Either<Failure, T> result)
   [x] Replace error handling code in login
   [x] Replace error handling code in register
   [x] Replace error handling code in logout
   [x] Test error scenarios
   
   Step 2: Improve validation
   [x] Move email validation to use case
   [x] Move password validation to use case
   [x] Update use case tests
   [x] Remove validation from bloc
   
   Step 3: Split onAction
   [x] Extract _handleLoginAction method
   [x] Extract _handleRegisterAction method
   [x] Extract _handleLogoutAction method
   [x] Update onAction to call extracted methods
   [x] Verify all actions still work
   
   Step 4: Add documentation
   [x] Document private methods
   [x] Add code comments for complex logic
   [x] Update class documentation

4. VERIFY:
   [x] All existing tests pass
   [x] No behavioral changes
   [x] Cyclomatic complexity reduced (CC = 8)
   [x] Code duplication eliminated
   [x] Test coverage improved to 85%
   [x] Run: fvm flutter analyze --no-fatal-infos → 0 issues

DELIVERABLES:
[x] Extracted _handleRepositoryError method (15 lines)
[x] Extracted _handleLoginAction method (30 lines)
[x] Extracted _handleRegisterAction method (35 lines)
[x] Extracted _handleLogoutAction method (20 lines)
[x] Moved validation to use case layer
[x] Updated onAction to be cleaner (40 lines)
[x] Added documentation comments
[x] All tests pass (100% previous tests + new tests)
[x] Code analysis: 0 issues

✅ VERIFICATION:
Code Quality Metrics:
- Cyclomatic complexity: 15 → 8 ✓
- Lines per method: 150 → max 35 ✓
- Code duplication: 3 instances → 0 ✓
- Test coverage: 60% → 85% ✓

Functionality Tests:
- Login with valid credentials → Success ✓
- Login with invalid credentials → Error ✓
- Register with valid data → Success ✓
- Register with invalid data → Error ✓
- Logout → Success ✓
- Network error handling → Graceful ✓

Code Analysis:
- No new warnings or errors
- Pattern consistency maintained
- MVI pattern preserved
- All @injectable annotations intact
```

---

## 🎯 Example 2: Refactor Widget Tree for Performance

```markdown
TASK: Refactor wallet page widget tree to improve performance

🎭 ROLE & CONTEXT:
You are a Senior Flutter Developer expert in Clean Architecture + MVI pattern.

PROJECT: bloc_digital_wallet
TASK TYPE: Refactor (Performance)
GOAL: Optimize wallet page rendering to reduce unnecessary rebuilds and improve scroll performance

CURRENT STATE:
- What exists: 
  - Wallet page with balance card and transaction list
  - BlocBuilder wrapping entire page
  - Transaction list rebuilds on any state change
  - Heavy widgets recreated unnecessarily
- Problems:
  - Entire page rebuilds when only balance changes
  - Transaction list rebuilds when user scrolls
  - Janky scroll performance (20-30 FPS)
  - Unnecessary widget instantiation
- Metrics:
  - Scroll FPS: 25 average
  - Rebuild count per balance update: 15+
  - Widget tree depth: 12 levels
  - Build time: 16ms per frame

GOAL:
- Desired state: 
  - Separate BlocBuilders for balance and list
  - Optimized widget tree
  - Smooth 60 FPS scrolling
  - Minimal rebuilds
- Improvements:
  - Use const constructors
  - Extract stateless widgets
  - Optimize BlocBuilder scope
  - Add keys where needed
- Benefits:
  - Better scroll performance
  - Reduced battery consumption
  - Improved user experience
  - Lower memory usage

AFFECTED FILES:
@lib/features/wallet/presentation/pages/wallet_page.dart
@lib/features/wallet/presentation/widgets/balance_card_widget.dart
@lib/features/wallet/presentation/widgets/transaction_list_widget.dart

⚠️ CONSTRAINTS:
[ ] UI appearance must remain the same
[ ] All functionality preserved
[ ] State management pattern unchanged
[ ] Theme and translations usage maintained
[ ] No breaking changes to widget API

🛠 MISSION:
1. ANALYZE:
   - Profile widget build times
   - Identify rebuild triggers
   - Check widget tree structure
   - Measure current performance

2. PLAN:
   Phase 1: Split BlocBuilders
   - Separate balance BlocBuilder
   - Separate transaction list BlocBuilder
   
   Phase 2: Extract widgets
   - Extract BalanceCard as const widget
   - Extract TransactionItem as const widget
   
   Phase 3: Optimize list
   - Add ListView.builder optimizations
   - Use proper keys
   - Implement item caching
   
   Phase 4: Measure improvements
   - Re-profile performance
   - Compare metrics

3. REFACTOR:
   Step 1: Split BlocBuilders
   [x] Create BlocBuilder for balance only
   [x] Create BlocBuilder for transaction list only
   [x] Update state selectors
   [x] Test both update independently
   
   Step 2: Extract and optimize widgets
   [x] Extract BalanceCardWidget with const constructor
   [x] Extract TransactionItemWidget with const constructor
   [x] Move non-changing data to const fields
   [x] Add @immutable annotations
   
   Step 3: Optimize ListView
   [x] Add itemExtent to ListView.builder
   [x] Add unique keys to list items
   [x] Implement AutomaticKeepAliveClientMixin if needed
   [x] Cache expensive computations
   
   Step 4: Measure and verify
   [x] Profile with DevTools
   [x] Check rebuild count
   [x] Measure scroll FPS
   [x] Verify memory usage

4. VERIFY:
   [x] UI appearance unchanged
   [x] All functionality works
   [x] Performance improved significantly
   [x] No new issues introduced
   [x] Run: fvm flutter analyze --no-fatal-infos → 0 issues

DELIVERABLES:
[x] Split BlocBuilder into two scoped builders
[x] Extracted BalanceCardWidget with const constructor
[x] Extracted TransactionItemWidget with const constructor
[x] Optimized ListView.builder with keys and extent
[x] Added performance measurements
[x] Updated documentation
[x] All tests pass
[x] Performance improved

✅ VERIFICATION:
Performance Metrics:
- Scroll FPS: 25 → 58-60 ✓
- Rebuild count: 15+ → 2 ✓
- Widget tree depth: 12 → 9 ✓
- Build time: 16ms → 6ms ✓

Functionality Tests:
- Balance updates display correctly ✓
- Transaction list updates correctly ✓
- Scrolling is smooth ✓
- Pull to refresh works ✓
- Navigation intact ✓

Code Quality:
- const constructors used where possible
- Proper widget keys added
- BlocBuilder scope optimized
- Code analysis: 0 issues
```

---

## 📝 Refactoring Checklist

Before refactoring:

```
[ ] Understand current code thoroughly
[ ] Identify specific problems
[ ] Plan refactoring steps
[ ] Ensure tests exist (write if missing)
[ ] Get approval for major changes
[ ] Create backup/branch
```

During refactoring:

```
[ ] Make small, incremental changes
[ ] Test after each step
[ ] Keep commits atomic
[ ] Don't mix refactoring with new features
[ ] Preserve functionality
[ ] Update documentation
```

After refactoring:

```
[ ] All tests pass
[ ] Metrics improved
[ ] Code analysis clean
[ ] Peer review if needed
[ ] Update related documentation
```

---

## 🔧 Common Refactoring Types

### 1. Extract Method
- Long methods → Smaller focused methods
- Duplicate code → Reusable methods

### 2. Simplify Conditionals
- Complex if/else → Switch or pattern matching
- Nested conditions → Early returns

### 3. Improve Names
- Unclear names → Descriptive names
- Abbreviations → Full words

### 4. Reduce Coupling
- Tight coupling → Dependency injection
- Hard dependencies → Interfaces

### 5. Performance
- Unnecessary rebuilds → Optimized widgets
- Blocking operations → Async operations

---

## ✅ Success Criteria

Refactoring is complete when:

- ✅ Functionality unchanged (all tests pass)
- ✅ Code quality improved (metrics better)
- ✅ Complexity reduced
- ✅ Duplication eliminated
- ✅ Performance improved (if applicable)
- ✅ Code more maintainable
- ✅ Documentation updated
- ✅ Code analysis: 0 issues
- ✅ Team approved (if major refactoring)

---

**Last Updated**: 2026-01-12  
**Related Templates**: 
- [Create New Feature Template](./create-new-feature.md)
- [Fix Bug Template](./fix-bug.md)
- [Update UI Template](./update-ui.md)
