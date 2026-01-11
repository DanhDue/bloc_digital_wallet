// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/{{{feature_name.snakeCase()}}}_entity.dart';

/// States for {{feature_name.pascalCase()}} feature
sealed class {{feature_name.pascalCase()}}State extends BaseState with EquatableMixin {
  const {{feature_name.pascalCase()}}State();
}

/// Initial state
class {{feature_name.pascalCase()}}Initial extends {{feature_name.pascalCase()}}State {
  const {{feature_name.pascalCase()}}Initial();
  
  @override
  List<Object?> get props => [];
}

/// Loading state
class {{feature_name.pascalCase()}}Loading extends {{feature_name.pascalCase()}}State {
  const {{feature_name.pascalCase()}}Loading();
  
  @override
  List<Object?> get props => [];
}

/// Loaded state with list
class {{feature_name.pascalCase()}}sLoaded extends {{feature_name.pascalCase()}}State {
  final List<{{feature_name.pascalCase()}}Entity> items;
  
  const {{feature_name.pascalCase()}}sLoaded(this.items);
  
  @override
  List<Object?> get props => [items];
}

/// Loaded state with single item
class {{feature_name.pascalCase()}}Loaded extends {{feature_name.pascalCase()}}State {
  final {{feature_name.pascalCase()}}Entity item;
  
  const {{feature_name.pascalCase()}}Loaded(this.item);
  
  @override
  List<Object?> get props => [item];
}

/// Error state
class {{feature_name.pascalCase()}}Error extends {{feature_name.pascalCase()}}State {
  final String message;
  
  const {{feature_name.pascalCase()}}Error(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Empty state
class {{feature_name.pascalCase()}}Empty extends {{feature_name.pascalCase()}}State {
  const {{feature_name.pascalCase()}}Empty();
  
  @override
  List<Object?> get props => [];
}
