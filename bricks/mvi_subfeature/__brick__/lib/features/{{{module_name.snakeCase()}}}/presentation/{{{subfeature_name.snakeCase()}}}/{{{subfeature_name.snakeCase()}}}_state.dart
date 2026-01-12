// Copyright (c) {{year}}, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';
import '../../../../core/architecture/architecture.dart';
{{#needs_entity}}import '../../domain/entities/{{{entity_name.snakeCase()}}}_entity.dart';{{/needs_entity}}

sealed class {{subfeature_name.pascalCase()}}State extends BaseState with EquatableMixin {
  const {{subfeature_name.pascalCase()}}State();

  @override
  List<Object?> get props => [];
}

class {{subfeature_name.pascalCase()}}Initial extends {{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}Initial();
}

class {{subfeature_name.pascalCase()}}Loading extends {{subfeature_name.pascalCase()}}State {
  const {{subfeature_name.pascalCase()}}Loading();
}

class {{subfeature_name.pascalCase()}}Success extends {{subfeature_name.pascalCase()}}State {
  {{#needs_entity}}final {{entity_name.pascalCase()}}Entity data;
  const {{subfeature_name.pascalCase()}}Success(this.data);
  @override
  List<Object?> get props => [data];{{/needs_entity}}
  {{^needs_entity}}const {{subfeature_name.pascalCase()}}Success();{{/needs_entity}}
}

class {{subfeature_name.pascalCase()}}Error extends {{subfeature_name.pascalCase()}}State {
  final String message;
  const {{subfeature_name.pascalCase()}}Error(this.message);

  @override
  List<Object?> get props => [message];
}
