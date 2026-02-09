## 0.0.1+1

* Refactored `MviBloc`, `BaseMviPage`, and `BaseMviStatefulPage` to require generic `Action` type parameter.
* Added `BaseAction`, `BaseState`, and `BaseEvent` constraints to `MviBloc`.
* Simplified MVI page implementation with automatic BLoC provision and event listening.
