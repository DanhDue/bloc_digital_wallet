import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/d3_votion_remote_datasource.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/sample.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/repositories/d3_votion_repository.dart';

@LazySingleton(as: D3VotionRepository)
class D3VotionRepositoryImpl implements D3VotionRepository {
  final D3VotionRemoteDataSource _remoteDataSource;

  D3VotionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, D3VotionEntity>> getD3Votion(String word) async {
    final result = await _remoteDataSource.getD3Votion(word);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }
}

extension on D3VotionResObject {
  D3VotionEntity toEntity() {
    return D3VotionEntity(
      word: word,
      definition: definition,
      ipa: ipa,
      samples: samples?.map((e) => e.toEntity()).toList(),
    );
  }
}

extension on Sample {
  SampleEntity toEntity() {
    return SampleEntity(
      text: text,
      vietnameseText: vietnameseText,
      audioLink: audioLink,
    );
  }
}
