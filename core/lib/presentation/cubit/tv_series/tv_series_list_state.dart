part of 'tv_series_list_cubit.dart';

@immutable
abstract class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  @override
  List<Object?> get props => [];
}

class TvSeriesListInitial extends TvSeriesListState {}

//Now Playing
class TvSeriesNowPlayingInitial extends TvSeriesListState {}

class TvSeriesNowPlayingLoading extends TvSeriesListState {}

class TvSeriesNowPlayingLoaded extends TvSeriesListState {
  final List<TvSeries> nowPlayingTvSeries;

  const TvSeriesNowPlayingLoaded(this.nowPlayingTvSeries);

  @override
  List<Object?> get props => [nowPlayingTvSeries];
}

class TvSeriesNowPlayingError extends TvSeriesListState {
  final String message;

  const TvSeriesNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}

//Popular
class TvSeriesPopularInitial extends TvSeriesListState {}

class TvSeriesPopularLoading extends TvSeriesListState {}

class TvSeriesPopularLoaded extends TvSeriesListState {
  final List<TvSeries> popularTvSeries;

  const TvSeriesPopularLoaded(this.popularTvSeries);

  @override
  List<Object?> get props => [popularTvSeries];
}

class TvSeriesPopularError extends TvSeriesListState {
  final String message;

  const TvSeriesPopularError(this.message);

  @override
  List<Object?> get props => [message];
}

//Top Rated
class TvSeriesTopRatedInitial extends TvSeriesListState {}

class TvSeriesTopRatedLoading extends TvSeriesListState {}

class TvSeriesTopRatedLoaded extends TvSeriesListState {
  final List<TvSeries> topRatedTv;

  const TvSeriesTopRatedLoaded(this.topRatedTv);

  @override
  List<Object?> get props => [topRatedTv];
}

class TvSeriesTopRatedError extends TvSeriesListState {
  final String message;

  const TvSeriesTopRatedError(this.message);

  @override
  List<Object?> get props => [message];
}
