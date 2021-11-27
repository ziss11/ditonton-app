part of 'movie_detail_cubit.dart';

@immutable
abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail detailMovie;
  final List<Movie> recomendationMovie;

  const MovieDetailLoaded(this.detailMovie, this.recomendationMovie);
  @override
  List<Object?> get props => [detailMovie, recomendationMovie];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationLoading extends MovieDetailState {}

class MovieRecommendationError extends MovieDetailState {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}
