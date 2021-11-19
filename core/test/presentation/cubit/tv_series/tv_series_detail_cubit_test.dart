import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_detail_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_recommendation_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_episode.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetDetailTvSeries,
  GetRecommendationTvSeries,
  GetTvSeriesEpisode,
  MovieDetailCubit,
])
void main() {
  late TvSeriesDetailCubit cubit;
  late MockGetDetailTvSeries mockGetDetailTvSeries;
  late MockGetRecommendationTvSeries mockGetRecommendationTvSeries;
  late MockGetTvSeriesEpisode mockGetTvSeriesEpisode;
  late MockMovieDetailCubit mockMovieDetailCubit;

  setUp(() {
    mockGetRecommendationTvSeries = MockGetRecommendationTvSeries();
    mockGetTvSeriesEpisode = MockGetTvSeriesEpisode();
    mockGetDetailTvSeries = MockGetDetailTvSeries();
    mockMovieDetailCubit = MockMovieDetailCubit();
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
      'should execute movie detail when function called',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      verify: (cubit) => mockGetDetailTvSeries.execute(testTvSeriesDetail.id),
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
    // test('should change state to Loading when usecase is called ', () {
    //   //arrange
    //   _arrangeUseCase();
    //   //act
    //   tvSeriesDetailNotifier.fetchTvSeriesDetail(tId);
    //   //assert
    //   expect(tvSeriesDetailNotifier.tvSeriesState, RequestState.loading);
    //   expect(listenerCallCount, 1);
    // });
    // test('should change tv when data is gotten successfully', () async {
    //   // arrange
    //   _arrangeUseCase();
    //   // act
    //   await tvSeriesDetailNotifier.fetchTvSeriesDetail(tId);
    //   // assert
    //   expect(tvSeriesDetailNotifier.tvSeriesState, RequestState.loaded);
    //   expect(tvSeriesDetailNotifier.tvSeriesDetail, testTvSeriesDetail);
    //   expect(listenerCallCount, 3);
    // });
    // test(
    //     'should change season and episode tv series when data is gotten successfully',
    //     () async {
    //   // arrange
    //   when(mockGetTvSeriesEpisode.execute(tId, tSeason))
    //       .thenAnswer((_) async => Right(tEpisodeList));
    //   // act
    //   await tvSeriesDetailNotifier.fetchTvSeriesEpisode(tId, tSeason);
    //   // assert
    //   expect(tvSeriesDetailNotifier.episodeState, RequestState.loaded);
    //   expect(tvSeriesDetailNotifier.episodeTvSeries, tEpisodeList);
    // });
    // test('should change tv when data is added to watchlist', () async {
    //   // arrange
    //   _arrangeUseCase();
    //   when(mockMovieDetailNotifier.isAddedToWatchlist).thenAnswer((_) => true);
    //   // act
    //   await tvSeriesDetailNotifier.fetchTvSeriesDetail(tId);
    //   // assert
    //   expect(tvSeriesDetailNotifier.tvSeriesState, RequestState.loaded);
    //   expect(tvSeriesDetailNotifier.tvSeriesDetail, testTvSeriesDetail);
    //   expect(listenerCallCount, 3);
    // });
  });

  // group('Get Episode Tv Series', () {
  //   test('should get data from the usecase', () async {
  //     //arrange
  //     when(mockGetTvSeriesEpisode.execute(tId, tSeason))
  //         .thenAnswer((_) async => Right(tEpisodeList));
  //     //act
  //     await tvSeriesDetailNotifier.fetchTvSeriesEpisode(tId, tSeason);
  //     //assert
  //     verify(mockGetTvSeriesEpisode.execute(tId, tSeason));
  //     expect(tvSeriesDetailNotifier.episodeTvSeries, tEpisodeList);
  //   });
  //   test('should change episode when data is gotten successfully', () async {
  //     // arrange
  //     when(mockGetTvSeriesEpisode.execute(tId, tSeason))
  //         .thenAnswer((_) async => Right(tEpisodeList));
  //     // act
  //     await tvSeriesDetailNotifier.fetchTvSeriesEpisode(tId, tSeason);
  //     // assert
  //     expect(tvSeriesDetailNotifier.episodeState, RequestState.loaded);
  //     expect(tvSeriesDetailNotifier.episodeTvSeries, tEpisodeList);
  //   });
  //   test('should update error message when request in successful', () async {
  //     // arrange
  //     when(mockGetTvSeriesEpisode.execute(tId, tSeason))
  //         .thenAnswer((_) async => const Left(ServerFailure('Failed')));
  //     // act
  //     await tvSeriesDetailNotifier.fetchTvSeriesEpisode(tId, tSeason);
  //     // assert
  //     expect(tvSeriesDetailNotifier.episodeState, RequestState.error);
  //     expect(tvSeriesDetailNotifier.message, 'Failed');
  //   });
  // });
  // group('on error', () {
  //   test('should return error when data is unsuccessful', () async {
  //     // arrange
  //     when(mockGetDetailTvSeries.execute(tId))
  //         .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
  //     when(mockGetRecommendationTvSeries.execute(tId))
  //         .thenAnswer((_) async => Right(tTvSeriesList));
  //     // act
  //     await tvSeriesDetailNotifier.fetchTvSeriesDetail(tId);
  //     // assert
  //     expect(tvSeriesDetailNotifier.tvSeriesState, RequestState.error);
  //     expect(tvSeriesDetailNotifier.message, 'Server Failure');
  //     expect(listenerCallCount, 2);
  //   });
  // });
}
