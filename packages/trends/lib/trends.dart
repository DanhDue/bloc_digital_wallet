// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Domain Layer
export 'domain/entities/trends_entity.dart';
export 'domain/repositories/trends_repository.dart';
export 'domain/usecases/get_trends_usecase.dart';

// DI
export 'di/injection.dart';

// Router
export 'trends_router.dart';

// Translations
export 'generated/translations.dart';
export 'trends_strings.dart';

// Presentation Layer
export 'presentation/trends/models/trends_ui_model.dart';
export 'presentation/trends/trends_page.dart';
export 'presentation/trends/trends_bloc.dart';
export 'presentation/trends/trends_state.dart';
export 'presentation/trends/trends_event.dart';
export 'presentation/trends/trends_action.dart';
