import 'package:dartz/dartz.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  const String tQuery = 'Squid Game';
  final tTvSeries = <TvSeries>[];

  test('should return search tv series list', () async {
    //arrange
    when(mockTvSeriesRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTvSeries));
    //act
    final result = await usecase.execute(tQuery);
    //assert
    expect(result, Right(tTvSeries));
  });
}
