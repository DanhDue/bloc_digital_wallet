// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
import '../../domain/entities/{{{entity_name.snakeCase()}}}_entity.dart';

/// States for {{subfeature_name.pascalCase()}} subfeature
sealed class {{subfeature_name.pascalCase()}}State extends BaseState with EquatableMixin {
  const {{subfeature_name.pascalCase()}}State();

  @override
  List<Object?> get props => [];
}

/// Initial state
class {{subfeature_name.pascalCase()}}Initial extends {{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}Initial();
}

/// Loading state
class {{subfeature_name.pascalCase()}}Loading extends {{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}Loading();
}

/// Success state with data
class {{subfeature_name.pascalCase()}}Success extends {{subfeature_name.pascalCase()}}State {
  final List<{{entity_name.pascalCase()}}Entity> items;
  const {{subfeature_name.pascalCase()}}Success(this.items);

  @override
  List<Object?> get props => [items];
}

/// Error state
class {{subfeature_name.pascalCase()}}Error extends {{subfeature_name.pascalCase()}}State {
  final String message;
  const {{subfeature_name.pascalCase()}}Error(this.message);

  @override
  List<Object?> get props => [message];
}
