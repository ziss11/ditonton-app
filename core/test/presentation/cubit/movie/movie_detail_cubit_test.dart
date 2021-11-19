import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_movie_objects.dart';
import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    cubit = MovieDetailCubit(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchlistStatus,
      mockRemoveWatchlist,
      mockSaveWatchlist,
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

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovie),
      verify: (cubit) => mockGetMovieDetail.execute(testMovie.id),
    );
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute movie recommendation when function called',
      build: () {
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
        const MovieDetailLoaded(testMovieDetail),
        MovieRecommendationLoading(),
        MovieRecommendationLoaded(testMovieList),
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
  });

  group('Watchlist', () {
    blocTest<MovieDetailCubit, MovieDetailState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(testMovie.id))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(testMovie.id),
      expect: () => [const WatchlistStatus(true)],
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovie))
            .thenAnswer((_) async => const Right('Success'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovie),
      verify: (cubit) => verify(mockSaveWatchlist.execute(testMovie)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist message when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovie))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovie.id))
            .thenAnswer((_) async => true);

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovie),
      expect: () => [
        const WatchlistMessage('Added to Watchlist'),
        const WatchlistStatus(true),
      ],
      verify: (cubit) {
        verify(mockSaveWatchlist.execute(testMovie));
        verify(mockGetWatchlistStatus.execute(testMovie.id));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovie))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovie.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovie),
      expect: () => [
        const WatchlistMessage('Failed'),
        const WatchlistStatus(false),
      ],
      verify: (cubit) {
        verify(mockSaveWatchlist.execute(testMovie));
        verify(mockGetWatchlistStatus.execute(testMovie.id));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Right('Remove from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.deleteWatchlist(testMovieDetail.id),
      verify: (cubit) =>
          verify(mockRemoveWatchlist.execute(testMovieDetail.id)),
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist message when remove watchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Right('Remove from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.deleteWatchlist(testMovieDetail.id),
      expect: () => [
        const WatchlistMessage('Remove from Watchlist'),
        const WatchlistStatus(false),
      ],
      verify: (cubit) {
        verify(mockRemoveWatchlist.execute(testMovieDetail.id));
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailCubit, MovieDetailState>(
      'should update watchlist message when remove from watchlist failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.deleteWatchlist(testMovieDetail.id),
      expect: () => [
        const WatchlistMessage('Failed'),
        const WatchlistStatus(false),
      ],
      verify: (cubit) {
        verify(mockRemoveWatchlist.execute(testMovieDetail.id));
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
    );
  });
}
