// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Data Layer
// SettingsLocalDataSource is exported here as a deliberate, documented
// exception: the root app's lib/core/app_initializer/logging_initializer.dart
// resolves it via getIt<SettingsLocalDataSource>() to apply saved
// module/appender logging toggles during app bootstrap.
export 'data/datasources/local/settings_local_datasource.dart';

// Domain Layer
export 'domain/entities/settings_entity.dart';
export 'domain/entities/supported_language.dart';
export 'domain/entities/language_sync_status.dart';
export 'domain/repositories/settings_repository.dart';
export 'domain/usecases/get_settings_usecase.dart';
export 'domain/usecases/get_cached_languages_usecase.dart';
export 'domain/usecases/bootstrap_usecase.dart';
export 'domain/usecases/fetch_translation_usecase.dart';
export 'domain/usecases/get_dynamic_localization_usecase.dart';
export 'domain/usecases/load_bundled_fallback_usecase.dart';
export 'domain/usecases/update_user_language_usecase.dart';

// Sync Models
// SyncBootstrapResponse is exported here as a deliberate, documented exception:
// onboard's splash_bloc.dart consumes it directly (whitelisted onboard→settings
// coupling; see scripts/module_boundary_whitelist.txt and Task 14's ruling).
export 'data/models/sync/sync_bootstrap_response.dart';

// DI
export 'di/injection.dart';

// Router
export 'settings_router.dart';

// Translations
export 'generated/translations.dart';
export 'settings_strings.dart';

// Presentation Layer
export 'presentation/settings/models/settings_ui_model.dart';
export 'presentation/settings/models/logging_toggle_constants.dart';
export 'presentation/settings/settings_page.dart';
export 'presentation/settings/settings_bloc.dart';
export 'presentation/settings/settings_state.dart';
export 'presentation/settings/settings_event.dart';
export 'presentation/settings/settings_action.dart';
export 'presentation/settings/widgets/settings_section_widget.dart';
export 'presentation/settings/widgets/settings_item_widget.dart';
export 'presentation/settings/talker_console_settings.dart';
