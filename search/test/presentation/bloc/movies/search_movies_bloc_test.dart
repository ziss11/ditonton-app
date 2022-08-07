import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:search/domain/usecases/movie/search_movies.dart';
import 'package:search/presentation/bloc/movies/search_movies_bloc.dart';

import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesBloc bloc;
  late MockSearchMovies searchMovies;

  setUp(() {
    searchMovies = MockSearchMovies();
    bloc = SearchMoviesBloc(
      searchMovies: searchMovies,
    );
  });

  test('should emit initial state', () {
    expect(bloc.state, SearchMoviesInitial());
  });

  final tMovieModel = Movie(
    type: 'Movie',
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(searchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnChangeMovieQuery(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesHasData(tMovieList),
    ],
    verify: (bloc) => searchMovies.execute(tQuery),
  );
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Error] when data is failed',
    build: () {
      when(searchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnChangeMovieQuery(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      const SearchMoviesError(''),
    ],
    verify: (bloc) => searchMovies.execute(tQuery),
  );
}
