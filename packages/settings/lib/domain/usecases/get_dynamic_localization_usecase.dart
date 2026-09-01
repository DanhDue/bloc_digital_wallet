// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class GetDynamicLocalizationUseCase {
  final SettingsRepository _repository;

  GetDynamicLocalizationUseCase(this._repository);

  Future<Either<Failure, void>> call(String languageCode) async {
    // 1. Get cached version
    final cachedVersionResult = await _repository.getCachedTranslationVersion(languageCode);
    final cachedVersion = cachedVersionResult.fold((l) => null, (r) => r);

    // 2. Get cached JSON to compute checksum
    final cachedJsonResultForChecksum = await _repository.getCachedTranslationJson(languageCode);
    final cachedJsonForChecksum = cachedJsonResultForChecksum.fold((l) => null, (r) => r);
    String? checksum;
    if (cachedJsonForChecksum != null) {
      checksum = ChecksumUtils.computeSha256(cachedJsonForChecksum);
      // Nạp dữ liệu từ cache ngay lập tức để UI phản hồi nhanh
      if (cachedJsonForChecksum.isNotEmpty) {
        await LocalizationManager.instance.applyDynamicTranslations(
          cachedJsonForChecksum,
          targetLanguageCode: languageCode,
        );
      }
    }

    // 3. Fetch localization overrides (full or delta)
    final responseOrFailure = await _repository.getLocalizationOverrides(
      languageCode,
      sinceVersion: cachedVersion,
      eTag: checksum != null ? '"$checksum"' : null,
    );

    if (responseOrFailure.isLeft()) {
      final failure = responseOrFailure.fold((l) => l, (r) => throw Exception('unreachable'));
      if (failure is ServerFailure && failure.code == 304) {
        // 304 Not Modified: Đã nạp từ cache ở trên, không cần nạp lại
        return const Right(null);
      }
      return Left(failure);
    }

    final response = responseOrFailure.getOrElse(() => throw Exception('unreachable'));

    Map<String, dynamic> jsonMap = response.translations;
    final version = response.version;

    // 4. Nếu server trả về rỗng hoặc version không đổi, bỏ qua vì đã nạp cache ở trên
    if ((jsonMap.isEmpty || version == cachedVersion) && cachedVersion != null) {
      return const Right(null);
    } else {
      // Có dữ liệu mới: Lưu cache mới
      await _repository.saveCachedTranslationJson(languageCode, jsonMap);
      await _repository.saveCachedTranslationVersion(
        languageCode,
        version,
        ChecksumUtils.computeSha256(jsonMap),
      );

      // 5. Nạp lại dữ liệu mới vào bộ nhớ và rebuild UI
      await LocalizationManager.instance.applyDynamicTranslations(
        jsonMap,
        targetLanguageCode: languageCode,
      );
    }

    return const Right(null);
  }
}
