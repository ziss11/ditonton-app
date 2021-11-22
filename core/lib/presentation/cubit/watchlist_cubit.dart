import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/get_watchlist.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetWatchlist watchlist;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const addWatchlistMessage = 'Added to Watchlist';
  static const removeWatchlistMessage = 'Remove to Watchlist';

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
        if (data.isNotEmpty) {
          emit(WatchlistLoaded(data));
        } else {
          emit(WatchlistInitial());
        }
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
