import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

class GetWatchlist {
  final MovieRepository _repository;

  GetWatchlist(this._repository);

  Future<Either<Failure, List<dynamic>>> execute() {
    return _repository.getWatchlist();
  }
}
