import 'package:core/utils/exception.dart';
import 'package:movie/data/models/movie_table.dart';
import 'package:watchlist/watchlist.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(int id);
  Future<MovieTable?> getMovieById(int id);
  Future<List<dynamic>> getWatchlistMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await databaseHelper.insertWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(int id) async {
    try {
      await databaseHelper.removeWatchlist(id);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await databaseHelper.getById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<dynamic>> getWatchlistMovies() async {
    final result = await databaseHelper.getWatchlist();
    return result.map((data) => MovieTable.fromMap(data)).toList();
  }
}
