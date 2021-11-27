import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecase/get_now_playing_tv_series.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetNowPlayingTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];
  group('GetNowPlayingTvSeries Test', () {
    group('execute', () {
      test(
          'should get list of now playing tv series list when function is called',
          () async {
        //arrange
        when(mockTvSeriesRepository.getNowPlayingTvSeries())
            .thenAnswer((_) async => Right(tTvSeries));
        //act
        final result = await usecase.execute();
        //assert
        expect(result, Right(tTvSeries));
      });
    });
  });
}
