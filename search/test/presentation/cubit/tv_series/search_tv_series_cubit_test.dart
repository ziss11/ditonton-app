import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:search/presentation/cubit/tv_series/search_tv_series_cubit.dart';

import 'search_tv_series_cubit_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesCubit searchCubit;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchCubit = SearchTvSeriesCubit(
      searchTvSeries: mockSearchTvSeries,
    );
  });

  test('state should initial', () {
    expect(searchCubit.state, SearchTvSeriesInitial());
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
  final tTvList = <TvSeries>[tTvSeries];
  const tQuery = 'squid';

  blocTest<SearchTvSeriesCubit, SearchTvSeriesState>(
    'Should emit [Loading, Loaded] when data is gotten is successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchCubit;
    },
    act: (cubit) => cubit.fetchSearchTvSeries(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesLoaded(tTvList),
    ],
    verify: (cubit) => {
      cubit.searchTvSeries.execute(tQuery),
    },
  );

  blocTest<SearchTvSeriesCubit, SearchTvSeriesState>(
    'Should emit [Loading, Error] when Error',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchCubit;
    },
    act: (cubit) => cubit.fetchSearchTvSeries(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      const SearchTvSeriesError('Server Failure'),
    ],
    verify: (cubit) => {
      cubit.searchTvSeries.execute(tQuery),
    },
  );
}
