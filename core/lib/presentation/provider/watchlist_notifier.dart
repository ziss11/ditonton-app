import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/usecases/get_watchlist.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  late List<Movie> _watchlist;
  List<Movie> get watchlist => _watchlist;

  late RequestState _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({
    required this.getWatchlist,
  });

  final GetWatchlist getWatchlist;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.loaded;
        _watchlist = List.from(
          moviesData.map(
            (movie) => Movie.watchlist(
              id: movie.id,
              overview: movie.overview,
              posterPath: movie.posterPath,
              title: movie.title,
              type: movie.type,
            ),
          ),
        );
        notifyListeners();
      },
    );
  }
}
