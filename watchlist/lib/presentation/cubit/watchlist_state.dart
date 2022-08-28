part of 'watchlist_cubit.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<dynamic> watchlist;

  const WatchlistLoaded(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}

class WatchlistError extends WatchlistState {
  final String error;

  const WatchlistError(this.error);

  @override
  List<Object?> get props => [error];
}

class WatchlistStatus extends WatchlistState {
  final bool isAddedToWatchlist;

  const WatchlistStatus(this.isAddedToWatchlist);

  @override
  List<Object?> get props => [isAddedToWatchlist];
}

class WatchlistMessage extends WatchlistState {
  final String watchlistMessage;

  const WatchlistMessage(this.watchlistMessage);

  @override
  List<Object?> get props => [watchlistMessage];
}
