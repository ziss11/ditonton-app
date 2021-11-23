import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/get_watchlist.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/cubit/watchlist_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movie/dummy_movie_objects.dart';
import '../../dummy_data/tv_series/dummy_tv_series_object.dart';
import 'watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlist,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistCubit cubit;
  late MockGetWatchlist mockGetWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlist = MockGetWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    cubit = WatchlistCubit(
      watchlist: mockGetWatchlist,
      getWatchListStatus: mockGetWatchListStatus,
      removeWatchlist: mockRemoveWatchlist,
      saveWatchlist: mockSaveWatchlist,
    );
  });

  group('Get Watchlist', () {
    test('should emit initial state', () {
      expect(cubit.state, WatchlistInitial());
    });
  });
  blocTest<WatchlistCubit, WatchlistState>(
    'should execute watchlist when function is called',
    build: () {
      when(mockGetWatchlist.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(mockGetWatchlist.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));

      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    verify: (cubit) => mockGetWatchlist.execute(),
  );
  blocTest<WatchlistCubit, WatchlistState>(
    'Should emit [Loading, Loaded] when movie data is gotten successfully',
    build: () {
      when(mockGetWatchlist.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      WatchlistLoading(),
      WatchlistLoaded(testMovieList),
    ],
    verify: (cubit) => mockGetWatchlist.execute(),
  );
  blocTest<WatchlistCubit, WatchlistState>(
    'Should emit [Loading, Initial] when tv data is gotten successfully',
    build: () {
      when(mockGetWatchlist.execute()).thenAnswer((_) async => const Right([]));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      WatchlistLoading(),
      WatchlistInitial(),
    ],
    verify: (cubit) => mockGetWatchlist.execute(),
  );
  blocTest<WatchlistCubit, WatchlistState>(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetWatchlist.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Can\'t get data')));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      WatchlistLoading(),
      const WatchlistError('Can\'t get data'),
    ],
    verify: (cubit) => mockGetWatchlist.execute(),
  );

  group('Watchlist status', () {
    blocTest<WatchlistCubit, WatchlistState>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(testMovie.id))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(testMovie.id),
      expect: () => [const WatchlistStatus(true)],
    );
  });

  group('Save Watchlist', () {
    blocTest<WatchlistCubit, WatchlistState>(
      'should execute save watchlist when function is called',
      build: () {
        when(mockSaveWatchlist.execute(testMovie))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovie.id))
            .thenAnswer((_) async => true);

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(testMovie),
      verify: (cubit) => mockSaveWatchlist.execute(testMovie),
    );
    group('Movie', () {
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist success',
        build: () {
          when(mockGetWatchListStatus.execute(testMovie.id))
              .thenAnswer((_) async => true);
          when(mockSaveWatchlist.execute(testMovie))
              .thenAnswer((_) async => const Right('Added to Watchlist'));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(testMovie),
        expect: () => [
          const WatchlistMessage('Added to Watchlist'),
          const WatchlistStatus(true),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(testMovie),
      );
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist failed',
        build: () {
          when(mockGetWatchListStatus.execute(testMovie.id))
              .thenAnswer((_) async => false);
          when(mockSaveWatchlist.execute(testMovie))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(testMovie),
        expect: () => [
          const WatchlistMessage('Failed'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(testMovie),
      );
    });
    group('Tv Series', () {
      final tTvSeries = Movie.watchlist(
        id: testTvSeries.id!,
        overview: testTvSeries.overview,
        posterPath: testTvSeries.posterPath,
        title: testTvSeries.title,
        type: testTvSeries.type,
      );
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist success',
        build: () {
          when(mockGetWatchListStatus.execute(tTvSeries.id))
              .thenAnswer((_) async => true);
          when(mockSaveWatchlist.execute(tTvSeries))
              .thenAnswer((_) async => const Right('Added to Watchlist'));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(tTvSeries),
        expect: () => [
          const WatchlistMessage('Added to Watchlist'),
          const WatchlistStatus(true),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(tTvSeries),
      );
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist failed',
        build: () {
          when(mockGetWatchListStatus.execute(tTvSeries.id))
              .thenAnswer((_) async => false);
          when(mockSaveWatchlist.execute(tTvSeries))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(tTvSeries),
        expect: () => [
          const WatchlistMessage('Failed'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(tTvSeries),
      );
    });
  });

  group('Remove Watchlist', () {
    blocTest<WatchlistCubit, WatchlistState>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail.id))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.deleteWatchlist(testMovieDetail.id),
      verify: (cubit) =>
          verify(mockRemoveWatchlist.execute(testMovieDetail.id)),
    );

    group('Movie', () {
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when remove watchlist success',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail.id))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(mockGetWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);

          return cubit;
        },
        act: (cubit) => cubit.deleteWatchlist(testMovieDetail.id),
        expect: () => [
          const WatchlistMessage('Removed from Watchlist'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) {
          verify(mockRemoveWatchlist.execute(testMovieDetail.id));
          verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        },
      );

      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when Removed from Watchlist failed',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail.id))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
          when(mockGetWatchListStatus.execute(testMovieDetail.id))
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
          verify(mockGetWatchListStatus.execute(testMovieDetail.id));
        },
      );
    });

    group('Tv Series', () {
      final tTvSeries = Movie.watchlist(
        id: testTvSeries.id!,
        overview: testTvSeries.overview,
        posterPath: testTvSeries.posterPath,
        title: testTvSeries.title,
        type: testTvSeries.type,
      );
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when remove watchlist success',
        build: () {
          when(mockRemoveWatchlist.execute(tTvSeries.id))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(mockGetWatchListStatus.execute(tTvSeries.id))
              .thenAnswer((_) async => false);

          return cubit;
        },
        act: (cubit) => cubit.deleteWatchlist(tTvSeries.id),
        expect: () => [
          const WatchlistMessage('Removed from Watchlist'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) {
          verify(mockRemoveWatchlist.execute(tTvSeries.id));
          verify(mockGetWatchListStatus.execute(tTvSeries.id));
        },
      );

      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when Removed from Watchlist failed',
        build: () {
          when(mockRemoveWatchlist.execute(tTvSeries.id))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
          when(mockGetWatchListStatus.execute(tTvSeries.id))
              .thenAnswer((_) async => false);

          return cubit;
        },
        act: (cubit) => cubit.deleteWatchlist(tTvSeries.id),
        expect: () => [
          const WatchlistMessage('Failed'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) {
          verify(mockRemoveWatchlist.execute(tTvSeries.id));
          verify(mockGetWatchListStatus.execute(tTvSeries.id));
        },
      );
    });
  });
}
