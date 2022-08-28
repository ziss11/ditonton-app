import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:watchlist/domain/usecases/get_watchlist.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetWatchlist watchlist;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const addWatchlistMessage = 'Added to Watchlist';
  static const removeWatchlistMessage = 'Removed from Watchlist';

  WatchlistCubit({
    required this.watchlist,
    required this.getWatchListStatus,
    required this.removeWatchlist,
    required this.saveWatchlist,
  }) : super(WatchlistInitial());

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistStatus(result));
  }

  void fetchWatchlist() async {
    emit(WatchlistLoading());

    final result = await watchlist.execute();

    result.fold(
      (failure) async {
        emit(WatchlistError(failure.message));
      },
      (data) async {
        emit(WatchlistLoaded(data));
      },
    );
  }

  void addWatchlist(Movie movie) async {
    final result = await saveWatchlist.execute(movie);
    await result.fold(
      (failure) async {
        emit(WatchlistMessage(failure.message));
      },
      (message) async {
        emit(WatchlistMessage(message));
      },
    );

    loadWatchlistStatus(movie.id);
  }

  void deleteWatchlist(int id) async {
    final result = await removeWatchlist.execute(id);
    await result.fold(
      (failure) async {
        emit(WatchlistMessage(failure.message));
      },
      (message) async {
        emit(WatchlistMessage(message));
      },
    );

    loadWatchlistStatus(id);
  }
}
