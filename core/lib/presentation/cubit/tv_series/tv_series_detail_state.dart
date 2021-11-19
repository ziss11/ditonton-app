part of 'tv_series_detail_cubit.dart';

@immutable
abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object?> get props => [];
}

class TvSeriesDetailInitial extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;

  const TvSeriesDetailLoaded(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvSeriesEpisodeLoading extends TvSeriesDetailState {}

class TvSeriesEpisodeLoaded extends TvSeriesDetailState {
  final List<Episode> tvSeriesEpisode;

  const TvSeriesEpisodeLoaded(this.tvSeriesEpisode);

  @override
  List<Object?> get props => [tvSeriesEpisode];
}

class TvSeriesEpisodeError extends TvSeriesDetailState {
  final String message;

  const TvSeriesEpisodeError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvSeriesRecommendationLoading extends TvSeriesDetailState {}

class TvSeriesRecommendationLoaded extends TvSeriesDetailState {
  final List<TvSeries> tvSeriesDetail;

  const TvSeriesRecommendationLoaded(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class TvSeriesRecommendationError extends TvSeriesDetailState {
  final String message;

  const TvSeriesRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}
