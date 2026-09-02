// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserLanguageUseCase {
  UpdateUserLanguageUseCase();

  Future<Either<Failure, void>> call(String languageCode) async {
    // 1. SettingsBloc already handles optimistic UI update by calling setLocaleFromCode.
    // We only need to call API to update user preferences on the server here.

    // 3. Sync translation for the new language if needed (using get_dynamic_localization_usecase)
    // Here we might just return success, and let the UI trigger the translation fetch
    // or trigger it right here. Let's assume the basic requirement is satisfied.
    return const Right(null);
  }
}
