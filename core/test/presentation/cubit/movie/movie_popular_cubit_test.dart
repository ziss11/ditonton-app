import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/cubit/movie/movie_popular_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_movie_objects.dart';
import 'movie_popular_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MoviePopularCubit cubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = MoviePopularCubit(
      popularMovies: mockGetPopularMovies,
    );
  });

  group('popular movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MoviePopularInitial());
    });
    blocTest<MoviePopularCubit, MoviePopularState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovie(),
      verify: (cubit) => mockGetPopularMovies.execute(),
    );
    blocTest<MoviePopularCubit, MoviePopularState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovie(),
      expect: () => [
        MoviePopularLoading(),
        MoviePopularLoaded(testMovieList),
      ],
      verify: (cubit) => mockGetPopularMovies.execute(),
    );
    blocTest<MoviePopularCubit, MoviePopularState>(
      'Should emit [Loading, Error] when data is gotten failed',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovie(),
      expect: () => [
        MoviePopularLoading(),
        const MoviePopularError('Server Failure'),
      ],
      verify: (cubit) => mockGetPopularMovies.execute(),
    );
  });
}
