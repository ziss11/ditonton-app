import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/presentation/cubit/tv_series/tv_series_popular_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'tv_series_popular_cubit_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late TvSeriesPopularCubit cubit;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    cubit = TvSeriesPopularCubit(
      popularTvSeries: mockGetPopularTvSeries,
    );
  });

  group('Popular', () {
    test('should emit initial state', () {
      expect(cubit.state, TvSeriesPopularInitial());
    });
    blocTest<TvSeriesPopularCubit, TvSeriesPopularState>(
      'Should execute popular list when function is called',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularTv(),
      verify: (cubit) => mockGetPopularTvSeries.execute(),
    );
    blocTest<TvSeriesPopularCubit, TvSeriesPopularState>(
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
    blocTest<TvSeriesPopularCubit, TvSeriesPopularState>(
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
}
