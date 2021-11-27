import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';
import 'package:tv_series/domain/usecase/get_detail_tv_series.dart';
import 'package:tv_series/domain/usecase/get_recommendation_tv_series.dart';

part 'tv_series_detail_state.dart';

class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  final GetDetailTvSeries detailTvSeries;
  final GetRecommendationTvSeries recommendationTvSeries;

  TvSeriesDetailCubit({
    required this.detailTvSeries,
    required this.recommendationTvSeries,
  }) : super(TvSeriesDetailInitial());

  void fetchDetailTv(int id) async {
    emit(TvSeriesDetailLoading());

    final result = await detailTvSeries.execute(id);
    final recommendation = await recommendationTvSeries.execute(id);

    result.fold(
      (failure) async {
        emit(TvSeriesDetailError(failure.message));
      },
      (detail) async {
        emit(TvSeriesRecommendationLoading());

        recommendation.fold(
          (failure) async {
            emit(TvSeriesRecommendationError(failure.message));
          },
          (recomendation) async {
            emit(TvSeriesDetailLoaded(detail, recomendation));
          },
        );
      },
    );
  }
}
