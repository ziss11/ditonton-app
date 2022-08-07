part of 'search_tv_series_bloc.dart';

@immutable
abstract class SearchTvSeriesEvent extends Equatable {
  const SearchTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class OnChangeTvQuery extends SearchTvSeriesEvent {
  final String query;

  const OnChangeTvQuery(this.query);

  @override
  List<Object?> get props => [query];
}
