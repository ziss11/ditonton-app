part of 'search_tv_series_cubit.dart';

@immutable
abstract class SearchTvSeriesState extends Equatable {
  const SearchTvSeriesState();

  @override
  List<Object?> get props => [];
}

class SearchTvSeriesInitial extends SearchTvSeriesState {}

class SearchTvSeriesLoading extends SearchTvSeriesState {}

class SearchTvSeriesLoaded extends SearchTvSeriesState {
  final List<TvSeries> result;

  const SearchTvSeriesLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchTvSeriesError extends SearchTvSeriesState {
  final String message;

  const SearchTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
