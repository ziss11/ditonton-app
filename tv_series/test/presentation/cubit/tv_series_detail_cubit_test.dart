import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/usecase/get_detail_tv_series.dart';
import 'package:tv_series/domain/usecase/get_recommendation_tv_series.dart';
import 'package:tv_series/presentation/cubit/tv_series_detail_cubit.dart';

import '../../dummy_data/dummy_tv_series_object.dart';
import 'tv_series_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetDetailTvSeries,
  GetRecommendationTvSeries,
])
void main() {
  late TvSeriesDetailCubit cubit;
  late MockGetDetailTvSeries mockGetDetailTvSeries;
  late MockGetRecommendationTvSeries mockGetRecommendationTvSeries;

  setUp(() {
    mockGetRecommendationTvSeries = MockGetRecommendationTvSeries();
    mockGetDetailTvSeries = MockGetDetailTvSeries();
    cubit = TvSeriesDetailCubit(
      detailTvSeries: mockGetDetailTvSeries,
      recommendationTvSeries: mockGetRecommendationTvSeries,
    );
  });

  group('Get Tv Series Detail and Recommendation Tv Series', () {
    test('initial state should be empty', () {
      expect(cubit.state, TvSeriesDetailInitial());
    });
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'should execute tv detail when function called',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      verify: (cubit) => mockGetDetailTvSeries.execute(testTvSeries.id),
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => Right(testTvSeriesList));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesRecommendationLoading(),
        TvSeriesDetailLoaded(
          testTvSeriesDetail,
          testTvSeriesList,
        ),
      ],
      verify: (cubit) {
        mockGetDetailTvSeries.execute(testTvSeries.id);
        mockGetRecommendationTvSeries.execute(testTvSeries.id);
      },
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Error] when data is gotten successfully',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetRecommendationTvSeries.execute(testTvSeries.id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      expect: () => [
        TvSeriesDetailLoading(),
        const TvSeriesDetailError('Server Failure'),
      ],
      verify: (cubit) {
        mockGetDetailTvSeries.execute(testTvSeries.id);
        mockGetRecommendationTvSeries.execute(testTvSeries.id);
      },
    );
    blocTest<TvSeriesDetailCubit, TvSeriesDetailState>(
      'Should emit [Loading, Error] when recommendation is gotten successfully',
      build: () {
        when(mockGetDetailTvSeries.execute(testTvSeries.id))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(testTvSeries.id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));

        return cubit;
      },
      act: (cubit) => cubit.fetchDetailTv(testTvSeries.id!),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesRecommendationLoading(),
        const TvSeriesRecommendationError('Server Failure'),
      ],
      verify: (cubit) {
        mockGetDetailTvSeries.execute(testTvSeries.id);
        mockGetRecommendationTvSeries.execute(testTvSeries.id);
      },
    );
  });
}
