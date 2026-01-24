import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/d3_votion_remote_datasource.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/d3_votion_res_object.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/models/sample.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/repositories/d3_votion_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockD3VotionRemoteDataSource implements D3VotionRemoteDataSource {
  @override
  Future<Either<Failure, D3VotionResObject>> getD3Votion(String word) async {
    if (word == 'error') {
      return const Left(ServerFailure(message: 'error'));
    }
    return const Right(D3VotionResObject(
      word: 'single',
      definition: 'def',
      ipa: 'ipa',
      samples: [Sample(text: 'text', vietnameseText: 'vn', audioLink: 'link')],
    ));
  }
}

void main() {
  late D3VotionRepositoryImpl repository;
  late MockD3VotionRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockD3VotionRemoteDataSource();
    repository = D3VotionRepositoryImpl(mockRemoteDataSource);
  });

  test('should return entity mapped from model', () async {
    final result = await repository.getD3Votion('single');

    expect(result.isRight(), true);
    result.fold(
      (l) => fail('should be right'),
      (r) {
        expect(r.word, 'single');
        expect(r.definition, 'def');
        expect(r.samples?.length, 1);
        expect(r.samples?.first.vietnameseText, 'vn');
      },
    );
  });
}
