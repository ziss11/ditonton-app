part of 'tv_series_top_rated_cubit.dart';

abstract class TvSeriesTopRatedState extends Equatable {
  const TvSeriesTopRatedState();

  @override
  List<Object?> get props => [];
}

class TvSeriesTopRatedInitial extends TvSeriesTopRatedState {}

class TvSeriesTopRatedLoading extends TvSeriesTopRatedState {}

class TvSeriesTopRatedLoaded extends TvSeriesTopRatedState {
  final List<TvSeries> topRatedTv;

  const TvSeriesTopRatedLoaded(this.topRatedTv);

  @override
  List<Object?> get props => [topRatedTv];
}

class TvSeriesTopRatedError extends TvSeriesTopRatedState {
  final String message;

  const TvSeriesTopRatedError(this.message);

  @override
  List<Object?> get props => [message];
}
