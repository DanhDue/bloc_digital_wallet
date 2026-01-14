// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

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

/// Success state with data (can be single object or list)
class {{feature_name.pascalCase()}}Success<T> extends {{feature_name.pascalCase()}}State {
  final T data;

  const {{feature_name.pascalCase()}}Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error state
class {{feature_name.pascalCase()}}Error extends {{feature_name.pascalCase()}}State {
  final String message;

  const {{feature_name.pascalCase()}}Error(this.message);

  @override
  List<Object?> get props => [message];
}
