import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecase/get_tv_series_episode.dart';

import '../../dummy_data/dummy_tv_series_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvSeriesRepository mockTvSeriesRepository;
  late GetTvSeriesEpisode usecase;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesEpisode(mockTvSeriesRepository);
  });

  const tId = 1;
  const tSeason = 1;
  group('Get Episode Tv Series', () {
    group('execute', () {
      test(
          'should return tv series episode from repository when function is called',
          () async {
        //arrange
        when(mockTvSeriesRepository.getTvSeriesEpisode(tId, tSeason))
            .thenAnswer((_) async => Right(testEpisodeList));
        //act
        final result = await usecase.execute(tId, tSeason);
        //assert
        expect(result, Right(testEpisodeList));
      });
    });
  });
}
