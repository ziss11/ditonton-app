import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_list_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries,
])
void main() {
  late TvSeriesListCubit cubit;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    cubit = TvSeriesListCubit(
      nowPlayingTvSeries: mockGetNowPlayingTvSeries,
      popularTvSeries: mockGetPopularTvSeries,
      topRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  group('Now playing', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesListInitial());
    });
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should execute now playing list when function is called',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingTv(),
      verify: (cubit) => mockGetNowPlayingTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingTv(),
      expect: () => [
        TvSeriesNowPlayingLoading(),
        TvSeriesNowPlayingLoaded(testTvSeriesList),
      ],
      verify: (cubit) => mockGetNowPlayingTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingTv(),
      expect: () => [
        TvSeriesNowPlayingLoading(),
        const TvSeriesNowPlayingError('Server Failure'),
      ],
      verify: (cubit) => mockGetNowPlayingTvSeries.execute(),
    );
  });

  group('Popular', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesListInitial());
    });
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should execute popular list when function is called',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTv(),
      verify: (cubit) => mockGetPopularTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTv(),
      expect: () => [
        TvSeriesPopularLoading(),
        TvSeriesPopularLoaded(testTvSeriesList),
      ],
      verify: (cubit) => mockGetPopularTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTv(),
      expect: () => [
        TvSeriesPopularLoading(),
        const TvSeriesPopularError('Server Failure'),
      ],
      verify: (cubit) => mockGetPopularTvSeries.execute(),
    );
  });

  group('Top Rated', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesListInitial());
    });
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should execute top rated list when function is called',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTv(),
      verify: (cubit) => mockGetTopRatedTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTv(),
      expect: () => [
        TvSeriesTopRatedLoading(),
        TvSeriesTopRatedLoaded(testTvSeriesList),
      ],
      verify: (cubit) => mockGetTopRatedTvSeries.execute(),
    );
    blocTest<TvSeriesListCubit, TvSeriesListState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTv(),
      expect: () => [
        TvSeriesTopRatedLoading(),
        const TvSeriesTopRatedError('Server Failure'),
      ],
      verify: (cubit) => mockGetTopRatedTvSeries.execute(),
    );
  });
}
