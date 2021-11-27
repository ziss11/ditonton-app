part of 'search_movies_bloc.dart';

@immutable
abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object?> get props => [];
}

class SearchMoviesInitial extends SearchMoviesState {}

class SearchMoviesLoading extends SearchMoviesState {}

class SearchMoviesHasData extends SearchMoviesState {
  final List<Movie> result;

  const SearchMoviesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class SearchMoviesError extends SearchMoviesState {
  final String message;

  const SearchMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
