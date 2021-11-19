part of 'movie_now_playing_cubit.dart';

@immutable
abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

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
