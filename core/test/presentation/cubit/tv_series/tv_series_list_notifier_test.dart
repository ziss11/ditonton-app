import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:core/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvSeriesListNotifier provider;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    provider = TvSeriesListNotifier(
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvSeries = TvSeries(
    type: 'Tv',
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    id: 1,
    ids: const [1, 2, 3],
    title: 'title',
    originCountry: const ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 0,
    posterPath: 'posterPath',
    voteAverage: 0.0,
    voteCount: 0,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];
  group('Get Now Playing Tv Series', () {
    test('initialState should be empty', () {
      expect(provider.nowPlayingState, RequestState.empty);
    });
    test('should get data from usecase', () async {
      //arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchNowPlayingTvSeries();
      //assert
      verify(mockGetNowPlayingTvSeries.execute());
    });
    test('should change state to loading when data is callded', () async {
      //arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchNowPlayingTvSeries();
      //assert
      expect(provider.nowPlayingState, RequestState.loading);
    });
    test('should change tv series when data is gotten successfully', () async {
      //arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      await provider.fetchNowPlayingTvSeries();
      //assert
      expect(provider.nowPlayingState, RequestState.loaded);
      expect(provider.nowPlayingTvSeriess, tTvSeriesList);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      //act
      await provider.fetchNowPlayingTvSeries();
      //assert
      expect(provider.nowPlayingState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Popular Tv Series', () {
    test('initialState should be empty', () {
      expect(provider.popularTvSeriessState, RequestState.empty);
    });
    test('should get data from usecase', () async {
      //arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchPopularTvSeriess();
      //assert
      verify(mockGetPopularTvSeries.execute());
    });
    test('should change state to loading when data is callded', () async {
      //arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchPopularTvSeriess();
      //assert
      expect(provider.popularTvSeriessState, RequestState.loading);
    });
    test('should change tv series when data is gotten successfully', () async {
      //arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      await provider.fetchPopularTvSeriess();
      //assert
      expect(provider.popularTvSeriessState, RequestState.loaded);
      expect(provider.popularTvSeriess, tTvSeriesList);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      //act
      await provider.fetchPopularTvSeriess();
      //assert
      expect(provider.popularTvSeriessState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
  group('Get Top Rated Tv Series', () {
    test('initialState should be empty', () {
      expect(provider.topTvRatedSeriesState, RequestState.empty);
    });
    test('should get data from usecase', () async {
      //arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchTopRatedTvSeries();
      //assert
      verify(mockGetTopRatedTvSeries.execute());
    });
    test('should change state to loading when data is callded', () async {
      //arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      provider.fetchTopRatedTvSeries();
      //assert
      expect(provider.topTvRatedSeriesState, RequestState.loading);
    });
    test('should change tv series when data is gotten successfully', () async {
      //arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      //act
      await provider.fetchTopRatedTvSeries();
      //assert
      expect(provider.topTvRatedSeriesState, RequestState.loaded);
      expect(provider.topRatedTvSeries, tTvSeriesList);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      //arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      //act
      await provider.fetchTopRatedTvSeries();
      //assert
      expect(provider.topTvRatedSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
