import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_now_playing_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_now_playing_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvSeries,
])
void main() {
  late TvSeriesNowPlayingCubit cubit;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    cubit = TvSeriesNowPlayingCubit(
      nowPlayingTvSeries: mockGetNowPlayingTvSeries,
    );
  });

  group('Now playing', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesNowPlayingInitial());
    });
    blocTest<TvSeriesNowPlayingCubit, TvSeriesNowPlayingState>(
      'Should execute now playing list when function is called',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingTv(),
      verify: (cubit) => mockGetNowPlayingTvSeries.execute(),
    );
    blocTest<TvSeriesNowPlayingCubit, TvSeriesNowPlayingState>(
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
    blocTest<TvSeriesNowPlayingCubit, TvSeriesNowPlayingState>(
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
}
