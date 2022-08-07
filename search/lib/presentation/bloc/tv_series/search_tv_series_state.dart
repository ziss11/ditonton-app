part of 'search_tv_series_bloc.dart';

@immutable
abstract class SearchTvSeriesState extends Equatable {
  const SearchTvSeriesState();

  @override
  List<Object?> get props => [];
}

class SearchTvSeriesInitial extends SearchTvSeriesState {}

class SearchTvSeriesLoading extends SearchTvSeriesState {}

class SearchTvSeriesHasData extends SearchTvSeriesState {
  final List<TvSeries> result;

  const SearchTvSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchTvSeriesError extends SearchTvSeriesState {
  final String message;

  const SearchTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
