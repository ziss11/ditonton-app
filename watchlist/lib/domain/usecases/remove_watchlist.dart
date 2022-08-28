import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(int id) {
    return repository.removeWatchlist(id);
  }
}
