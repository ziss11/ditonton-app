import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/tv_series/get_detail_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_recommendation_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_episode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetDetailTvSeries,
  GetRecommendationTvSeries,
  GetTvSeriesEpisode,
])
void main() {
  late TvSeriesDetailCubit cubit;
  late MockGetDetailTvSeries mockGetDetailTvSeries;
  late MockGetRecommendationTvSeries mockGetRecommendationTvSeries;
  late MockGetTvSeriesEpisode mockGetTvSeriesEpisode;

  setUp(() {
    mockGetRecommendationTvSeries = MockGetRecommendationTvSeries();
    mockGetTvSeriesEpisode = MockGetTvSeriesEpisode();
    mockGetDetailTvSeries = MockGetDetailTvSeries();
    cubit = TvSeriesDetailCubit(
      detailTvSeries: mockGetDetailTvSeries,
      recommendationTvSeries: mockGetRecommendationTvSeries,
      tvSeriesEpisode: mockGetTvSeriesEpisode,
    );
  });

  group('Get Tv Series Detail and Recommendation Tv Series', () {
    test('initial state should be empty', () {
      expect(cubit.state, TvSeriesDetailInitial());
    });
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should execute tv detail when function called',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      verify: (cubit) => mockGetDetailTvSeries.execute(testTvSeries.id),
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      expect: () => [
        TvSeriesDetailLoading(),
        const TvSeriesDetailLoaded(testTvSeriesDetail),
        TvSeriesRecommendationLoading(),
        TvSeriesRecommendationLoaded(testTvSeriesList),
      ],
      verify: (cubit) {
        mockGetDetailTvSeries.execute(testTvSeries.id);
        mockGetRecommendationTvSeries.execute(testTvSeries.id);
      },
    );
  });

  group('Get Episode Tv Series', () {
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should get data from the usecase',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1))
            .thenAnswer((_) async => Right(testEpisodeList));
        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfuly',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1))
            .thenAnswer((_) async => Right(testEpisodeList));

        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      expect: () => [
        TvSeriesEpisodeLoading(),
        TvSeriesEpisodeLoaded(testEpisodeList),
      ],
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      expect: () => [
        TvSeriesEpisodeLoading(),
        const TvSeriesEpisodeError('Server Failure'),
      ],
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
  });
}
