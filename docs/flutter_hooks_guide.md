# Flutter Hooks with Bloc: Complete Guide

This guide explains how to use Flutter Hooks in combination with Bloc for building reactive, stateless UI components in our MVI architecture.

---

## Table of Contents

- [What Are Hooks?](#what-are-hooks)
- [Core Hook Tools](#core-hook-tools)
  - [useState](#usestate)
  - [useEffect](#useeffect)
  - [useMemoized](#usememoized)
  - [useCallback](#usecallback)
  - [useRef](#useref)
- [Hooks with Bloc](#hooks-with-bloc)
- [Real-World Examples](#real-world-examples)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)

---

## What Are Hooks?

**Hooks** are special functions that let you "hook into" widget lifecycle and state management without writing `StatefulWidget` boilerplate.

### Why Use Hooks?

| Without Hooks (StatefulWidget) | With Hooks (HookWidget) |
|--------------------------------|-------------------------|
| 2 classes (Widget + State) | 1 class |
| Manual `initState`/`dispose` | Automatic cleanup via `useEffect` |
| Hard to share stateful logic | Easy to create custom hooks |
| Verbose boilerplate | Concise, functional style |

### Installation

Hooks are already installed in the `framework` package:

```yaml
# packages/framework/pubspec.yaml
dependencies:
  flutter_hooks: ^0.21.0
```

---

## Core Hook Tools

### `useState`

**Purpose**: Manage simple local state (equivalent to `StatefulWidget`'s state variable).

**Signature**:
```dart
ValueNotifier<T> useState<T>(T initialValue)
```

**Example**:
```dart
class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useState(0); // Creates state variable
    
    return Column(children: [
      Text('Count: ${counter.value}'),
      ElevatedButton(
        onPressed: () => counter.value++, // Updates & rebuilds
        child: Text('Increment'),
      ),
    ]);
  }
}
```

**When to use**:
- Simple UI state (counters, toggles, text input)
- Form field values
- Temporary UI flags (isExpanded, isVisible)

---

### `useEffect`

**Purpose**: Execute side effects (subscriptions, timers, API calls) with automatic cleanup.

**Signature**:
```dart
void useEffect(
  Dispose? Function() effect, 
  [List<Object?> keys]
)
```

**Parameters**:
- `effect`: Function to run. Return a cleanup function (or `null`).
- `keys`: Dependency list. Effect re-runs when dependencies change.

**Example 1: Stream Subscription**
```dart
useEffect(() {
  final subscription = stream.listen((data) {
    print('Received: $data');
  });
  
  // Cleanup function (called on dispose)
  return subscription.cancel;
}, [stream]); // Re-subscribe if stream instance changes
```

**Example 2: Timer**
```dart
useEffect(() {
  final timer = Timer.periodic(Duration(seconds: 1), (t) {
    print('Tick');
  });
  
  return timer.cancel; // Auto-cleanup
}, []); // Empty list = run once on mount
```

**Example 3: Run Once on Mount**
```dart
useEffect(() {
  print('Widget mounted!');
  
  // Load data
  fetchData();
  
  // No cleanup needed
  return null;
}, []); // Empty deps = run only once
```

**When to use**:
- Subscribing to streams
- Starting timers/animations
- Registering listeners
- Loading initial data
- **Anything with cleanup logic**

---

### `useMemoized`

**Purpose**: Cache expensive computations. Recompute only when dependencies change.

**Signature**:
```dart
T useMemoized<T>(
  T Function() valueBuilder,
  [List<Object?> keys]
)
```

**Example**:
```dart
class ExpensiveWidget extends HookWidget {
  final int input;
  
  @override
  Widget build(BuildContext context) {
    // Only recalculates when `input` changes
    final result = useMemoized(
      () => expensiveComputation(input),
      [input],
    );
    
    return Text('Result: $result');
  }
}

// Without useMemoized, this runs on EVERY rebuild!
int expensiveComputation(int n) {
  var sum = 0;
  for (var i = 0; i < 1000000; i++) {
    sum += i * n;
  }
  return sum;
}
```

**When to use**:
- Expensive calculations
- Parsing large JSON
- Complex list transformations
- Filtering/sorting operations

---

### `useCallback`

**Purpose**: Cache function references to prevent unnecessary child rebuilds.

**Signature**:
```dart
T useCallback<T extends Function>(
  T callback,
  [List<Object?> keys]
)
```

**Example**:
```dart
class ParentWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    
    // Function is recreated only when `count.value` changes
    final onTap = useCallback(
      () => print('Count: ${count.value}'),
      [count.value],
    );
    
    return Column(children: [
      Text('${count.value}'),
      ExpensiveChild(onTap: onTap), // Won't rebuild unnecessarily
    ]);
  }
}
```

**When to use**:
- Passing callbacks to expensive widgets
- Optimizing performance in lists
- Preventing unnecessary re-renders

---

### `useRef`

**Purpose**: Hold a mutable value that persists across rebuilds WITHOUT triggering rebuilds.

**Signature**:
```dart
ObjectRef<T?> useRef<T>(T? initialValue)
```

**Example**:
```dart
class ScrollableWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useRef<ScrollController?>(null);
    
    useEffect(() {
      scrollController.value = ScrollController();
      return () => scrollController.value?.dispose();
    }, []);
    
    return ListView(
      controller: scrollController.value,
      children: [...],
    );
  }
}
```

**When to use**:
- Controllers (ScrollController, TextEditingController)
- Focus nodes
- Previous values for comparison
- **Anything you need to mutate without rebuilding**

---

## Hooks with Bloc

In our MVI architecture, **Bloc manages business state**, while **hooks manage UI side effects**.

### Architecture Overview

```
┌──────────────────────────────────────┐
│           HookWidget                 │
│  (UI Component - Stateless)          │
└─────────┬────────────────────────────┘
          │
          ├─ useEffect ────────────────┐
          │  (Side Effects)            │
          │  - Event subscriptions     │
          │  - Navigation              │
          │  - Animations              │
          │                            │
          └─ BlocBuilder ──────────────┤
             (State Observer)          │
             - Rebuilds on state       │
                                       │
                              ┌────────▼────────┐
                              │      Bloc       │
                              │ (State Manager) │
                              │  - emit()       │
                              │  - emitEvent()  │
                              └─────────────────┘
```

### Example: `_MviConsumer` in BaseMviPage

```dart
class _MviConsumer<B extends MviBloc<A, S, E>, S, E> extends HookWidget {
  final Widget Function(BuildContext, S) builder;
  final void Function(BuildContext, E) onEvent;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<B>();
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Hook: Manage event subscription side-effect
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    useEffect(() {
      final subscription = bloc.events.listen((event) {
        if (!context.mounted) return;
        onEvent(context, event); // Navigation, snackbars, etc.
      });
      
      // Auto-cleanup when widget unmounts
      return subscription.cancel;
    }, [bloc]);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // Bloc: Observe state changes for UI updates
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    return BlocBuilder<B, S>(builder: builder);
  }
}
```

**Why this works**:
1. `useEffect` subscribes **once** to the event stream
2. `BlocBuilder` rebuilds the UI on state changes
3. No duplicate subscriptions (fixed the 3x log bug!)
4. Automatic cleanup when widget is disposed

---

## Real-World Examples

### Example 1: Animated Counter

```dart
class AnimatedCounter extends HookWidget {
  final int target;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: Duration(milliseconds: 500),
    );
    
    final animation = useMemoized(
      () => Tween<int>(begin: 0, end: target).animate(controller),
      [target, controller],
    );
    
    useEffect(() {
      controller.forward(from: 0);
      return null;
    }, [target]);
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Text('${animation.value}'),
    );
  }
}
```

### Example 2: Debounced Search

```dart
class SearchBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final query = useState('');
    final debouncedQuery = useState('');
    
    useEffect(() {
      final timer = Timer(Duration(milliseconds: 300), () {
        debouncedQuery.value = query.value;
      });
      
      return timer.cancel; // Cancel previous timer
    }, [query.value]);
    
    // Trigger search when debouncedQuery changes
    useEffect(() {
      if (debouncedQuery.value.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQuery(debouncedQuery.value));
      }
      return null;
    }, [debouncedQuery.value]);
    
    return TextField(
      onChanged: (value) => query.value = value,
    );
  }
}
```

### Example 3: Auto-Save Form

```dart
class AutoSaveForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final name = useState('');
    final email = useState('');
    
    // Save to local storage when values change
    useEffect(() {
      final timer = Timer(Duration(seconds: 2), () async {
        await LocalStorage.save('name', name.value);
        await LocalStorage.save('email', email.value);
      });
      
      return timer.cancel;
    }, [name.value, email.value]);
    
    return Column(children: [
      TextField(onChanged: (v) => name.value = v),
      TextField(onChanged: (v) => email.value = v),
    ]);
  }
}
```

---

## Best Practices

### ✅ DO

1. **Use hooks for side effects, Bloc for business logic**
   ```dart
   useEffect(() => analytics.logEvent('page_view'), []); // ✅ Side effect
   bloc.add(LoadDataAction()); // ✅ Business logic
   ```

2. **Always specify dependencies**
   ```dart
   useEffect(() {
     // ...
   }, [userId, filter]); // ✅ Explicit deps
   ```

3. **Return cleanup functions**
   ```dart
   useEffect(() {
     final sub = stream.listen(...);
     return sub.cancel; // ✅ Cleanup
   }, [stream]);
   ```

4. **Use `useMemoized` for expensive operations**
   ```dart
   final sorted = useMemoized(
     () => items.sorted((a, b) => a.price.compareTo(b.price)),
     [items],
   );
   ```

### ❌ DON'T

1. **Don't use hooks for business state**
   ```dart
   // ❌ BAD: Business logic in hooks
   final user = useState<User?>(null);
   useEffect(() {
     fetchUser().then((u) => user.value = u);
   }, []);
   
   // ✅ GOOD: Use Bloc
   context.read<UserBloc>().add(LoadUserAction());
   ```

2. **Don't forget dependencies**
   ```dart
   useEffect(() {
     print(userName); // ❌ Not in deps list!
   }, []); // Will use stale value
   ```

3. **Don't call hooks conditionally**
   ```dart
   // ❌ BAD: Conditional hook
   if (isLoggedIn) {
     useState(0); // Hooks must be called unconditionally!
   }
   
   // ✅ GOOD: Condition inside hook
   final counter = useState(isLoggedIn ? 0 : null);
   ```

---

## Common Pitfalls

### Pitfall 1: Missing Cleanup

```dart
// ❌ Memory leak!
useEffect(() {
  final sub = bloc.events.listen(...);
  // Missing return!
}, []);

// ✅ Fixed
useEffect(() {
  final sub = bloc.events.listen(...);
  return sub.cancel; // Cleanup
}, []);
```

### Pitfall 2: Infinite Re-renders

```dart
// ❌ Infinite loop!
final count = useState(0);
useEffect(() {
  count.value++; // Triggers rebuild → useEffect → rebuild → ...
}, [count.value]);

// ✅ Fixed: No dependency
useEffect(() {
  Future.delayed(Duration(seconds: 1), () => count.value++);
  return null;
}, []); // Runs once
```

### Pitfall 3: Stale Closures

```dart
// ❌ Uses stale userName
useEffect(() {
  Timer.periodic(Duration(seconds: 1), (_) {
    print(userName); // Always prints initial value!
  });
}, []); // Missing userName dependency

// ✅ Fixed
useEffect(() {
  final timer = Timer.periodic(Duration(seconds: 1), (_) {
    print(userName);
  });
  return timer.cancel;
}, [userName]);
```

---

## Summary

| Hook | Purpose | Common Use Cases |
|------|---------|------------------|
| `useState` | Local state | Counters, toggles, form inputs |
| `useEffect` | Side effects | Subscriptions, timers, initial loads |
| `useMemoized` | Cache computation | Expensive calculations, filtering |
| `useCallback` | Cache functions | Performance optimization |
| `useRef` | Mutable reference | Controllers, focus nodes |

**Golden Rule**: 
- **Hooks** = UI side effects & local state
- **Bloc** = Business logic & global state

---

## Further Reading

- [Flutter Hooks Documentation](https://pub.dev/packages/flutter_hooks)
- [React Hooks Docs (Inspiration)](https://react.dev/reference/react)
- [BaseMviPage Implementation](file://../packages/framework/lib/src/base_mvi_page.dart)
