import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/movie/search_movies.dart';
import 'package:search/presentation/cubit/movie/search_movies_cubit.dart';

import 'search_movie_cubit_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesCubit searchCubit;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchCubit = SearchMoviesCubit(
      searchMovies: mockSearchMovies,
    );
  });

  test('initial state should be empty', () {
    expect(searchCubit.state, SearchMoviesInitial());
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
    title: 'Spiderman',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  blocTest<SearchMoviesCubit, SearchMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchCubit;
    },
    act: (cubit) => cubit.fetchSearchMovies(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesLoaded(tMovieList),
    ],
    verify: (cubit) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<SearchMoviesCubit, SearchMoviesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

      return searchCubit;
    },
    act: (cubit) => cubit.fetchSearchMovies(tQuery),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchMoviesLoading(),
      const SearchMoviesError('Server Failure'),
    ],
    verify: (cubit) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );
}
