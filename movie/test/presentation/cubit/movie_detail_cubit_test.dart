import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecase/get_movie_detail.dart';
import 'package:movie/domain/usecase/get_movie_recommendations.dart';
import 'package:movie/presentation/cubit/movie_detail_cubit.dart';

import '../../dummy_data/dummy_movie_objects.dart';
import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  group('Get Movie Detail and Recommendations Movie', () {
    test('initial state should be empty ', () {
      expect(cubit.state, MovieDetailInitial());
    });

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute movie detail when function called',
      build: () {
        when(mockGetMovieDetail.execute(testMovie.id))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testMovie.id))
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(testMovie.id),
      verify: (cubit) => mockGetMovieDetail.execute(testMovie.id),
    );
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute movie recommendation when function called',
      build: () {
        when(mockGetMovieDetail.execute(testMovie.id))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testMovie.id))
            .thenAnswer((_) async => Right(testMovieList));

        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(testMovie.id),
      verify: (cubit) => mockGetMovieRecommendations.execute(testMovie.id),
    );
    blocTest<MovieDetailCubit, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(testMovie.id))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testMovie.id))
            .thenAnswer((_) async => Right(testMovieList));
        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(testMovie.id),
      expect: () => [
        MovieDetailLoading(),
        MovieRecommendationLoading(),
        MovieDetailLoaded(testMovieDetail, testMovieList),
      ],
      verify: (cubit) {
        verify(mockGetMovieDetail.execute(testMovie.id));
      },
    );
    blocTest<MovieDetailCubit, MovieDetailState>(
      'Should emit [Loading, Error] when data is gotten failed',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Left(ServerFailure('')));
        when(mockGetMovieRecommendations.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Left(ServerFailure('')));

        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(testMovieDetail.id),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError(''),
      ],
      verify: (cubit) {
        verify(mockGetMovieDetail.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'Should emit [Loading, Error] when recomendation is gotten failed',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Left(ServerFailure('')));

        return cubit;
      },
      act: (cubit) => cubit.fetchMovieDetail(testMovieDetail.id),
      expect: () => [
        MovieDetailLoading(),
        MovieRecommendationLoading(),
        const MovieRecommendationError(''),
      ],
      verify: (cubit) {
        verify(mockGetMovieDetail.execute(testMovieDetail.id));
      },
    );
  });
}
