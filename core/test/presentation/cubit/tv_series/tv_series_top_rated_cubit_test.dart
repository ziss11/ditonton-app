import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_top_rated_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_top_rated_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TvSeriesTopRatedCubit cubit;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    cubit = TvSeriesTopRatedCubit(
      topRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  group('Top Rated', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesTopRatedInitial());
    });
    blocTest<TvSeriesTopRatedCubit, TvSeriesTopRatedState>(
      'Should execute top rated list when function is called',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedTv(),
      verify: (cubit) => mockGetTopRatedTvSeries.execute(),
    );
    blocTest<TvSeriesTopRatedCubit, TvSeriesTopRatedState>(
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
    blocTest<TvSeriesTopRatedCubit, TvSeriesTopRatedState>(
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
