import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/get_top_rated_movies.dart';
import 'package:movie/presentation/cubit/movie_top_rated_cubit.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'movie_top_rated_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MovieTopRatedCubit cubit;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = MovieTopRatedCubit(
      topRatedMovies: mockGetTopRatedMovies,
    );
  });

  group('top rated movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieTopRatedInitial());
    });
    blocTest<MovieTopRatedCubit, MovieTopRatedState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovie(),
      verify: (cubit) => mockGetTopRatedMovies.execute(),
    );
    blocTest<MovieTopRatedCubit, MovieTopRatedState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovie(),
      expect: () => [
        MovieTopRatedLoading(),
        MovieTopRatedLoaded(testMovieList),
      ],
      verify: (cubit) => mockGetTopRatedMovies.execute(),
    );
    blocTest<MovieTopRatedCubit, MovieTopRatedState>(
      'Should emit [Loading, Error] when data is gotten failed',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovie(),
      expect: () => [
        MovieTopRatedLoading(),
        const MovieTopRatedError('Server Failure'),
      ],
      verify: (cubit) => mockGetTopRatedMovies.execute(),
    );
  });
}
