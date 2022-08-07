import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
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
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';

import '../../../../tv_series/test/dummy_data/dummy_tv_series_object.dart';
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

  const tMovieDetail = MovieDetail(
    type: 'Movie',
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    type: 'Movie',
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 1,
    originalTitle: 'Spider-Man',
    overview: 'overview',
    popularity: 60.441,
    posterPath: 'posterPath',
    releaseDate: '2002-05-01',
    title: 'title',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = [tMovie];
  group('Get Watchlist', () {
    test('should emit initial state', () {
      expect(cubit.state, WatchlistInitial());
    });
  });
  blocTest<WatchlistCubit, WatchlistState>(
    'should execute watchlist when function is called',
    build: () {
      when(mockGetWatchlist.execute())
          .thenAnswer((_) async => Right(tMovieList));
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
          .thenAnswer((_) async => Right(tMovieList));
      return cubit;
    },
    act: (cubit) => cubit.fetchWatchlist(),
    expect: () => [
      WatchlistLoading(),
      WatchlistLoaded(tMovieList),
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
        when(mockGetWatchListStatus.execute(tMovie.id))
            .thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.loadWatchlistStatus(tMovie.id),
      expect: () => [const WatchlistStatus(true)],
    );
  });

  group('Save Watchlist', () {
    blocTest<WatchlistCubit, WatchlistState>(
      'should execute save watchlist when function is called',
      build: () {
        when(mockSaveWatchlist.execute(tMovie))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(tMovie.id))
            .thenAnswer((_) async => true);

        return cubit;
      },
      act: (cubit) => cubit.addWatchlist(tMovie),
      verify: (cubit) => mockSaveWatchlist.execute(tMovie),
    );
    group('Movie', () {
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist success',
        build: () {
          when(mockGetWatchListStatus.execute(tMovie.id))
              .thenAnswer((_) async => true);
          when(mockSaveWatchlist.execute(tMovie))
              .thenAnswer((_) async => const Right('Added to Watchlist'));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(tMovie),
        expect: () => [
          const WatchlistMessage('Added to Watchlist'),
          const WatchlistStatus(true),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(tMovie),
      );
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when add watchlist failed',
        build: () {
          when(mockGetWatchListStatus.execute(tMovie.id))
              .thenAnswer((_) async => false);
          when(mockSaveWatchlist.execute(tMovie))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));

          return cubit;
        },
        act: (cubit) => cubit.addWatchlist(tMovie),
        expect: () => [
          const WatchlistMessage('Failed'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) => mockSaveWatchlist.execute(tMovie),
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
        when(mockRemoveWatchlist.execute(tMovieDetail.id))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);

        return cubit;
      },
      act: (cubit) => cubit.deleteWatchlist(tMovieDetail.id),
      verify: (cubit) => verify(mockRemoveWatchlist.execute(tMovieDetail.id)),
    );

    group('Movie', () {
      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when remove watchlist success',
        build: () {
          when(mockRemoveWatchlist.execute(tMovieDetail.id))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(mockGetWatchListStatus.execute(tMovieDetail.id))
              .thenAnswer((_) async => false);

          return cubit;
        },
        act: (cubit) => cubit.deleteWatchlist(tMovieDetail.id),
        expect: () => [
          const WatchlistMessage('Removed from Watchlist'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) {
          verify(mockRemoveWatchlist.execute(tMovieDetail.id));
          verify(mockGetWatchListStatus.execute(tMovieDetail.id));
        },
      );

      blocTest<WatchlistCubit, WatchlistState>(
        'should update watchlist message when Removed from Watchlist failed',
        build: () {
          when(mockRemoveWatchlist.execute(tMovieDetail.id))
              .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
          when(mockGetWatchListStatus.execute(tMovieDetail.id))
              .thenAnswer((_) async => false);

          return cubit;
        },
        act: (cubit) => cubit.deleteWatchlist(tMovieDetail.id),
        expect: () => [
          const WatchlistMessage('Failed'),
          const WatchlistStatus(false),
        ],
        verify: (cubit) {
          verify(mockRemoveWatchlist.execute(tMovieDetail.id));
          verify(mockGetWatchListStatus.execute(tMovieDetail.id));
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
