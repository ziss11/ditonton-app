part of 'movie_top_rated_cubit.dart';

@immutable
abstract class MovieTopRatedState extends Equatable {
  const MovieTopRatedState();

  @override
  List<Object?> get props => [];
}

class MovieTopRatedInitial extends MovieTopRatedState {}

class MovieTopRatedLoading extends MovieTopRatedState {}

class MovieTopRatedLoaded extends MovieTopRatedState {
  final List<Movie> topRatedMovie;

  const MovieTopRatedLoaded(this.topRatedMovie);

  @override
  List<Object?> get props => [topRatedMovie];
}

class MovieTopRatedError extends MovieTopRatedState {
  final String message;

  const MovieTopRatedError(this.message);

  @override
  List<Object?> get props => [message];
}
