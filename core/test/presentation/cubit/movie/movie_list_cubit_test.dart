import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/cubit/movie/movie_list_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_movie_objects.dart';
import 'movie_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieListCubit cubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = MovieListCubit(
        nowPlayingMovies: mockGetNowPlayingMovies,
        popularMovies: mockGetPopularMovies,
        topRatedMovies: mockGetTopRatedMovies);
  });

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieListInitial());
    });
    blocTest<MovieListCubit, MovieListState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovie(),
      verify: (cubit) => mockGetNowPlayingMovies.execute(),
    );
    blocTest<MovieListCubit, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovie(),
      expect: () => [
        MovieNowPlayingLoading(),
        MovieNowPlayingLoaded(testMovieList),
      ],
      verify: (cubit) => mockGetNowPlayingMovies.execute(),
    );
    blocTest<MovieListCubit, MovieListState>(
      'Should emit [Loading, Error] when data is gotten failed',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovie(),
      expect: () => [
        MovieNowPlayingLoading(),
        const MovieNowPlayingError('Server Failure'),
      ],
      verify: (cubit) => mockGetNowPlayingMovies.execute(),
    );
  });

  group('popular movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieListInitial());
    });
    blocTest<MovieListCubit, MovieListState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchPopularMovie(),
      verify: (cubit) => mockGetPopularMovies.execute(),
    );
    blocTest<MovieListCubit, MovieListState>(
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
    blocTest<MovieListCubit, MovieListState>(
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

  group('top rated movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieListInitial());
    });
    blocTest<MovieListCubit, MovieListState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchTopRatedMovie(),
      verify: (cubit) => mockGetTopRatedMovies.execute(),
    );
    blocTest<MovieListCubit, MovieListState>(
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
    blocTest<MovieListCubit, MovieListState>(
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
