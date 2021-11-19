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

  const MovieDetailLoaded(this.detailMovie);
  @override
  List<Object?> get props => [detailMovie];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationLoading extends MovieDetailState {}

class MovieRecommendationLoaded extends MovieDetailState {
  final List<Movie> recommendedMovie;

  const MovieRecommendationLoaded(this.recommendedMovie);
  @override
  List<Object?> get props => [recommendedMovie];
}

class MovieRecommendationError extends MovieDetailState {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistStatus extends MovieDetailState {
  final bool isAddedToWatchlist;

  const WatchlistStatus(this.isAddedToWatchlist);

  @override
  List<Object?> get props => [isAddedToWatchlist];
}

class WatchlistMessage extends MovieDetailState {
  final String watchlistMessage;

  const WatchlistMessage(this.watchlistMessage);

  @override
  List<Object?> get props => [watchlistMessage];
}
