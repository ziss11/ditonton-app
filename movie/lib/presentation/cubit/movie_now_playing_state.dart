part of 'movie_now_playing_cubit.dart';

@immutable
abstract class MovieNowPlayingState extends Equatable {
  const MovieNowPlayingState();

  @override
  List<Object?> get props => [];
}

class MovieNowPlayingInitial extends MovieNowPlayingState {}

class MovieNowPlayingLoading extends MovieNowPlayingState {}

class MovieNowPlayingLoaded extends MovieNowPlayingState {
  final List<Movie> nowPlayingMovie;

  const MovieNowPlayingLoaded(this.nowPlayingMovie);

  @override
  List<Object?> get props => [nowPlayingMovie];
}

class MovieNowPlayingError extends MovieNowPlayingState {
  final String message;

  const MovieNowPlayingError(this.message);

  @override
  List<Object?> get props => [message];
}
