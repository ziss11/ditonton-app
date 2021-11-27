import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/get_now_playing_movies.dart';
import 'package:movie/presentation/cubit/movie_now_playing_cubit.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'movie_now_playing_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
])
void main() {
  late MovieNowPlayingCubit cubit;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    cubit = MovieNowPlayingCubit(
      nowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(cubit.state, MovieNowPlayingInitial());
    });
    blocTest<MovieNowPlayingCubit, MovieNowPlayingState>(
      'should execute movie list when function called',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchNowPlayingMovie(),
      verify: (cubit) => mockGetNowPlayingMovies.execute(),
    );
    blocTest<MovieNowPlayingCubit, MovieNowPlayingState>(
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
    blocTest<MovieNowPlayingCubit, MovieNowPlayingState>(
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
}
