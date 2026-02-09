// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// Domain Layer
export 'domain/entities/coin_market_entity.dart';
export 'domain/repositories/trends_repository.dart';
export 'domain/usecases/get_coin_markets_usecase.dart';

// Data Layer
export 'data/models/coin_market_model.dart';

// DI
export 'di/injection.dart';

// Router
export 'trends_router.dart';

// Translations
export 'generated/translations.dart';
export 'trends_strings.dart';

// Presentation Layer
export 'presentation/trends/models/coin_market_ui_model.dart';
export 'presentation/trends/trends_page.dart';
export 'presentation/trends/trends_bloc.dart';
export 'presentation/trends/trends_state.dart';
export 'presentation/trends/trends_event.dart';
export 'presentation/trends/trends_action.dart';
export 'presentation/trends/widgets/trends_search_bar.dart';
export 'presentation/trends/widgets/coin_market_item.dart';
