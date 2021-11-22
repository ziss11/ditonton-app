part of 'movie_list_cubit.dart';

@immutable
abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

//Now Playing
class MovieNowPlayingInitial extends MovieListState {}

class MovieNowPlayingLoading extends MovieListState {}

class MovieNowPlayingLoaded extends MovieListState {
  final List<Movie> nowPlayingMovie;

  const MovieNowPlayingLoaded(this.nowPlayingMovie);

  @override
  List<Object?> get props => [nowPlayingMovie];
}

class MovieNowPlayingError extends MovieListState {
  final String message;

  const MovieNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}

//Popular
class MoviePopularInitial extends MovieListState {}

class MoviePopularLoading extends MovieListState {}

class MoviePopularLoaded extends MovieListState {
  final List<Movie> popularMovie;

  const MoviePopularLoaded(this.popularMovie);

  @override
  List<Object?> get props => [popularMovie];
}

class MoviePopularError extends MovieListState {
  final String message;

  const MoviePopularError(this.message);

  @override
  List<Object?> get props => [message];
}

//Top Rated
class MovieTopRatedInitial extends MovieListState {}

class MovieTopRatedLoading extends MovieListState {}

class MovieTopRatedLoaded extends MovieListState {
  final List<Movie> topRatedMovie;

  const MovieTopRatedLoaded(this.topRatedMovie);

  @override
  List<Object?> get props => [topRatedMovie];
}

class MovieTopRatedError extends MovieListState {
  final String message;

  const MovieTopRatedError(this.message);

  @override
  List<Object?> get props => [message];
}
