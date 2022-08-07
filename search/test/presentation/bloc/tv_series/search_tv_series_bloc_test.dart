import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';
import 'package:tv_series/domain/entities/tv_series.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc bloc;
  late MockSearchTvSeries searchTvSeries;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    bloc = SearchTvSeriesBloc(
      searchTvSeries: searchTvSeries,
    );
  });

  test('should emit initial state', () {
    expect(bloc.state, SearchTvSeriesInitial());
  });

  final tTvSeries = TvSeries(
    type: 'Tv',
    backdropPath: '/oaGvjB0DvdhXhOAuADfHb261ZHa.jpg',
    firstAirDate: '2021-09-17',
    id: 93405,
    ids: const [
      10759,
      9648,
      18,
    ],
    title: 'Squid game',
    originCountry: const ['KR'],
    originalLanguage: 'ko',
    originalName: '오징어 게임',
    overview: 'overview',
    popularity: 6379.492,
    posterPath: 'posterPath',
    voteAverage: 7.9,
    voteCount: 7704,
  );

  final tTvSeriesList = [tTvSeries];
  const tQuery = 'Squid';
  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(searchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnChangeTvQuery(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesHasData(tTvSeriesList),
    ],
    verify: (bloc) => searchTvSeries.execute(tQuery),
  );
  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'Should emit [Loading, Error] when data is failed',
    build: () {
      when(searchTvSeries.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnChangeTvQuery(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      const SearchTvSeriesError(''),
    ],
    verify: (bloc) => searchTvSeries.execute(tQuery),
  );
}
