import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_series/episode.dart';
import 'package:core/domain/entities/tv_series/tv_series.dart';
import 'package:core/domain/entities/tv_series/tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_detail_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_recommendation_tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_episode.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_series_detail_state.dart';

class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  final GetDetailTvSeries detailTvSeries;
  final GetTvSeriesEpisode tvSeriesEpisode;
  final GetRecommendationTvSeries recommendationTvSeries;

  TvSeriesDetailCubit({
    required this.detailTvSeries,
    required this.recommendationTvSeries,
    required this.tvSeriesEpisode,
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
        emit(TvSeriesDetailLoaded(detail));
        emit(TvSeriesRecommendationLoading());

        recommendation.fold(
          (failure) async {
            emit(TvSeriesRecommendationError(failure.message));
          },
          (data) async {
            emit(TvSeriesRecommendationLoaded(data));
          },
        );
      },
    );
  }

  void fetchEpisodeTv(int id, int season) async {
    emit(TvSeriesEpisodeLoading());

    final episode = await tvSeriesEpisode.execute(id, season);

    episode.fold(
      (failure) async {
        emit(TvSeriesEpisodeError(failure.message));
      },
      (data) async {
        emit(TvSeriesEpisodeLoaded(data));
      },
    );
  }
}
