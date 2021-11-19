import 'package:core/domain/usecases/tv_series/get_detail_tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvSeriesRepository mockTvSeriesRepository;
  late GetDetailTvSeries usecase;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetDetailTvSeries(mockTvSeriesRepository);
  });

  const tId = 1;
  group('Get Detail Tv Series', () {
    group('execute', () {
      test(
          'should return tv series details from repository when function is called',
          () async {
        //arrange
        when(mockTvSeriesRepository.getTvSeriesDetail(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        //act
        final result = await usecase.execute(tId);
        //assert
        expect(result, const Right(testTvSeriesDetail));
      });
    });
  });
}
