import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/usecase/get_tv_series_episode.dart';
import 'package:tv_series/presentation/cubit/episode_cubit.dart';

import '../../dummy_data/dummy_tv_series_object.dart';
import 'episode_cubit_test.mocks.dart';

@GenerateMocks([GetTvSeriesEpisode])
void main() {
  late EpisodeCubit cubit;
  late MockGetTvSeriesEpisode mockGetTvSeriesEpisode;

  setUp(() {
    mockGetTvSeriesEpisode = MockGetTvSeriesEpisode();
    cubit = EpisodeCubit(
      tvSeriesEpisode: mockGetTvSeriesEpisode,
    );
  });

  group('Get Episode Tv Series', () {
    blocTest<EpisodeCubit, EpisodeState>(
      'should get data from the usecase',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1))
            .thenAnswer((_) async => const Right(<Episode>[]));
        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
    blocTest<EpisodeCubit, EpisodeState>(
      'Should emit [Loading, Loaded] when data is gotten successfuly',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1))
            .thenAnswer((_) async => Right(testEpisodeList));

        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      expect: () => [
        EpisodeLoading(),
        EpisodeLoaded(testEpisodeList),
      ],
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );

    blocTest<EpisodeCubit, EpisodeState>(
      'Should emit [Loading, Initial] when data is gotten successfuly',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1))
            .thenAnswer((_) async => const Right([]));

        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      expect: () => [
        EpisodeLoading(),
        EpisodeInitial(),
      ],
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
    blocTest<EpisodeCubit, EpisodeState>(
      'Should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetTvSeriesEpisode.execute(1, 1)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchEpisodeTv(1, 1),
      expect: () => [
        EpisodeLoading(),
        const EpisodeError('Server Failure'),
      ],
      verify: (cubit) => mockGetTvSeriesEpisode.execute(1, 1),
    );
  });
}
