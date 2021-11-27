part of 'search_movies_bloc.dart';

@immutable
abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();

  @override
  List<Object?> get props => [];
}

class OnChangeMovieQuery extends SearchMoviesEvent {
  final String query;

  const OnChangeMovieQuery(this.query);

  @override
  List<Object?> get props => [query];
}
