// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Domain Layer
export 'domain/entities/{{name.snakeCase()}}_entity.dart';
export 'domain/repositories/{{name.snakeCase()}}_repository.dart';
export 'domain/usecases/get_{{name.snakeCase()}}_usecase.dart';

// DI
export 'di/injection.dart';

// Router
export '{{name.snakeCase()}}_router.dart';

// Translations
export 'generated/translations.dart';
export '{{name.snakeCase()}}_strings.dart';

// Presentation Layer
export 'presentation/{{name.snakeCase()}}/models/{{name.snakeCase()}}_ui_model.dart';
export 'presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_page.dart';
export 'presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_bloc.dart';
export 'presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_state.dart';
export 'presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_event.dart';
export 'presentation/{{name.snakeCase()}}/{{name.snakeCase()}}_action.dart';

// DI
export 'di/injection.dart';

// Router
export '{{name.snakeCase()}}_router.dart';

// Translations
export 'generated/translations.dart';
